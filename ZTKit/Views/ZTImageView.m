//
//  ZTImageView.m
//  ZTKit
//
//  Created by Zachry Thayer on 5/22/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "ZTImageView.h"
#import <QuartzCore/QuartzCore.h>

static NSCache* ZTImageViewImageCache;

@interface ZTImageView ()
{
    BOOL isLoading;
}

@property (nonatomic, strong) UIActivityIndicatorView* acticityIndicator;
@property (nonatomic, strong) UIImageView* imageView;

+ (void)discCacheImageData:(NSData*)imageData forKey:(NSString*)key;
+ (NSData*)loadDiscCachedImageDataForKey:(NSString*)key;
+ (UIImage*)loadCachedImageForKey:(NSString*)key;

@end

@implementation ZTImageView

@synthesize image;
@synthesize cacheToDisk;

@synthesize acticityIndicator;
@synthesize imageView;

#pragma mark - Lifecycle

+ (void)load
{
    ZTImageViewImageCache = [[NSCache alloc] init];
    //10mb cache limit
    //[ZTImageViewImageCache setTotalCostLimit:1024*1024*10];
}

- (ZTImageView*)initWithImageSource:(NSString*)source
{
    NSURL* sourceURL = [NSURL URLWithString:source];
    
    if (sourceURL) 
    {
        return [self initWithImageURL:sourceURL];
    }
    
    return nil;
}

- (ZTImageView*)initWithImageURL:(NSURL*)url
{
    self = [self init];
    if (self) 
    {
        [self setImageURL:url];
    }
    return self;
}

- (void)dealloc
{
    self.acticityIndicator = nil;
    self.imageView = nil;
    self.image = nil;
    
    //[super dealloc];
}


#pragma mark - Accessors

- (UIActivityIndicatorView*)acticityIndicator
{
    if (!acticityIndicator)
    {
        acticityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        acticityIndicator.frame = CGRectMake(0, 0, 50, 50);
        acticityIndicator.center = self.center;
        acticityIndicator.layer.shadowColor = [[UIColor blackColor] CGColor];
        acticityIndicator.layer.shadowRadius = 2.f;
        acticityIndicator.layer.shadowOffset = CGSizeMake(0, 0);
        acticityIndicator.layer.shadowOpacity = 0.5f;
//        acticityIndicator.backgroundColor = [UIColor grayColor];
        acticityIndicator.layer.cornerRadius = 10.f;
        acticityIndicator.layer.borderWidth = 5.f;
        acticityIndicator.layer.borderColor = [[UIColor colorWithWhite:0 alpha:0.5] CGColor];
//        acticityIndicator.autoresizingMask = 
//            UIViewAutoresizingFlexibleBottomMargin | 
//            UIViewAutoresizingFlexibleLeftMargin | 
//            UIViewAutoresizingFlexibleRightMargin | 
//            UIViewAutoresizingFlexibleTopMargin;
    }
    
    return acticityIndicator;
}

- (UIImageView*)imageView
{
    if (!imageView)
    {
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return imageView;
}

#pragma mark - Setters

- (void)setImageSource:(NSString*)source
{
    NSURL* sourceURL = [NSURL URLWithString:source];
    
    NSAssert(sourceURL, @"ZTImageView setImageSource, source is not a valid URL", __PRETTY_FUNCTION__);

    [self setImageURL:sourceURL];
}

- (void)setImageURL:(NSURL *)url
{
    
    NSString* key = [NSString stringWithFormat:@"ZTIVC_%x", [url hash]];
    
    if (isLoading)
    {
        NSLog(@"Ignoring Request, image is still loading.");
        return;
    }
    
    UIImage* cachedImage = [ZTImageView loadCachedImageForKey:key];
    if (cachedImage)//Use cached data if availible
    {
        self.image = cachedImage;
        return;
    }
    
    //Bring in acitvity indicator
    if (![self.acticityIndicator superview])
    {
        [self addSubview:self.acticityIndicator];
        [self.acticityIndicator startAnimating];
        
        [UIView animateWithDuration:0.5 animations:^(){
            if ([self.imageView superview])
            {
                self.imageView.alpha = 0;
            }
        } completion:^(BOOL finished){
            if ([self.imageView superview])
            {
                [self.imageView removeFromSuperview];
            }
        }];
    }
    
    //Async load data
    isLoading = YES;
    
    dispatch_queue_t networkQueue = dispatch_queue_create("com.zachrythayer.ztkit.imageview.async", NULL);
    
    dispatch_async(networkQueue, ^(void){
        NSData* imageData = [NSData dataWithContentsOfURL:url];
        UIImage* theImage = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            self.image = theImage;
        });
        
        //Cache to memory and disc
        [ZTImageViewImageCache setObject:theImage forKey:key];
        
        if (self.cacheToDisk)
        {
            [ZTImageView discCacheImageData:imageData forKey:key];
        }
        
    });
    
    dispatch_release(networkQueue);
}


- (void)setImage:(UIImage *)newImage
{
    NSAssert(newImage,@"newImage nil");
    
    image = newImage;
    self.imageView.image = newImage;
    isLoading = NO;
    
    if (![self.imageView superview])
    {
        [self addSubview:self.imageView];
        self.imageView.alpha = 1.f;
    }
    
    // Fade out activity indicator if presented
    if ([self.acticityIndicator superview])
    {
        self.imageView.alpha = 0.f;
        
        [UIView animateWithDuration:0.5 animations:^(){
            self.imageView.alpha = 1.f;
            
        } completion:^(BOOL finished)
         {
             [self.acticityIndicator removeFromSuperview];
         }];
    }
}

- (void)setContentMode:(UIViewContentMode)contentMode
{
    [super setContentMode:contentMode];
    [self.imageView setContentMode:contentMode];
}

#pragma mark - Class Helpers

+ (void)discCacheImageData:(NSData*)imageData forKey:(NSString*)key
{
    NSFileManager* filemanager = [NSFileManager defaultManager];
    NSURL* appCacheFolder = [[filemanager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL* cacheFolder = [appCacheFolder URLByAppendingPathComponent:@"ZTImageViewDiscImageCache"];
    
    [filemanager createDirectoryAtURL:cacheFolder withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSURL* cacheFile = [cacheFolder URLByAppendingPathComponent:key];
    
    NSLog(@"%@", cacheFile);
    
    [imageData writeToURL:cacheFile atomically:YES];
}

+ (NSData*)loadDiscCachedImageDataForKey:(NSString*)key
{
    NSFileManager* filemanager = [NSFileManager defaultManager];
    NSURL* appCacheFolder = [[filemanager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL* cacheFolder = [appCacheFolder URLByAppendingPathComponent:@"ZTImageViewDiscImageCache"];
    
    NSURL* cacheFile = [cacheFolder URLByAppendingPathComponent:key];
    
    if ([filemanager fileExistsAtPath:[cacheFile path]])
    {
        return [NSData dataWithContentsOfURL:cacheFile]; 
    }
    
    return nil;
}

+ (UIImage*)loadCachedImageForKey:(NSString*)key
{
    //Try memory cache
    UIImage* image = [ZTImageViewImageCache objectForKey:key];
    
    // Try disc cache
    if (!image)
    {
        NSData* imageData = [ZTImageView loadDiscCachedImageDataForKey:key];
        if (imageData)
        {
            image = [UIImage imageWithData:imageData];
        }
    }
    
    return image;
}



@end
