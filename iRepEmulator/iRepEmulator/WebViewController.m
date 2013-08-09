//
//  WebViewController.m
//  iRepEmulator
//
//  Created by Bergman, Adam on 7/25/13.
//  Copyright (c) 2013 Adam Bergman. All rights reserved.
//

#import "WebViewController.h"
#import "ABUtilities.h"
#import "iRepPresentation.h"

@interface WebViewController ()

@end

@implementation WebViewController

static NSString *KEY_PREFS_SERVER = @"server_preference";

@synthesize web, buttonAction, buttonBack, buttonForward, buttonServerCancel, buttonServerOkay, buttonTriangle, textServer, viewModal, irep, viewServer, viewSlides, viewSlideScroll, imageTriangle, shouldEatGestures, slideIndex, panStartLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.shouldEatGestures = FALSE;
        slideIndex = 0;
    }
    return self;
}

// UIWebViewDelegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Somewhat of a hack to grab the body HTML from the UIWebView using JavaScript
    // Apple does not provide a obj-c method to grab the source HTML using the UIWebView
    // and this avoids a secondary request for each page load.
    
    NSString *html = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    
    if([iRepPresentation isDirectoryListing:html])
    {
        // TODO: At this point the user should probably be prompted to ask
        // whether or not this directory listing should be parsed as an iRep presentaiton
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Directory Listing Detected" message:@"This page appears to be a directory listing. Do you wish to parse it as if folders are iRep Key Messages?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Parse", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self buildFilmstrip];
    }
}

- (void)buildFilmstrip
{
    // TODO: Display HUD indicator
    
    // TODO: This method could be separated out so that initializing the "irep" variable
    // and the parsing happens in another function which will then make the call to build the filmstrip
    
    // Somewhat of a hack to grab the body HTML from the UIWebView using JavaScript
    // Apple does not provide a obj-c method to grab the source HTML using the UIWebView
    // and this avoids a secondary request for each page load.
    
    NSString *html = [web stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    
    if((irep = [iRepPresentation iRepPresentationWithDirectoryListing:html url:[web.request URL]]))
    {
        [[viewSlideScroll subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        int i = 0;
        
        float imageWidth = 200.0f;
        float imageHeight = 150.0f;
        float viewWidth = 200.0f;
        float viewHeight = 200.0f;
        float padding = 20.0f;
        
        for(NSMutableDictionary *slide in irep.slides)
        {
            UIView *slideView = [[UIView alloc] initWithFrame:CGRectMake(viewWidth * i + padding * i + padding / 2, 10.0f, viewWidth, viewHeight)];
            
            // TODO: If image doesn't exist a default image should be loaded
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageWidth, imageHeight)];
            NSData *imageData = [NSData dataWithContentsOfURL:[slide objectForKey:@"url_thumbnail"]];
            imageView.image = [UIImage imageWithData:imageData];
            [slideView addSubview:imageView];
            
            UILabel *slideLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 155.0f, viewWidth - 20.0f, 20.0f)];
            [slideLabel setBackgroundColor:[UIColor clearColor]];
            [slideLabel setTextColor:[UIColor whiteColor]];
            [slideLabel setTextAlignment:NSTextAlignmentCenter];
            [slideLabel setFont:[UIFont systemFontOfSize:12.0f]];
            
            [slideLabel setText:[slide objectForKey:@"name"]];
            [slideView addSubview:slideLabel];
            
            UIButton *slideButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
            [slideButton addTarget:self action:@selector(slideSelected:) forControlEvents:UIControlEventTouchUpInside];
            slideButton.tag = i;
            [slideView addSubview:slideButton];
            
            [viewSlideScroll addSubview:slideView];
            viewSlideScroll.contentSize = CGSizeMake(viewWidth * i + padding * i + viewWidth + padding/2, 200);
            i++;
        }
        
        [self showFilmStrip];
        
        // TODO: Show HUD confirmation
    }
}

- (void)gotoCurrentSlideIndex
{
    if(slideIndex < 0){ slideIndex = 0; return; }
    if(slideIndex >= irep.slides.count){ slideIndex = irep.slides.count - 1; return; }
        
    NSDictionary *slide = [irep.slides objectAtIndex:self.slideIndex];
    if(slide)
    {
        // TODO: Verify that key exists before using the URL
        [web loadRequest:[NSURLRequest requestWithURL:[slide objectForKey:@"url_html"]]];
        [self hideFilmStrip];
    }
}

- (IBAction)slideSelected:(id)sender
{
    if([sender isKindOfClass:[UIButton class]])
    {
        UIButton *senderButton = (UIButton *)sender;
        self.slideIndex = senderButton.tag;
        [self gotoCurrentSlideIndex];
    }
}

- (IBAction)buttonTriangleTouched:(id)sender
{
    if(viewSlides.hidden)
    {
        [self showFilmStrip];
    }else{
        [self hideFilmStrip];
    }
}


- (IBAction)buttonForwardTouched:(id)sender
{
    [web goForward];
}

- (IBAction)buttonBackTouched:(id)sender
{
    [web goBack];
}

- (IBAction)buttonActionTouched:(id)sender
{
    NSString *gestureInfo = shouldEatGestures ? @"Swipe Navigation: ON" : @"Swipe Navigation: OFF";
    
    UIActionSheet *popupSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"Refresh Page", gestureInfo, @"Server Settings", nil];
    
    popupSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [popupSheet showFromRect:buttonAction.bounds inView:self.view animated:YES];
}

// UIActionSheetDelegate method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {
        case 0:
            [web reload];
            break;
            
        case 1:
            shouldEatGestures = !shouldEatGestures;
            // TODO: Show HUD confirmation
            break;
            
        case 2:
            [self showServerModal];
            break;
    }
}

// UITextFieldDelegate method, handles Done button on keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideServerModal:TRUE];
    return TRUE;
}

- (IBAction)buttonServerOkayTouched:(id)sender
{
    [self hideServerModal:TRUE];
}

- (IBAction)buttonServerCancelTouched:(id)sender
{
    [self hideServerModal];
}

- (void)showServerModal
{
    // TODO: Animate
    
    self.textServer.text = [ABUtilities getUserDefaultWithKey:KEY_PREFS_SERVER];
    [self.textServer becomeFirstResponder];
    viewModal.hidden = FALSE;
    viewServer.hidden = FALSE;
    imageTriangle.hidden = TRUE;
    buttonTriangle.hidden = TRUE;
}

- (void)hideServerModal:(BOOL)saveValueAndReload
{
    // TODO: Animate
    
    if(saveValueAndReload)
    {
        if([self.textServer.text rangeOfString:@"http://"].location == NSNotFound &&
           [self.textServer.text rangeOfString:@"https://"].location == NSNotFound)
        {
            self.textServer.text = [NSString stringWithFormat:@"http://%@", self.textServer.text];
        }
        [ABUtilities setUserDefaultByKey:KEY_PREFS_SERVER withValue:self.textServer.text];
        [self navigateToServerPreference];
    }
    [self.textServer resignFirstResponder];
    viewModal.hidden = TRUE;
    viewServer.hidden = TRUE;
    imageTriangle.hidden = FALSE;
    buttonTriangle.hidden = FALSE;
}

- (void)hideServerModal
{
    [self hideServerModal:FALSE];
}

- (void)navigateToServerPreference
{
    NSString *url = [ABUtilities getUserDefaultWithKey:KEY_PREFS_SERVER];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)showFilmStrip
{
    // TODO: Animate
    
    viewModal.hidden = FALSE;
    viewSlides.hidden = FALSE;
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -1 * CGRectGetHeight(viewSlides.frame));
    transform = CGAffineTransformRotate(transform, 180.0f * M_PI/180);
    
    self.imageTriangle.transform = transform;
    self.buttonTriangle.transform = transform;
}

- (void)hideFilmStrip
{
    // TODO: Animate
    
    viewModal.hidden = TRUE;
    viewSlides.hidden = TRUE;
    
    self.imageTriangle.transform = CGAffineTransformIdentity;
    
    self.buttonTriangle.transform = CGAffineTransformIdentity;    
}

- (void)swipeMethod:(UISwipeGestureRecognizer *)gestureRecognizer
{
    NSLog(@"Swiped.");
    
    if(gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        slideIndex++;
    }
    
    if(gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        slideIndex--;
    }
    
    [self gotoCurrentSlideIndex];
}


- (void)panGesture:(UIPanGestureRecognizer *)sender
{
    if(!shouldEatGestures){ return; }
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        panStartLocation = [sender locationInView:self.view];
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint stopLocation = [sender locationInView:self.view];
        CGFloat dx = stopLocation.x - panStartLocation.x;
        CGFloat dy = stopLocation.y - panStartLocation.y;
        CGFloat distance = sqrt(dx*dx + dy*dy );
        NSLog(@"Distance: %f", distance);
        
        if(distance > 500)
        {
            float yTolerence = fabsf(panStartLocation.y - stopLocation.y);
            //NSLog(@"yTolerence = %f", yTolerence);
            if(yTolerence > 40.0f)
            {
                return;
            }
            if(panStartLocation.x > stopLocation.x)
            {
                // right to left
                slideIndex++;
            }else{
                // left to right
                slideIndex--;
            }
            [self gotoCurrentSlideIndex];
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Goto the default page
    [self navigateToServerPreference];
    
    UIPanGestureRecognizer *panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    panGestureRec.delegate = self;
    [[self web] addGestureRecognizer:panGestureRec];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
