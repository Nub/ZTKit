//
//  ZTDrawView.h
//  ZTKit
//
//  Created by Zachry Thayer on 2/21/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTDrawView : UIView

@property (nonatomic) CGFloat brushSize;
@property (nonatomic) UIColor* brushColor;

- (NSString*)SVGRepresentation;

@end

