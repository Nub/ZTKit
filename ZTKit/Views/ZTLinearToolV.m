//
//  ZTLinearToolV.m
//  ZTKit
//
//  Created by Zachry Thayer on 3/20/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "ZTLinearToolV.h"
#import "ZTHelpers.h"

#define Extension ()

#define ZTLTVToggleButtonTag 0x00706613

@interface ZTLinearToolV Extension

@property (nonatomic, readwrite) BOOL displayed;

@property (nonatomic) CGFloat cumulativeRadius;

- (void)doToggleButton:(UIButton*)button;

//ZTKViewInitialize
- (void)initialize;

@end

@implementation ZTLinearToolV

@synthesize cumulativeRadius;

@synthesize toggleButton;
@synthesize direction;
@synthesize displayed;

@synthesize delegate;


ZTKViewInitialize
{
    self.direction = ZTWest;
    self.displayed = YES;
}

#pragma mark - Setters

- (void)setToggleButton:(UIButton *)newToggleButton
{
    if (newToggleButton) 
    {
        toggleButton = newToggleButton;
        toggleButton.tag = ZTLTVToggleButtonTag;
        
        [toggleButton addTarget:self action:@selector(doToggleButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:toggleButton];
    }
}

#pragma maek - Mutators

- (void)addSubview:(UIView *)view
{
    
    [super addSubview:view];
    
    if (view.tag == ZTLTVToggleButtonTag)
    {
        [self bringSubviewToFront:view];
    }
    else
    {
        if (self.toggleButton)
        {            
            [self exchangeSubviewAtIndex:1 withSubviewAtIndex:[self.subviews count]-1];
        }
    }
        
}

#pragma mark - Actions

- (void)doToggleButton:(UIButton*)button
{
    
    if (self.delegate)
    {
        if (self.displayed)
        {
            [self.delegate willDismisslinearTool:self];
        }
        else
        {
            [self.delegate willPresentlinearTool:self];
        }
    }
    
    self.displayed = !self.displayed;
    [self setNeedsLayout];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    CGFloat radians = (CGFloat)self.direction * (M_PI / 180.f);
    CGFloat xWeight = cosf(radians);
    CGFloat yWeight = sinf(radians);
    
    CGRect toggleFrame = self.toggleButton.frame;
    self.cumulativeRadius = (toggleFrame.size.width + toggleFrame.size.height) * 0.5f;
    
    for (UIView* view in self.subviews) {
        
        CGFloat xRadius = xWeight * self.cumulativeRadius;
        CGFloat yRadius = yWeight * self.cumulativeRadius;
        
        CGFloat xOffset = toggleButton.center.x + (xWeight * (toggleFrame.size.width * 0.5f));
        CGFloat yOffset = toggleButton.center.y + (yWeight * (toggleFrame.size.height * 0.5f));
        
        if (view.tag == ZTLTVToggleButtonTag)
        {
            [UIView animateWithDuration:0.25f animations:^(void){
                CGRect newFrame = view.frame;
                //EWW clean it up!
                newFrame.origin.x = floorf((self.frame.size.width - newFrame.size.width) * ( 1.f - ((cosf(radians) + 1.f) * 0.5f)));
                newFrame.origin.y = floorf((self.frame.size.height - newFrame.size.height) * (1.f - ((sinf(radians) + 1.f) * 0.5f)));

                view.frame = newFrame;                
            }];
        }
        else
        {
            [UIView animateWithDuration:0.25f animations:^(void){
                
                if (self.displayed)
                {
                    
                    CGPoint newCenter = view.center;
                    
                    newCenter.x = ceilf(xRadius + xOffset);
                    newCenter.y = ceilf(yRadius + yOffset);
                    
                    view.center = newCenter;
                    
                    self.cumulativeRadius += (view.frame.size.width + view.frame.size.height) * 0.5f;
                                        
                    view.alpha = 1.f;
                    
                } 
                else
                {
                    //CGRect newFrame = view.frame;
                    //newFrame.origin = self.toggleButton.frame.origin;
                    
                    view.center = self.toggleButton.center;
                    view.alpha = 0.f;
                }
                
            }];
            
        }
        
    }
}


@end
