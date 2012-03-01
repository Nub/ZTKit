//
//  UINavigationBar+ZTRadialTool.m
//  ZTKit
//
//  Created by Zachry Thayer on 2/28/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "UINavigationBar+ZTRadialTool.h"

BOOL ZTRadialToolNavigationHackEnabled = NO;
CGSize ZTRadialToolNavigationHackSize;

@implementation UINavigationBar (ZTRadialTool)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (point.x > self.frame.size.width - ZTRadialToolNavigationHackSize.width && point.y < self.frame.size.height + ZTRadialToolNavigationHackSize.height && ZTRadialToolNavigationHackEnabled)
    {
        return YES;
    }
    else
    {
        return [super pointInside:point withEvent:event];
    }
}


@end
