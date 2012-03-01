//
//  NSArray+Access.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 2/29/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "NSArray+Access.h"

@implementation NSArray (Access)

- (BOOL)isValidIndex:(NSInteger)index
{
    if (index >= 0 && index < [self count]) {
        return YES;
    }
    
    return NO;
}

- (id)safeObjectAtIndex:(NSInteger)index
{
    if ([self isValidIndex:index]) {
        return [self objectAtIndex:index];
    }
        
    return nil;
}

@end

@implementation NSMutableArray (Access)

- (void)safeRemoveObjectAtIndex:(NSInteger)index
{
    if ([self isValidIndex:index]) {
        return [self removeObjectAtIndex:index];
    }
}


@end