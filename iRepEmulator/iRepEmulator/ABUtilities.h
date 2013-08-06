//
//  ABUtilities.h
//  iRepEmulator
//
//  Created by Bergman, Adam on 7/26/13.
//  Copyright (c) 2013 Adam Bergman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABUtilities : NSObject


// Gets the value in Settings.bundle (Root.plist) for specified key
+ (NSString *)getUserDefaultWithKey:(NSString *)key;

// Sets a value for specified key in Settings.bundle
+ (BOOL)setUserDefaultByKey:(NSString *)key withValue:(id)value;

@end
