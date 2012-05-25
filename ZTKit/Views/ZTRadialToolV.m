//
//  ZTRadialTool.m
//  ZTKit
//
//  Created by Zachry Thayer on 2/16/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "ZTRadialToolV.h"
#import "../ZTCategories.h"
#import "../ZTHelpers.h"

#import <QuartzCore/QuartzCore.h>

static const unsigned int ZTRTFocusViewTag = 0x0f0c05;
static const unsigned int ZTRTToolTipsViewTag = 0x7001719;


@interface ZTRadialToolV ()

@property (nonatomic, strong)  UIView *toolTipsView;

@property (nonatomic) BOOL rotateSubviewsCache;

- (void)initialize;

- (void)layoutSubview:(UIView*)aView atIndex:(int)index; 

- (void)defaultLayout;
- (void)oneAtATimeLayout:(int)index;

@end

@implementation ZTRadialToolV

@synthesize toolTipsView;
@synthesize toolTipsRadius;
@synthesize animationType;
@synthesize focusView;
@synthesize displayAngle;
@synthesize rotateSubviews;
@synthesize rotateSubviewsCache;
@synthesize hiddenTooltips;

@synthesize isBeingPresented;

#pragma mark - Lifcycle

ZTKViewInitialize
{
    
    [self addSubview:self.toolTipsView];
    [self addSubview:self.focusView];
    self.animationType = ZTRTDefault;
    self.displayAngle = NSMakeRange(80, 110);
    self.toolTipsRadius = self.frame.size.width/3.f;
    self.hiddenTooltips = YES;
    self.rotateSubviews = NO;
        
    //self.userInteractionEnabled = NO;
    
}

- (void)dealloc
{
    
    toolTipsView = nil;
    focusView = nil;
    
}

#pragma mark - Display

- (void)presentFromView:(UIView*)aView
{
    
    if (self.superview != aView.superview) {
        [aView.superview insertSubview:self belowSubview:aView];
    }
    
    CGPoint newCenter = aView.center;        
    [self setCenter:newCenter];
    
    ZTRadialToolAnimation cachedAnimType = self.animationType;
    self.animationType = ZTRTNoAnimation;
    
    self.hiddenTooltips = YES;
    
    self.animationType = cachedAnimType;
  
    // Present all animated like
    self.hiddenTooltips = NO;
    
    self.alpha = 0.f;
    
    [UIView animateWithDuration:0.25f animations:^(){
        self.alpha = 1.f;
    }];
    
    isBeingPresented = YES;
    
    ZTRadialToolNavigationHackEnabled = YES;
    ZTRadialToolNavigationHackSize = self.frame.size;
    
}

- (void)dismiss
{
    self.hiddenTooltips = YES;
    
    [UIView animateWithDuration:0.25f animations:^(){
        self.alpha = 0.f;
    }];
    
    isBeingPresented = NO;
    
    ZTRadialToolNavigationHackEnabled = NO;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    switch (self.animationType) {
        case ZTRTNoAnimation:
            
            [self defaultLayout];
            
        case ZTRTDefault:
            
            [self defaultLayout];
            
            break;
            
        case ZTRTOneAtATime:
            
            [self oneAtATimeLayout:0];
            
            break;
    }
            
}

#pragma mark - Setters

- (void)addSubview:(UIView *)aView
{
    
    aView.center = CGPointMake(self.frame.size.width/2.f, self.frame.size.height/2.f);
    
    if (aView.tag == ZTRTFocusViewTag) {
        [super addSubview:aView];
        [self bringSubviewToFront:aView];
    }
    else if (aView.tag == ZTRTToolTipsViewTag)
    {
        [super addSubview:aView];
    }
    else {
        [self.toolTipsView addSubview:aView];
    }
}

- (void)setFrame:(CGRect)frame
{
    
    [super setFrame:frame];
    [self.toolTipsView setFrame:self.bounds];
    self.focusView.center = CGPointMake(self.frame.size.width/2.f, self.frame.size.height/2.f);

    
}

- (void)setFocusView:(UIView *)newFocusView
{
    if (focusView) {
        
        [focusView removeFromSuperview];
        focusView = nil;
        
    }
    
    focusView = newFocusView;
    
    focusView.tag = ZTRTFocusViewTag;
    [self addSubview:focusView];
    
}

- (void)setHiddenTooltips:(BOOL)hidden{
        
    hiddenTooltips = hidden;
    
    [self setNeedsLayout];
    
}


#pragma mark - Getters

- (NSArray*)subviews
{
    return self.toolTipsView.subviews;
}

- (UIView*)toolTipsView
{
    if (!toolTipsView) {
        
        toolTipsView = [[UIView alloc] initWithFrame:self.bounds];
        toolTipsView.tag = ZTRTToolTipsViewTag;
        
    }
    
    return toolTipsView;
}

- (UIView*)focusView
{
    if (!focusView) {
        
        /*
        CAShapeLayer *baseCircle;
        
        CGSize frameSize = self.frame.size;
        
        CGRect baseCircleRect = CGRectMake(0, 0, frameSize.width/3, frameSize.height/3);
        UIBezierPath *baseCirclePath = [UIBezierPath bezierPathWithOvalInRect:baseCircleRect];
        
        baseCircle = [[CAShapeLayer alloc] init];
        baseCircle.path = [baseCirclePath CGPath];
        
        baseCircle.frame = CGRectMake(frameSize.width/3, frameSize.width/3, frameSize.width/3, frameSize.height/3);
        
        baseCircle.fillColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];*/
        
        focusView = [[UIView alloc] initWithFrame:self.bounds];
        focusView.tag = ZTRTFocusViewTag;
        
        //[focusView.layer addSublayer:baseCircle];
            
    }
    
    return focusView;
}


#pragma mark - Private Helpers

- (void)defaultLayout
{
    
    void (^animation)(void) = ^(void)
    {
        int i = 0;
        
        for (UIView* aView in self.toolTipsView.subviews) {
            [self layoutSubview:aView atIndex:i++];
            
        }
    };
    
    if (!ZTRTNoAnimation)
    {
        [UIView animateWithDuration:0.25f animations:animation];
    }    
    else
    {
        animation();
    }
        
}

- (void)oneAtATimeLayout:(int)index
{

    if (index >= [toolTipsView.subviews count]) {
        return;
    }
    
    void (^animation)(void) = ^(void)
    {
        UIView *aView = [toolTipsView.subviews objectAtIndex:index];
        if (aView.tag == ZTRTFocusViewTag) {
            aView.center = CGPointMake(self.frame.size.width/2.f, self.frame.size.height/2.f);
        }
        else
        {
            [self layoutSubview:aView atIndex:index];
        }

    };
    
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        [self oneAtATimeLayout:index + 1];
    };
    
    if (!ZTRTNoAnimation)
    {
        [UIView animateWithDuration:0.1f animations:animation completion:completion];
    }
    else
    {
        animation();
        completion(YES);
    }
}

- (void)layoutSubview:(UIView*)aView atIndex:(int)index 
{
    // adjust the index to offset the focusView
    CGFloat step = self.displayAngle.length / [self.subviews count];
    CGFloat startAngle = self.displayAngle.location;
            
    CGFloat radians = (startAngle + ((index + 0.5f) * step)) * (M_PI / 180.f);
    
    if (self.rotateSubviews && !self.hiddenTooltips) {
        aView.transform = CGAffineTransformMakeRotation(radians);
    }
    
    CGFloat radius = (self.hiddenTooltips)?0:self.toolTipsRadius;
    
    CGFloat x = (self.frame.size.width/2) + (radius) * cosf(radians);
    CGFloat y = (self.frame.size.width/2) + (radius) * sinf(radians);        
    
    aView.center = CGPointMake(x, y);      
    
}

@end
