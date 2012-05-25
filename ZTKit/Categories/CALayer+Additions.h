//
//  CALayer+Additions.h
//  ZTKit
//
//  Created by Zachry Thayer on 4/24/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Additions)


#pragma mark Recursion

- (void)recursiveBorderWidth:(CGFloat)width;
- (void)recursiveBorderColor:(CGColorRef)borderColor;
- (void)recursiveContents:(id)contents;
- (void)recursiveBackgroundColor:(CGColorRef)backgroundColor;

@end
