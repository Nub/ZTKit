//
//  ZTRadialToolToolBar.m
//  ZTRadialToolTest
//
//  Created by Zachry Thayer on 2/28/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "ZTRadialToolToolBar.h"

@interface ZTRadialToolToolBar ()

- (void)initialize;

@end

@implementation ZTRadialToolToolBar

@synthesize radialTool;

#pragma mark - Lifecycle

- (void)initialize
{
    //self.topItem.rightBarButtonItem = [UIB];
    
        
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (void)dealloc
{
    
    self.radialTool = nil;
    
}

#pragma mark - Events

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self.radialTool pointInside:point withEvent:event])
    {
        return YES;
    }
    else
    {
        return [super pointInside:point withEvent:event];
    }
}

#pragma mark - Getters

- (ZTRadialTool*)radialTool
{
    if (!radialTool) {
        radialTool = [[ZTRadialTool alloc] init];
    }
    
    return radialTool;
}

@end
