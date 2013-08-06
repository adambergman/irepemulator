//
//  SlideCollection.m
//  iRepEmulator
//
//  Created by Bergman, Adam on 8/6/13.
//  Copyright (c) 2013 Adam Bergman. All rights reserved.
//

#import "iRepPresentation.h"
#import "lib/RegexKitLite.h"

@implementation iRepPresentation

+ (iRepPresentation *)iRepPresentationWithDirectoryListing:(NSString *)html
{
    // Hacky regular expression to parse for an Apache directory index so that thumbnails and
    // fake iRep navigation can be created from the directory tree
    
    // TODO: Add parsing for IIS directory listings
    
    if([iRepPresentation isDirectoryListing:html])
    {
        iRepPresentation *temp = [[iRepPresentation alloc] init];
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
                // TODO: match HTML and thumb file to check if this is actually a slide
                NSLog(@"Found Directory %@", match);
                // TODO: Create Slide
            }
            count++;
        }
        return temp;
    }
    return nil;
}

+ (BOOL)isDirectoryListing:(NSString *)html
{    
    // TODO: Add parsing for IIS directory listings

    NSRange range;
    NSString *regExIndex = @"<h1>Index of (.*?)</h1>";
    range = [html rangeOfString:regExIndex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound)
    {
        return TRUE;
    }
    return FALSE;
}

@end
