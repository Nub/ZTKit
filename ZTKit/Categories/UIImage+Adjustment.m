//
//  UIImage+Adjustment.h
//  ZTKit
//
//  Created by Zachry Thayer on 12/4/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import "UIImage+Adjustment.h"

@implementation UIImage (Adjustment)

- (UIImage*)imageFittingToRect:(CGRect)aRect maintainAspect:(BOOL)maintainAspect
{
    
    CGFloat w = aRect.size.width;
    CGFloat h = aRect.size.height;
    
    if (maintainAspect)
    {
        if (w > h)
        {
            h *= w/self.size.width;//scale maintaining aspect
        }
        else if(h > w)
        {
            w *= h/self.size.height;//scale maintaining aspect
        }
    }
    
    CGRect drawRect = CGRectMake(0, 0, w, h);
    
    UIGraphicsBeginImageContextWithOptions(drawRect.size, NO, self.scale);
    
    [self drawInRect:drawRect];
    
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return returnImage;
    
}

- (UIImage*)imageSizedToRect:(CGRect)aRect maintainAspect:(BOOL)maintainAspect
{
    
    CGFloat w = aRect.size.width;
    CGFloat h = aRect.size.height;
    
    if (maintainAspect)
    {
        if (w > h)
        {
            h *= w/self.size.width;//scale maintaining aspect
        }
        else if(h > w)
        {
            w *= h/self.size.height;//scale maintaining aspect
        }
    }
    
    CGFloat x = (aRect.size.width - w) * 0.5f;
    CGFloat y = (aRect.size.height - h) * 0.5f;
    
    CGRect drawRect = CGRectMake(x, y, w, h);
    
    UIGraphicsBeginImageContextWithOptions(aRect.size, NO, self.scale);    
    [self drawInRect:drawRect];
    
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return returnImage;
    
}

@end
