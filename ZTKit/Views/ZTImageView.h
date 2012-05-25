//
//  ZTImageView.h
//  ZTKit
//
//  Created by Zachry Thayer on 5/22/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTImageView : UIView

@property (nonatomic, strong)UIImage* image;
@property (nonatomic) BOOL cacheToDisk;

- (ZTImageView*)initWithImageSource:(NSString*)source;
- (ZTImageView*)initWithImageURL:(NSURL*)url;

- (void)setImageSource:(NSString*)source;
- (void)setImageURL:(NSURL *)url;


@end
