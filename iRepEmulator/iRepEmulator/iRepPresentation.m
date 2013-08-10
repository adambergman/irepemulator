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

- (id)init
{
    if((self = [super init]))
    {
        self.slides =  [[NSMutableArray alloc] init];
    }
    return self;
}

+ (iRepPresentation *)iRepPresentationWithDirectoryListing:(NSString *)html url:(NSURL *)url
{
    // Hacky regular expression to parse for an Apache directory index so that thumbnails and
    // fake iRep navigation can be created from the directory tree
    
    // TODO: Add parsing for IIS directory listings
    
    if([iRepPresentation isDirectoryListing:html])
    {
        iRepPresentation *temp = [[iRepPresentation alloc] init];
        
        NSString *regEx = @"href=[\"'](?!\\.svn|_globals|\\.git|\\.\\./)(.*?)/[\"']";
        int count = 0;
        for(NSString *match in [html componentsMatchedByRegex:regEx])
        {
            if(count == 0 && [iRepPresentation hasParentDirectoryInListing:html])
            {
                // Skip Parent directory
                // NSLog(@"Skipping parent directory link... %@", match);
            }else{
                // Found directory, assume it's a Veeva slide
                // TODO: match HTML and thumb file to check if this is actually a slide
                
                NSMutableDictionary *slide = [[NSMutableDictionary alloc] init];
                
                // Remove href=" from beginning and /" from the end
                NSString *matchParse = [match stringByReplacingOccurrencesOfRegex:@"href=[\"']" withString:@""];
                matchParse = [matchParse stringByReplacingOccurrencesOfRegex:@"/[\"']" withString:@""];
                matchParse = [iRepPresentation stringByDecodingURLFormat:matchParse];
                
                // Save url encoded folder for look ups later, get HTML, thumbnail, and image file paths
                NSURL *folderUrl = [url URLByAppendingPathComponent:matchParse];
                NSURL *htmlUrl = [folderUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.html", matchParse]];
                NSURL *thumbnailUrl = [folderUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"%@-thumb.png", matchParse]];
                NSURL *imageUrl = [folderUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", matchParse]];
                
                // URL decode the directory so it can be used as the name
                NSString *matchName = [iRepPresentation stringByDecodingURLFormat:matchParse];
                
                // Set objects in slide dictionary
                [slide setObject:matchParse forKey:@"folder"];
                [slide setObject:folderUrl forKey:@"url_folder"];
                [slide setObject:htmlUrl forKey:@"url_html"];
                [slide setObject:thumbnailUrl forKey:@"url_thumbnail"];
                [slide setObject:imageUrl forKey:@"url_image"];
                [slide setObject:matchName forKey:@"name"];
                
                //NSLog(@"%@ => %@", matchParse, matchName);
                //NSLog(@"%@", [slide objectForKey:@"url_html"]);
                
                // Add slide to collection
                [temp.slides addObject:slide];
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

+ (BOOL)hasParentDirectoryInListing:(NSString *)html
{
    // TODO: Add parsing for IIS directory listings
    
    NSRange range;
    NSString *regExIndex = @"<h1>Index of /</h1>";
    range = [html rangeOfString:regExIndex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound)
    {
        return FALSE;
    }
    return TRUE;
}

+ (NSString *)stringByDecodingURLFormat:(NSString *)string
{
    // TODO: Convert this to category on NSString
    
    NSString *result = [(NSString *)string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end
