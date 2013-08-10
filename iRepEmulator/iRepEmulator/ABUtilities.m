//
//  ABUtilities.m
//  iRepEmulator
//
//  Created by Bergman, Adam on 7/26/13.
//  Copyright (c) 2013 Adam Bergman. All rights reserved.
//

#import "ABUtilities.h"

@implementation ABUtilities

+ (NSString *)getUserDefaultWithKey:(NSString *)key
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *val = nil;
    
	if (standardUserDefaults)
    {
        val = [standardUserDefaults objectForKey:key];
    }

	if (val == nil)
    {
		NSString *settingsPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Settings.bundle"];
		NSString *settingsFile = [settingsPath stringByAppendingPathComponent:@"Root.plist"];
        
		NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:settingsFile];
		NSArray *prefs = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
        
		NSDictionary *item;
		for(item in prefs)
		{
			NSString *keyValue = [item objectForKey:@"Key"];
			id defaultValue = [item objectForKey:@"DefaultValue"];
			if (keyValue && defaultValue)
            {
				[standardUserDefaults setObject:defaultValue forKey:keyValue];
				if ([keyValue compare:key] == NSOrderedSame)
					val = defaultValue;
			}
		}
		[standardUserDefaults synchronize];
	}
	return val;
}

+ (BOOL)setUserDefaultByKey:(NSString *)key withValue:(id)value
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
	if (standardUserDefaults)
    {
		[standardUserDefaults setObject:value forKey:key];
        [standardUserDefaults synchronize];
        return TRUE;
    }
    
	return FALSE;
}

@end
