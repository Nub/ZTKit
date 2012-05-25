//
//  ZTSocketConnection.h
//  Dashter
//
//  Created by Zachry Thayer on 5/22/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NSStreamEventBlock)(NSStream* stream);

@interface ZTSocketConnection : NSObject<NSStreamDelegate>

- (ZTSocketConnection*)initStreamWithHost:(NSString*)host port:(NSUInteger)port;

- (void)handleStreamEvent:(NSStreamEvent)event withBlock:(NSStreamEventBlock)block;

// Access currently cached data
-(NSData*)readData;
-(void)writeData:(NSData*)data;

@end
