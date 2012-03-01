//
//  UIColor+ZTKit.h
//  ZTKit
//
//  Created by Zachry Thayer on 10/6/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZTKit)

- (UIColor *)colorByChangingBrighness:(CGFloat)percent;
- (UIColor *)colorByChangingAlphaTo:(CGFloat)newAlpha;

+ (UIColor *) randomColor;

@end