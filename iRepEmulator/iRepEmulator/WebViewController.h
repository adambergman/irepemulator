//
//  WebViewController.h
//  iRepEmulator
//
//  Created by Bergman, Adam on 7/25/13.
//  Copyright (c) 2013 Adam Bergman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIActionSheetDelegate>

@property (nonatomic) IBOutlet UIWebView *web;
@property (nonatomic) IBOutlet UIButton *buttonAction;
@property (nonatomic) IBOutlet UIButton *buttonBack;
@property (nonatomic) IBOutlet UIButton *buttonForward;
@property (nonatomic) IBOutlet UIButton *buttonTriangle;

- (IBAction)buttonActionTouched:(id)sender;

@end
