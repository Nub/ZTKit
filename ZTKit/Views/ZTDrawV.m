//
//  ZTDrawView.m
//  ZTKit
//
//  Created by Zachry Thayer on 2/21/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "ZTDrawV.h"

#import "../ZTCategories.h"
#import "../ZTHelpers.h"

@interface ZTDrawV ()

@property (nonatomic) CGPoint previousPoint1;
@property (nonatomic) CGPoint previousPoint2;
@property (nonatomic) CGPoint previousPoint3;

@property (nonatomic) CGPoint currentPoint;

@property (nonatomic) CGPoint mid1;
@property (nonatomic) CGPoint mid2;

@property (nonatomic, strong) UIImage* bufferImage;
@property (nonatomic)         CGSize   bufferSize;
@property (nonatomic, strong) NSMutableArray* paths;
@property (nonatomic, strong) NSMutableArray* pathColors;

@property (nonatomic) BOOL needsToRedraw;

- (CGPoint)pointBetween:(CGPoint)point1 andPoint:(CGPoint)point2;
- (CGRect) CGRectContainingPoints:(int) pointCount, ...;

- (void)initialize;

@end

#pragma mark - Implemetation

@implementation ZTDrawV 

#pragma mark Public variables
@synthesize brushSize;
@synthesize brushColor;

#pragma mark Private variables

@synthesize previousPoint1;
@synthesize previousPoint2;
@synthesize previousPoint3;
@synthesize currentPoint;

@synthesize mid1;
@synthesize mid2;

@synthesize bufferImage;
@synthesize bufferSize;
@synthesize paths;
@synthesize pathColors;

@synthesize needsToRedraw;

#pragma mark - Lifecycle

ZTKViewInitialize
{
    brushSize = 5.0f;
    brushColor = [UIColor redColor];
    
    self.needsToRedraw = NO;

    self.bufferSize = self.bounds.size;
    
    self.clearsContextBeforeDrawing = NO;
    
}

- (void)dealloc
{
    self.pathColors = nil;
    self.paths = nil;
    self.bufferImage = nil;
    self.brushColor = nil;
}

#pragma mark - Touch

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    self.previousPoint1 = [touch previousLocationInView:self];
    self.previousPoint2 = [touch previousLocationInView:self];
    self.currentPoint = [touch locationInView:self];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint previous = [touch previousLocationInView:self];
    CGPoint current = [touch locationInView:self];
    
    #define SQR(x) ((x)*(x))
    //Check for a minimal distance to avoid silly data
    if ((SQR(current.x - self.previousPoint2.x) + SQR(current.y - self.previousPoint2.y)) > SQR(10))
    {        
        
        self.previousPoint2 = self.previousPoint1;
        self.previousPoint1 = previous;
        self.currentPoint = current;
        
        // calculate mid point
        self.mid1 = [self pointBetween:self.previousPoint1 andPoint:self.previousPoint2];
        self.mid2 = [self pointBetween:self.currentPoint andPoint:self.previousPoint1];
        
        UIBezierPath* newPath = [UIBezierPath bezierPath];
        
        [newPath moveToPoint:self.mid1];
        [newPath addQuadCurveToPoint:self.mid2 controlPoint:self.previousPoint1];
        [newPath setLineWidth:self.brushSize];
        [newPath setLineCapStyle:kCGLineCapRound];
        
        //Save
        [self.paths addObject:newPath];
        [self.pathColors addObject:self.brushColor];
        
        self.needsToRedraw = YES;
        [self setNeedsDisplayInRect:[self CGRectContainingPoints:3, self.mid1, self.mid2, self.previousPoint1]];
    }
    
}

#define ASSUME_VALUE(a, b, lop) if((b) lop (a)){(a) = (b);}

- (CGRect) CGRectContainingPoints:(int) pointCount, ...
{
    va_list vl;
    va_start(vl, pointCount);
    
    //Create inverted rect
    CGRect theRect = CGRectMake(FLT_MAX, FLT_MAX, FLT_MIN, FLT_MIN);
    CGFloat greatestX = FLT_MIN, greatestY = FLT_MIN;
    
    for (int i = 0; i < pointCount; i++)
    {
        CGPoint point = va_arg(vl, CGPoint);
        
        ASSUME_VALUE(theRect.origin.x, point.x, <);
        theRect.origin.x -= self.brushSize;
        ASSUME_VALUE(theRect.origin.y, point.y, <);
        theRect.origin.y -= self.brushSize;
        
        ASSUME_VALUE(greatestX, point.x, >);
        theRect.size.width = greatestX - theRect.origin.x + self.brushSize;
        ASSUME_VALUE(greatestY, point.y, >);
        theRect.size.height = greatestY - theRect.origin.y + self.brushSize;
        
    }
    
    va_end(vl);
    
    return theRect;
}

#pragma mark - Display

- (void)drawRect:(CGRect)rect
{
    
#define RENDER_OFFSCREEN 1
    
#ifdef RENDER_OFFSCREEN

    UIGraphicsBeginImageContextWithOptions(self.bufferSize, NO, 0.0f);
   
    if (self.bufferImage)
    {
        [self.bufferImage drawInRect:self.bounds];
    }

#endif
    
    UIBezierPath* lastPath = [self.paths lastObject];
    
    if (lastPath)
    {
        [self.brushColor setStroke];
        [lastPath stroke];
    }
    
#ifdef RENDER_OFFSCREEN

    self.bufferImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (self.bufferImage)
    {
        [self.bufferImage drawInRect:self.bounds];
    }
    
#endif
    
}

- (void) clear
{
    
    self.bufferImage = nil;
    self.paths = nil;
    self.pathColors = nil;
    
}

#pragma mark - Data

- (NSString*)SVGRepresentation
{
  
    NSMutableString *SVGString = [NSMutableString stringWithString:@"<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\">"];
    
    NSInteger index = 0;
    for (UIBezierPath* aPath in self.paths) {
        
        UIColor* aColor = [self.pathColors objectAtIndex:index];
        CGFloat r,g,b,a;
        [aColor getRed:&r green:&g blue:&b alpha:&a];
        NSString* colorString = [NSString stringWithFormat:@"rgb(%i,%i,%i)",(int)r*255,(int)g*255,(int)b*255];
        
        NSString* aPathSVGString = [aPath toSVGString];
        
        [SVGString appendString:aPathSVGString];
        
        aPathSVGString = nil;
        
        [SVGString replaceOccurrencesOfString:@"red" withString:colorString options:NSLiteralSearch range:NSMakeRange(0, [SVGString length])];
        
        [SVGString replaceOccurrencesOfString:@"temporaryID" withString:[NSString stringWithFormat:@"%i", index] options:NSLiteralSearch range:NSMakeRange(0, [SVGString length])];
         
        index ++;
    }
    
    [SVGString appendString:@"</svg>"];
    
    return SVGString;
}

#pragma mark - Getters

- (NSMutableArray*)paths
{
    if (!paths) {
        paths = [NSMutableArray array];
    }
    
    return paths;
}

- (NSMutableArray*)pathColors
{
    if (!pathColors) {
        pathColors = [NSMutableArray array];
    }
    
    return pathColors;
}

#pragma mark - Private helpers

- (CGPoint)pointBetween:(CGPoint)point1 andPoint:(CGPoint)point2;
{
    
    return CGPointMake((point1.x + point2.x) * 0.5, (point1.y + point2.y) * 0.5);
    
}

@end
