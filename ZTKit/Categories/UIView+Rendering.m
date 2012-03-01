//
//  UIView+Rendering.m
//  ZTKit
//
//  Created by Zachry Thayer on 9/22/11.
//  Copyright 2011 Zachry Thayer. All rights reserved.
//

#import "UIView+Rendering.h"

@implementation UIView (Rendering)

+ (UIImage *)screenShot:(UIView *)aView inRect:(CGRect)aRect
{
    // Arbitrarily masks to 40%. Use whatever level you like
    UIGraphicsBeginImageContext(aRect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, -aRect.origin.y);
    
	[aView.layer renderInContext:context];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextSetRGBFillColor (context, 0, 0, 0, 0.4f);
    CGContextFillRect (context, aRect);
    UIGraphicsEndImageContext();
    
    return image;
}

+ (CALayer *)createLayerFromView:(UIView *)aView inRect:(CGRect)aRect
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
    imageLayer.frame = (CGRect){.size = aRect.size};
    UIImage *shot = [self screenShot:aView inRect:aRect];
    imageLayer.contents = (id) shot.CGImage;
    
    return imageLayer;
}

- (UIImage *)screenShotInRect:(CGRect)aRect
{
    
    return [UIView screenShot:self inRect:aRect];
    
}

- (CALayer *)createLayerFromRect:(CGRect)aRect
{
    
    return [UIView createLayerFromView:self inRect:aRect];
    
}

- (UIImage *) UIImage
{
    return [self screenShotInRect:self.bounds];
}

@end
