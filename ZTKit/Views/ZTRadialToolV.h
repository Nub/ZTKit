//
//  ZTRadialTool.h
//  ZTKit
//
//  Created by Zachry Thayer on 2/16/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTRadialToolV : UIView


typedef enum
{   
    ZTRTNoAnimation,
    ZTRTDefault,
    ZTRTOneAtATime
}ZTRadialToolAnimation;

@property (nonatomic) ZTRadialToolAnimation animationType;

//! View to be shown as the center of the tool
/*!
    \note By default it will create a view with a 80% white circle
 */
@property (nonatomic, strong) UIView *focusView;

//! The location and angle at which to lay out the tooltips
@property (nonatomic) NSRange displayAngle;

//! Rotate tooltips to be perpendicular to their normal
@property (nonatomic) BOOL rotateSubviews;

//! Distance from center of view that tool tips are positioned
@property (nonatomic) CGFloat toolTipsRadius;

//! Hide / Show tooltips (animates to focusView)
@property (nonatomic) BOOL hiddenTooltips;


@property (nonatomic, readonly) BOOL isBeingPresented;
- (void)presentFromView:(UIView*)aView;
- (void)dismiss;

@end
