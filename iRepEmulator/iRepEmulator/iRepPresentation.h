//
//  SlideCollection.h
//  iRepEmulator
//
//  Created by Bergman, Adam on 8/6/13.
//  Copyright (c) 2013 Adam Bergman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iRepPresentation : NSObject

@property (nonatomic) NSMutableArray *slides;


//
//  Static Methods
//

// Parse HTML of Directory Listing in to slides property
+ (iRepPresentation *)iRepPresentationWithDirectoryListing:(NSString *)html url:(NSURL *)url;

// Find out if given HTML is a directory listing
+ (BOOL)isDirectoryListing:(NSString *)html;

@end
