//
//  ZTLinearToolV.h
//  ZTKit
//
//  Created by Zachry Thayer on 3/20/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ZTNorth = 90,
    ZTNorthEast = 45,
    ZTEast = 0,
    ZTSouthEast = -45,
    ZTSouth = -90,
    ZTSoutWest = -135,
    ZTWest = 180,
    ZTNorthWest = 135
}ZTCardinalDirection;

@class ZTLinearToolV;
@protocol ZTLinearToolVDelegate <NSObject>

- (void)willPresentlinearTool:(ZTLinearToolV*)linearTool;
- (void)willDismisslinearTool:(ZTLinearToolV*)linearTool;

@end

@interface ZTLinearToolV : UIView

@property (nonatomic, strong)   UIButton*               toggleButton;
@property (nonatomic)           ZTCardinalDirection     direction;
@property (nonatomic, readonly) BOOL                    displayed;

@property (nonatomic, strong)   id<ZTLinearToolVDelegate> delegate;

@end
