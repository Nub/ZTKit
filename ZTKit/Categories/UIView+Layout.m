//
//  UIView+Additions.m
//  ZTKit
//
//  Created by Zachry Thayer on 10/9/11.
//  Copyright (c) 2011 Yoshimi Robotics. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView (SubviewTools)

- (CGRect)subviewContainerRect{

    if ([self.subviews count] == 0)
        return CGRectZero;
    
    CGRect containerRect = CGRectMake(CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MIN, CGFLOAT_MIN);//Inverted largest rect
    
    for (UIView *view in self.subviews) {
        
        CGRect viewFrame = view.frame;
        
        if (viewFrame.origin.x < containerRect.origin.x){
            containerRect.origin.x = viewFrame.origin.x;
        }
        if (viewFrame.origin.y < containerRect.origin.y){
            containerRect.origin.y = viewFrame.origin.y;
        }
        
        if (viewFrame.size.width + viewFrame.origin.x > containerRect.origin.x + containerRect.size.width){
            containerRect.size.width = viewFrame.size.width + viewFrame.origin.x - containerRect.origin.x;
        }
        
        if (viewFrame.size.height + viewFrame.origin.y > containerRect.origin.y + containerRect.size.height){
            containerRect.size.height = viewFrame.size.height + viewFrame.origin.y - containerRect.origin.y;
        }
        
        
    }
    
    return containerRect;
    
}

- (void)fillSuperview
{
    if (self.superview) {
        [self setFrame:self.superview.bounds];
    }
}

- (void)sizeToView:(UIView*)aView
{
    if (aView)
    {
        [self setFrame:aView.frame];
    }
}

- (void)replaceWithView:(UIView*)newView
{
    UIView *superView = self.superview;
    
    [superView insertSubview:newView aboveSubview:self];
    [self removeFromSuperview];
}


@end
