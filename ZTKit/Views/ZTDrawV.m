//
//  ZTDrawView.m
//  ZTKit
//
//  Created by Zachry Thayer on 2/21/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "ZTDrawView.h"

#import "../ZTCategories.h"

@interface ZTDrawView ()

@property (nonatomic) CGPoint previousPoint1;
@property (nonatomic) CGPoint previousPoint2;
@property (nonatomic) CGPoint previousPoint3;

@property (nonatomic) CGPoint currentPoint;

@property (nonatomic) CGPoint mid1;
@property (nonatomic) CGPoint mid2;

@property (nonatomic, strong) UIImage* bufferImage;
@property (nonatomic, strong) NSMutableArray* paths;
@property (nonatomic, strong) NSMutableArray* pathColors;


@property (nonatomic) BOOL needsToRedraw;

- (CGPoint)pointBetween:(CGPoint)point1 andPoint:(CGPoint)point2;

- (void)initialize;

@end

#pragma mark - Implemetation

@implementation ZTDrawView

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
@synthesize paths;
@synthesize pathColors;

@synthesize needsToRedraw;

#pragma mark - Lifecycle

- (void)initialize
{
    brushSize = 5.0f;
    brushColor = [UIColor redColor];
    
    self.needsToRedraw = NO;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
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
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)dealloc
{
    
    bufferImage = nil;
    
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
        
        self.needsToRedraw = YES;
        [self setNeedsDisplay];
    }
    
}

#pragma mark - Display

- (void)drawRect:(CGRect)rect
{
    
    // Avoid overdraw
    if (self.needsToRedraw) 
    {
        //Render to buffer
        UIGraphicsBeginImageContext(self.frame.size);
        [self.bufferImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.bufferImage = nil;
        
        UIBezierPath* newPath = [UIBezierPath bezierPath];
        
        [newPath moveToPoint:self.mid1];
        [newPath addQuadCurveToPoint:self.mid2 controlPoint:self.previousPoint1];
        [newPath setLineWidth:self.brushSize];
        [newPath setLineCapStyle:kCGLineCapRound];
        [self.brushColor setStroke];
        [newPath stroke];
        
        //Save
        [self.paths addObject:newPath];
        [self.pathColors addObject:self.brushColor];
        
        
        /*
         
         CoreGraphics version
         
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextMoveToPoint(context, self.mid1.x, self.mid1.y);
        // Use QuadCurve is the key
        CGContextAddQuadCurveToPoint(context, self.previousPoint1.x, self.previousPoint1.y, self.mid2.x, self.mid2.y); 
        
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, brushSize);
        CGContextSetStrokeColorWithColor(context, [brushColor CGColor]);
       // CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
        CGContextStrokePath(context);
         */
        
        self.bufferImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.needsToRedraw = NO;

    }
    
    [self.bufferImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    

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
