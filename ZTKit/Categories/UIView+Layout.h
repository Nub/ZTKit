//
//  UIView+Additions.h
//  ZTKit
//
//  Created by Zachry Thayer on 10/9/11.
//  Copyright (c) 2011 Yoshimi Robotics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

- (CGRect)subviewContainerRect;

- (void)fillSuperview;

- (void)sizeToView:(UIView*)aView;

- (void)replaceWithView:(UIView*)newView;

- (NSString*)recursiveDescription;

@end
