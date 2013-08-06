//
//  WebViewController.m
//  iRepEmulator
//
//  Created by Bergman, Adam on 7/25/13.
//  Copyright (c) 2013 Adam Bergman. All rights reserved.
//

#import "WebViewController.h"
#import "ABUtilities.h"

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
