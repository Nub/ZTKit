//
//  NSArray+Access.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 2/29/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSArray (Access)

- (BOOL)isValidIndex:(NSInteger)index;

- (id)safeObjectAtIndex:(NSInteger)index;

@end

@interface NSMutableArray (Access)

- (void)safeRemoveObjectAtIndex:(NSInteger)index;

@end