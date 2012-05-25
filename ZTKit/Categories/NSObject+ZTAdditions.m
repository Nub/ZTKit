//
//  NSObject+ZTAdditions.m
//  ZTKit
//
//  Created by Zachry Thayer on 3/7/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "NSObject+ZTAdditions.h"
#import "UIView+Layout.h"

#import <objc/message.h>

@implementation NSObject (ZTAdditions)

- (NSDictionary*)dictionaryValue
{
    return [self dictionaryWithValuesForKeys:[self allPropertyKeys]];
}

- (NSArray*)allPropertyKeys
{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([self class], &propertyCount);
    
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    
    return propertyNames;
}

- (NSArray*)allPropertyKeyPaths
{
    NSMutableArray *allKeyPaths = [NSMutableArray array];
    
    for (NSString* key in [self allPropertyKeys])
    {
        id obj = [self valueForKey:key];
        [allKeyPaths addObject:key];
        [allKeyPaths addObjectsFromArray:[obj allPropertyKeyPathsWithBaseKeyPath:key]];
    }
    
    return [NSArray arrayWithArray:allKeyPaths];
}

- (NSArray*)allPropertyKeyPathsWithBaseKeyPath:(NSString*)baseKeyPath
{
    NSMutableArray *allKeyPaths = [NSMutableArray array];
    
    for (NSString* key in [self allPropertyKeys])
    {
        id obj = [self valueForKey:key];
		NSString *newBasePath = [baseKeyPath stringByAppendingFormat:@".%@", key];
        [allKeyPaths addObject:newBasePath];
        [allKeyPaths addObjectsFromArray:[obj allPropertyKeyPathsWithBaseKeyPath:newBasePath]];
    }
    
    return [NSArray arrayWithArray:allKeyPaths];
}

- (NSArray*)allBasePropertyKeyPaths
{
    NSMutableArray *allKeyPaths = [NSMutableArray array];
    
    for (NSString* key in [self allPropertyKeys])
    {
        id obj = [self valueForKey:key];
		//NSLog(@"%@:%@", key, obj);
		id subKeys = [obj allBasePropertyKeyPathsWithBaseKeyPath:key];
		if	([subKeys count] > 0)
		{
			[allKeyPaths addObjectsFromArray:subKeys];
		}
		else
		{
            [allKeyPaths addObject:key];
		}
    }
    
    return [NSArray arrayWithArray:allKeyPaths];
}

- (NSArray*)allBasePropertyKeyPathsWithBaseKeyPath:(NSString*)baseKeyPath
{
    NSMutableArray *allKeyPaths = [NSMutableArray array];
    
    for (NSString* key in [self allPropertyKeys])
    {
        id obj = [self valueForKey:key];
		NSString *newBasePath = [baseKeyPath stringByAppendingFormat:@".%@", key];
		id subKeys = [obj allBasePropertyKeyPathsWithBaseKeyPath:newBasePath];
        
		if	([subKeys count] > 0)
		{
			[allKeyPaths addObjectsFromArray:subKeys];
		}
		else
		{
            [allKeyPaths addObject:newBasePath];
		}
    }
    
    return [NSArray arrayWithArray:allKeyPaths];
}


- (BOOL)hasPropertyForKey:(NSString*)key
{
	objc_property_t property = class_getProperty([self class], [key UTF8String]);
	return (BOOL)property;
}

- (BOOL)hasIvarForKey:(NSString*)key
{
	Ivar ivar = class_getInstanceVariable([self class], [key UTF8String]);
	return (BOOL)ivar;
}

- (id)valueForArrayIndexedKeyPath:(NSString *)keyPath
{
    NSArray *keys = [keyPath componentsSeparatedByString:@"."];
    
    id object = nil;
    
    for (NSString* key in keys)
    {
        if ([object isKindOfClass:[NSArray class]])
        {
            NSRange range = [key rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
            if (range.location != NSNotFound)
            {
                NSString *digitKey = [key substringWithRange:range];
                
                NSInteger index = [digitKey integerValue];
                
                BOOL validIndex = (index < [object count])&&(index >= 0);
                
                if (!validIndex)
                {
                    NSString* error = [NSString stringWithFormat:@"Index:%i out of bounds for valueAtKeyPath:@\"%@\" for array:0x%x.count = %i", index, keyPath, &object, [object count]];
                    NSAssert(validIndex, error);
                }
                
                
                object = [object objectAtIndex:index];
            }
        }
        else
        {
            object = [self valueForKey:key];
        }
    }
    
    return object;
}

- (BOOL)syncPropertyValuesDefaultHandlerWith:(NSString*)keypath destObject:(id)destObj srcObject:(id)srcObj
{
    if ([srcObj isKindOfClass:[NSString class]])
    {
        // MAP NSString to text displays
        if ([destObj isKindOfClass:[UILabel class]]     ||
            [destObj isKindOfClass:[UITextView class]]  ||
            [destObj isKindOfClass:[UITextField class]])
        {
            [destObj setText:srcObj];
            return YES;
        }
        
        // MAP NSString to UIImage
        if ([destObj isKindOfClass:[UIImage class]] ||
            [destObj isKindOfClass:[UIImageView class]])
        {
            NSURL *imageURL = [NSURL URLWithString:srcObj];
            
            // Load remote image Async if it's a url
            if (imageURL)
            {
                __block UIActivityIndicatorView* activity;
                
                // Insert placeholder image in the mean time
                dispatch_async(dispatch_get_main_queue(), ^(){
                    
                    if ([destObj isKindOfClass:[UIImage class]])
                    {
                        UIImage *defaultImage = [UIImage imageNamed:@"defaultImage"];
                        [destObj initWithCGImage:[defaultImage CGImage]];
                    }
                    else
                    {
                        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                        [activity sizeToView:destObj];
                        [destObj replaceWithView:activity];
                        [activity startAnimating];
                        //[destObj setImage:defaultImage];
                    }
                });
                
                dispatch_queue_t networkQueue = dispatch_queue_create("com.zachrythayer.fairfaxtest.networkQueue", NULL);
                
                dispatch_async(networkQueue, ^(void){
                    
                    NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
                    UIImage* theImage = [UIImage imageWithData:imageData];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        
                        if ([destObj isKindOfClass:[UIImage class]])
                        {
                            [self setValue:theImage forKeyPath:keypath];
                        }
                        else
                        {
                            [destObj setImage:theImage];
                            [activity replaceWithView: destObj];
                        }
                        
                    });
                });
                
                dispatch_release(networkQueue);
            }
            else
            {
                // Try to load local image
                dispatch_async(dispatch_get_main_queue(), ^(){
                    UIImage *theImage = [UIImage imageNamed:srcObj];
                    
                    if ([destObj isKindOfClass:[UIImage class]])
                    {
                        [destObj initWithCGImage:[theImage CGImage]];
                    }
                    else
                    {
                        [destObj setImage:theImage];
                    }
                });
            }
            
            return YES;
        }
    }
    
    //Not handled
    return NO;
}

- (void)syncPropertyValuesFrom:(id)object
{
    [self syncPropertyValuesFrom:object discrepencyHandler:^(NSString *keypath, id a, id b){}];
}

// For all values in object
- (void)syncPropertyValuesFrom:(id)object discrepencyHandler:(void (^)(NSString* keyPath, id destObj, id srcObj))handler
{
    NSArray* destKeyPaths = [self allPropertyKeys];
    // NSArray* srcKeyPaths = [object allBasePropertyKeyPaths];
    
    for (NSString* keyPath in destKeyPaths)
    {
        id destObject = [self valueForKeyPath:keyPath];
        id srcObject;
        
        @try {
            srcObject = [object valueForKeyPath:keyPath];
        }
        @catch (NSException *exception)
        {
            NSLog(@"%@", exception);
            srcObject = nil;
        }
        
        if (srcObject)
        {
            if ([destObject isKindOfClass:[srcObject class]])
            {
                [self setValue:srcObject forKeyPath:keyPath];
            }
            else
            {
                //Run default object mapping
                if (![self syncPropertyValuesDefaultHandlerWith:keyPath destObject:destObject srcObject:srcObject])
                {
                    //Use custom handler
                    handler(keyPath, destObject, srcObject);
                }
            }   
        }
    }
}

@end
