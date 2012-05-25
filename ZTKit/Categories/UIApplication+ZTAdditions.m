//
//  UIApplication+ZTAdditions.m
//  ZTKit
//
//  Created by Zachry Thayer on 5/22/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "UIApplication+ZTAdditions.h"

@implementation UIApplication (ZTAdditions)

- (UIView *)keyboardView
{
    NSArray *windows = [self windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])
    {
        for (UIView *view in [window subviews])
        {
            if (!strcmp(object_getClassName(view), "UIKeyboard"))
            {
                return view;
            }
        }
    }

    return nil;
}

//- (NSString*)documentsRelativePath:(NSString)relativePath;
//- (NSString*)privateRelativePath:(NSString)relativePath;
//- (NSString*)cacheRelativePath:(NSString)relativePath;
//- (NSString*)tempRelativePath:(NSString)relativePath;

- (NSString*)applicationDirectory:(NSSearchPathDirectory)searchPath;
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(searchPath, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    BOOL isDir = NO;
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir] && isDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    return cachePath;
}

@end
