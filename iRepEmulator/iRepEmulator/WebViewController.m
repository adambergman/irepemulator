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

@synthesize web;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Goto the default page
    // TODO: This should happen outside of viewDidLoad
    NSString *url = [ABUtilities getUserDefaultWithKey:@"server_preference"];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
