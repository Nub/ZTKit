//
//  NSObject+ZTAdditions.h
//  ZTKit
//
//  Created by Zachry Thayer on 3/7/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZTAdditions)

- (NSDictionary*)dictionaryValue;

- (NSArray*)allPropertyKeys;

- (NSArray*)allPropertyKeyPaths;

// Exclude container type keypaths
- (NSArray*)allBasePropertyKeyPaths;

- (BOOL)hasPropertyForKey:(NSString*)key;

- (BOOL)hasIvarForKey:(NSString*)key;

- (id)valueForArrayIndexedKeyPath:(NSString *)keyPath;

// For all values in object

- (void)syncPropertyValuesFrom:(id)object;

- (void)syncPropertyValuesFrom:(id)object discrepencyHandler:(void (^)(NSString* keyPath, id destObj, id srcObj))handler;

@end
