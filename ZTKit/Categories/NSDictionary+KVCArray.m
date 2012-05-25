//
//  NSDictionary+KVCArray.m
//  KVCArrays
//
//  Created by Zachry Thayer on 5/9/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "NSDictionary+KVCArray.h"

@implementation NSDictionary (KVCArray)

- (id)valueForKeyPath:(NSString *)keyPath
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

@end
