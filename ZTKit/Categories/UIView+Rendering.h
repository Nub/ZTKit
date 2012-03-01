//
//  UIView+Rendering.h
//  ZTKit
//
//  Created by Zachry Thayer on 9/22/11.
//  Copyright 2011 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (Rendering)
+ (UIImage *)screenShot:(UIView *)aView inRect:(CGRect)aRect;
+ (CALayer *)createLayerFromView:(UIView *)aView inRect:(CGRect)aRect;

- (UIImage *)screenShotInRect:(CGRect)aRect;
- (CALayer *)createLayerFromRect:(CGRect)aRect;

- (UIImage *) UIImage;
@end
