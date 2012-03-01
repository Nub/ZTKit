//
//  ZTRESTNetworking.h
//  ZTKit
//
//  Created by Zachry Thayer on 9/30/11.
//  Copyright 2011 Zachry Thayer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ZTCompletionBlock)(NSString *collection,
                                  NSArray *param,
                                  id ret);

@interface ZTNetworking : NSObject
{
    NSURL *apiURL;
    
    NSMutableDictionary *connections;
}

@property (retain) NSURL *apiURL;

- (void)getFromCollection:(NSString *)collection
               parameters:(NSArray *)param
               completion:(ZTCompletionBlock)block;

- (void)postToCollection:(NSString *)collection
                    data:(NSData *)data
              parameters:(NSArray *)param
              completion:(ZTCompletionBlock)block;

- (void)putToCollection:(NSString *)collection
                    data:(NSData *)data
              parameters:(NSArray *)param
              completion:(ZTCompletionBlock)block;

@end