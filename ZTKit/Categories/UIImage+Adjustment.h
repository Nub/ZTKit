//
//  UIImage+Adjustment.h
//  ZTKit
//
//  Created by Zachry Thayer on 12/4/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Adjustment)

- (UIImage*)imageFittingToRect:(CGRect)aRect maintainAspect:(BOOL)maintainAspect;
- (UIImage*)imageSizedToRect:(CGRect)aRect maintainAspect:(BOOL)maintainAspect;


@end
