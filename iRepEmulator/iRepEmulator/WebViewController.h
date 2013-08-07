//
//  WebViewController.h
//  iRepEmulator
//
//  Created by Bergman, Adam on 7/25/13.
//  Copyright (c) 2013 Adam Bergman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iRepPresentation;

@interface WebViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate, UIWebViewDelegate, UIAlertViewDelegate>

@property (nonatomic) IBOutlet UIWebView *web;

@property (nonatomic) IBOutlet UIButton *buttonAction;
@property (nonatomic) IBOutlet UIButton *buttonBack;
@property (nonatomic) IBOutlet UIButton *buttonForward;
@property (nonatomic) IBOutlet UIButton *buttonTriangle;
@property (nonatomic) IBOutlet UIImageView *imageTriangle;

@property (nonatomic) IBOutlet UIView *viewModal;

@property (nonatomic) IBOutlet UIView *viewServer;
@property (nonatomic) IBOutlet UIButton *buttonServerOkay;
@property (nonatomic) IBOutlet UIButton *buttonServerCancel;
@property (nonatomic) IBOutlet UITextField *textServer;

@property (nonatomic) IBOutlet UIView *viewSlides;
@property (nonatomic) IBOutlet UIScrollView *viewSlideScroll;

@property (nonatomic) iRepPresentation *irep;


- (IBAction)buttonTriangleTouched:(id)sender;
- (IBAction)buttonActionTouched:(id)sender;
- (IBAction)buttonForwardTouched:(id)sender;
- (IBAction)buttonBackTouched:(id)sender;

- (IBAction)buttonServerOkayTouched:(id)sender;
- (IBAction)buttonServerCancelTouched:(id)sender;

@end
