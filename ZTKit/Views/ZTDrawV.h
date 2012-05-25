//
//  ZTDrawView.h
//  ZTKit
//
//  Created by Zachry Thayer on 2/21/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTDrawV : UIView

@property (nonatomic) CGFloat brushSize;
@property (nonatomic) UIColor* brushColor;

- (void) clear;

- (NSString*)SVGRepresentation;

@end

