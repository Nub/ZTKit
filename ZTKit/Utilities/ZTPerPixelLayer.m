//
//  ZTPerPixelLayer.m
//  ZTKit
//
//  Created by Zachry Thayer on 3/10/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "ZTPerPixelLayer.h"

#import "../Utilities/ZTColorTools.h"
#import "NSArray+Access.h"

@interface ZTPerPixelLayer ()

@property (nonatomic, strong) ZTPerPixelLayerIteratorBlock currentIteratorBlock;
@property (nonatomic) NSInteger currentIteratorIndex;
@property (nonatomic, strong) NSTimer* delayIterateTimer;


@property (nonatomic) BOOL isReverseEnumerated;
- (void)fireTimer:(NSTimer*)timer;


@end

@implementation ZTPerPixelLayer

@synthesize currentIteratorBlock;
@synthesize currentIteratorIndex;
@synthesize delayIterateTimer;

@synthesize isReverseEnumerated;

- (void)iterateEachPixelWithBlock:(ZTPerPixelLayerIteratorBlock)iteratorBlock
{
    
    self.isReverseEnumerated = NO;
    NSInteger index = 0;
    for (CALayer* layer in self.sublayers) {
        iteratorBlock(layer, index);
    }
}

- (void)iterateEachPixelWithBlock:(ZTPerPixelLayerIteratorBlock)iteratorBlock withDelay:(CGFloat)delay
{
    
    self.isReverseEnumerated = NO;
    if (self.delayIterateTimer) {
        [self.delayIterateTimer invalidate];
        [self setDelayIterateTimer:nil];
    }
    
    self.currentIteratorBlock = iteratorBlock;
    self.currentIteratorIndex = (self.isReverseEnumerated)?[self.sublayers count]-1:0;
    self.delayIterateTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(fireTimer:) userInfo:nil repeats:YES];
        
}

- (void)reverseIterateEachPixelWithBlock:(ZTPerPixelLayerIteratorBlock)iteratorBlock
{
    self.isReverseEnumerated = YES;
    NSInteger index = [self.sublayers count]-1;
    for (CALayer* layer in [self.sublayers reverseObjectEnumerator]) {
        iteratorBlock(layer,index);
    }
}

- (void)reverseIterateEachPixelWithBlock:(ZTPerPixelLayerIteratorBlock)iteratorBlock withDelay:(CGFloat)delay
{
    self.isReverseEnumerated = YES;
    if (self.delayIterateTimer) {
        [self.delayIterateTimer invalidate];
        [self setDelayIterateTimer:nil];
    }
    
    self.currentIteratorBlock = iteratorBlock;
    self.currentIteratorIndex = (self.isReverseEnumerated)?[self.sublayers count]-1:0;
    self.delayIterateTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(fireTimer:) userInfo:nil repeats:YES];
    
}

- (void)fireTimer:(NSTimer*)timer
{
    
    if ([self.sublayers isValidIndex:self.currentIteratorIndex]) {
        
        self.currentIteratorBlock([self.sublayers safeObjectAtIndex:self.currentIteratorIndex], self.currentIteratorIndex);
        
        self.currentIteratorIndex += (self.isReverseEnumerated)?-1:1;
    }
    else
    {
        [self.delayIterateTimer invalidate];
        [self setDelayIterateTimer:nil];
    }
    
}

#pragma mark - Setter

- (void)setContents:(id)contents
{
    
    CGImageRef imageRef = (__bridge CGImageRef)contents;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned int *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedFirst |
                                                 kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    //ITERATE EACH PIXEL!
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            
            unsigned int currentColor = colorFromDataAtPoint(rawData, width, CGPointMake(x, y));
            float a = ((currentColor >> 24) & 0xff) / 255.f;
            float r = ((currentColor >> 16) & 0xff) / 255.f;
            float g = ((currentColor >> 8) & 0xff) / 255.f;
            float b = ((currentColor) & 0xff) / 255.f;

            
            if (a > 0.f)
            {                
                
                UIColor* backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
                
                int scale = 1;
                
                CALayer* newPixelLayer = [[CALayer alloc] init];
                newPixelLayer.backgroundColor = [backgroundColor CGColor];
                newPixelLayer.frame = CGRectMake(x*scale, y*scale, scale, scale);
                //newPixelLayer.borderColor = [[UIColor purpleColor] CGColor];
                //newPixelLayer.borderWidth = 0.5f;
                
                [self addSublayer:newPixelLayer];
                
            }
            
            
            
            
        }  
    }
        
}



@end
