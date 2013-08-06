//
//  WebViewController.m
//  iRepEmulator
//
//  Created by Bergman, Adam on 7/25/13.
//  Copyright (c) 2013 Adam Bergman. All rights reserved.
//

#import "WebViewController.h"
#import "ABUtilities.h"
#import "lib/RegexKitLite.h"

@interface WebViewController ()

@end

@implementation WebViewController

static NSString *KEY_PREFS_SERVER = @"server_preference";

@synthesize web, buttonAction, buttonBack, buttonForward, buttonServerCancel, buttonServerOkay, buttonTriangle, textServer, modalServerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    // Hacky regular expression to parse for an Apache directory index so that thumbnails and
    // fake iRep navigation can be created from the directory tree
    
    // TODO: Add parsing for IIS directory listings
    
    NSRange range;
    NSString *regExIndex = @"<h1>Index of (.*?)</h1>";
    range = [html rangeOfString:regExIndex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound)
    {
        // TODO: At this point the user should probably be prompted to ask
        // whether or not this directory listing should be parsed as an iRep presentaiton
        
        NSLog(@"Is Apache Index %@", [html substringWithRange:range]);
        
        NSString *regEx = @"href=[\"'](.*?)/[\"']";
        int count = 0;
        for(NSString *match in [html componentsMatchedByRegex:regEx])
        {
            if(count == 0)
            {
                // Skip Parent directory
                NSLog(@"Skipping parent directory link... %@", match);
            }else{
                // Found directory, assume it's a Veeva slide
                NSLog(@"Found Directory %@", match);
            }
            count++;
        }
    } else {
        NSLog(@"Is not apache index.");
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
    UIActionSheet *popupSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"Refresh Page", @"Server Settings", nil];
    
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
    self.textServer.text = [ABUtilities getUserDefaultWithKey:KEY_PREFS_SERVER];
    [self.textServer becomeFirstResponder];
    modalServerView.hidden = FALSE;
}

- (void)hideServerModal:(BOOL)saveValueAndReload
{
    if(saveValueAndReload)
    {
        [ABUtilities setUserDefaultByKey:KEY_PREFS_SERVER withValue:self.textServer.text];
        [self navigateToServerPreference];
    }
    [self.textServer resignFirstResponder];
    modalServerView.hidden = TRUE;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Goto the default page
    [self navigateToServerPreference];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
