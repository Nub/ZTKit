//
//  ZTPerPixelLayer.h
//  ZTKit
//
//  Created by Zachry Thayer on 3/10/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef void (^ZTPerPixelLayerIteratorBlock)(CALayer* pixelLayer, NSInteger index);


@interface ZTPerPixelLayer : CALayer

- (void)iterateEachPixelWithBlock:(ZTPerPixelLayerIteratorBlock)iteratorBlock;

- (void)iterateEachPixelWithBlock:(ZTPerPixelLayerIteratorBlock)iteratorBlock withDelay:(CGFloat)delay;

- (void)reverseIterateEachPixelWithBlock:(ZTPerPixelLayerIteratorBlock)iteratorBlock;

- (void)reverseIterateEachPixelWithBlock:(ZTPerPixelLayerIteratorBlock)iteratorBlock withDelay:(CGFloat)delay;

@end
