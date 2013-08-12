//
//  NSString+URLDecode.m
//  iRepEmulator
//
//  Created by Bergman, Adam on 8/12/13.
//  Copyright (c) 2013 Adam Bergman. All rights reserved.
//

#import "NSString+URLDecode.h"

@implementation NSString (URLDecode)

- (NSString *)stringByDecodingURLFormat
{    
    NSString *result = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end
