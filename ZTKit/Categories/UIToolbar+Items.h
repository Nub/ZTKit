//
//  UIToolbar+Items.h
//  ZTKit
//
//  Created by Zachry Thayer on 2/29/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToolbar (Items)

- (void)addBarButtonItemRight:(UIBarButtonItem*)newBarButtonItem;
- (void)addBarButtonItemLeft:(UIBarButtonItem*)newBarButtonItem;

- (void)addBarButtonItem:(UIBarButtonItem*)newBarButtonItem beforeBarButtonItem:(UIBarButtonItem*)barButtonItem;
- (void)addBarButtonItem:(UIBarButtonItem*)newBarButtonItem afterBarButtonItem:(UIBarButtonItem*)barButtonItem;

- (void)removeBarButtonItem:(UIBarButtonItem*)barButtonItem;
- (void)removeBarButtonItemAtIndex:(NSInteger)index;

#pragma mark - Animated

- (void)addBarButtonItemRight:(UIBarButtonItem*)newBarButtonItem animated:(BOOL)doAnimation;
- (void)addBarButtonItemLeft:(UIBarButtonItem*)newBarButtonItem animated:(BOOL)doAnimation;

- (void)addBarButtonItem:(UIBarButtonItem*)newBarButtonItem beforeBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)doAnimation;
- (void)addBarButtonItem:(UIBarButtonItem*)newBarButtonItem afterBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)doAnimation;

- (void)removeBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)doAnimation;
- (void)removeBarButtonItemAtIndex:(NSInteger)index animated:(BOOL)doAnimation;


@end
