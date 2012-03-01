//
//  UIToolbar+Items.m
//  ZTKit
//
//  Created by Zachry Thayer on 2/29/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "UIToolbar+Items.h"
#import "NSArray+Access.h"


@implementation UIToolbar (Items)

- (void)addBarButtonItemRight:(UIBarButtonItem*)newBarButtonItem
{
    [self addBarButtonItemRight:newBarButtonItem animated:NO];
}

- (void)addBarButtonItemLeft:(UIBarButtonItem*)newBarButtonItem
{
    [self addBarButtonItemLeft:newBarButtonItem animated:NO];
}

- (void)addBarButtonItem:(UIBarButtonItem*)newBarButtonItem beforeBarButtonItem:(UIBarButtonItem*)barButtonItem
{
    [self addBarButtonItem:newBarButtonItem beforeBarButtonItem:barButtonItem animated:NO];
}

- (void)addBarButtonItem:(UIBarButtonItem*)newBarButtonItem afterBarButtonItem:(UIBarButtonItem*)barButtonItem
{
    [self addBarButtonItem:newBarButtonItem afterBarButtonItem:barButtonItem animated:NO];
}

- (void)removeBarButtonItem:(UIBarButtonItem*)barButtonItem
{
    [self removeBarButtonItem:barButtonItem animated:NO];
}

- (void)removeBarButtonItemAtIndex:(NSInteger)index
{
    [self removeBarButtonItemAtIndex:index animated:NO];
}

#pragma mark - Animated

- (void)addBarButtonItemRight:(UIBarButtonItem*)newBarButtonItem animated:(BOOL)doAnimation
{
    NSMutableArray *newItemArray = [NSMutableArray arrayWithArray:self.items];
    [newItemArray addObject:newBarButtonItem];
    
    [self setItems:newItemArray animated:doAnimation];
}

- (void)addBarButtonItemLeft:(UIBarButtonItem*)newBarButtonItem animated:(BOOL)doAnimation
{
    NSMutableArray *newItemArray = [NSMutableArray arrayWithArray:self.items];
    [newItemArray insertObject:newItemArray atIndex:0];
    
    [self setItems:newItemArray animated:doAnimation];
}

- (void)addBarButtonItem:(UIBarButtonItem*)newBarButtonItem beforeBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)doAnimation
{
    NSMutableArray *newItemArray = [NSMutableArray arrayWithArray:self.items];
    
    NSInteger indexOfBarButtonItem = [newItemArray indexOfObject:barButtonItem];
    
    if (indexOfBarButtonItem == NSNotFound) {
        [newItemArray insertObject:barButtonItem atIndex:0];
    }
    else
    {
        indexOfBarButtonItem = (indexOfBarButtonItem - 1 >= 0)? indexOfBarButtonItem - 1 : 0;
        [newItemArray insertObject:newBarButtonItem atIndex:indexOfBarButtonItem];   
    }
    
    [self setItems:newItemArray animated:doAnimation];
}

- (void)addBarButtonItem:(UIBarButtonItem*)newBarButtonItem afterBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)doAnimation
{
    NSMutableArray *newItemArray = [NSMutableArray arrayWithArray:self.items];
    
    NSInteger indexOfBarButtonItem = [newItemArray indexOfObject:barButtonItem];
    if (indexOfBarButtonItem == NSNotFound) {
        [newItemArray addObject:barButtonItem];
    }
    else
    {
        indexOfBarButtonItem++;
        [newItemArray insertObject:newBarButtonItem atIndex:indexOfBarButtonItem];
    }
    
    [self setItems:newItemArray animated:doAnimation];
}

- (void)removeBarButtonItem:(UIBarButtonItem*)barButtonItem animated:(BOOL)doAnimation
{
    NSMutableArray *newItemArray = [NSMutableArray arrayWithArray:self.items];
    
    if ([newItemArray containsObject:barButtonItem])
    {
        [newItemArray removeObject:barButtonItem];
    }
    else
    {
        return;
    }
    
    [self setItems:newItemArray animated:doAnimation];
}

- (void)removeBarButtonItemAtIndex:(NSInteger)index animated:(BOOL)doAnimation
{
    NSMutableArray *newItemArray = [NSMutableArray arrayWithArray:self.items];
    
    [newItemArray safeRemoveObjectAtIndex:index];
    
    [self setItems:newItemArray animated:doAnimation];
}



@end
