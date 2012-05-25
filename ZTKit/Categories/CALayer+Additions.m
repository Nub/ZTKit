//
//  CALayer+Additions.m
//  ZTKit
//
//  Created by Zachry Thayer on 4/24/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "CALayer+Additions.h"

@implementation CALayer (Additions)


#pragma mark Recursion

#define CALAyerRecurseBoiler(name) for(CALayer* layer in self.sublayers){layer.name = argument;[layer recursive(name):argument]}

- (void)recursiveBorderWidth:(CGFloat)width
{
    self.borderWidth = width;
    
    for (CALayer* layer in self.sublayers)
    {
        layer.borderWidth = width;
        [layer recursiveBorderWidth:width];
    }
}

- (void)recursiveBorderColor:(CGColorRef)borderColor
{
    self.borderColor = borderColor;
    
    for (CALayer* layer in self.sublayers)
    {
        layer.borderColor = borderColor;
        [layer recursiveBorderColor:borderColor];
    }
}

- (void)recursiveContents:(id)contents
{
    self.contents = contents;
    
    for (CALayer* layer in self.sublayers)
    {
        layer.contents = contents;
        [layer recursiveContents:contents];
    }
}

- (void)recursiveBackgroundColor:(CGColorRef)backgroundColor
{
    self.backgroundColor = backgroundColor;
    
    for (CALayer* layer in self.sublayers)
    {
        layer.backgroundColor = backgroundColor;
        [layer recursiveBackgroundColor:backgroundColor];
    } 
}

@end
