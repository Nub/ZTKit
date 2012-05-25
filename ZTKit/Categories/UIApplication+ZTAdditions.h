//
//  UIApplication+ZTAdditions.h
//  ZTKit
//
//  Created by Zachry Thayer on 5/22/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (ZTAdditions)

- (UIView *)keyboardView;

- (NSString*)applicationDirectory:(NSSearchPathDirectory)searchPath;

//- (NSString*)documentsRelativePath:(NSString)relativePath;
//- (NSString*)privateRelativePath:(NSString)relativePath;
//- (NSString*)cacheRelativePath:(NSString)relativePath;
//- (NSString*)tempRelativePath:(NSString)relativePath;

@end
