//
//  ZTSocketConnection.m
//  Dashter
//
//  Created by Zachry Thayer on 5/22/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "ZTSocketConnection.h"

@interface ZTSocketConnection ()

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, strong) NSMutableDictionary* streamEventHandlers;

@property (nonatomic, strong) NSMutableData* inputData;

@end

@implementation ZTSocketConnection

@synthesize inputStream;
@synthesize outputStream;
@synthesize streamEventHandlers;

@synthesize inputData;

#pragma mark - Lifecycle

- (ZTSocketConnection*)initStreamWithHost:(NSString*)host port:(NSUInteger)port
{
    self = [self init];
    if (self)
    {
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host, port, &readStream, &writeStream);
        
        self.inputStream = (__bridge_transfer NSInputStream *)readStream;
        self.outputStream = (__bridge_transfer NSOutputStream *)writeStream;
        
        NSAssert(self.inputStream && self.outputStream, @"%@: input or output stream is an invalid object",__PRETTY_FUNCTION__);
        
        [self.inputStream setDelegate:self];
        [self.outputStream setDelegate:self];
        
        [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [self.inputStream open];
        [self.outputStream open];   
    }
    
    return self;
}

- (void)dealloc
{
    [self.inputStream close];
    [self.outputStream close];
    
    self.inputStream = nil;
    self.outputStream = nil;
}

#pragma mark - Public Methods

- (void)handleStreamEvent:(NSStreamEvent)event withBlock:(NSStreamEventBlock)block
{
    NSString *key = [NSString stringWithFormat:@"NSStreamEvent_%i",event];
    [self.streamEventHandlers setObject:[block copy] forKey:key];
}

- (NSData*)readData
{
    //Grab data and clear cache
    NSData *readData = [NSData dataWithData:self.inputData];
    self.inputData = nil;
    
    return readData;
}

-(void)writeData:(NSData*)data
{
    if ([self.outputStream hasSpaceAvailable])
    {
        [self.outputStream write:[data bytes] maxLength:[data length]];
    }
}

#pragma mark - Stream Delegate

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    
    // Automate reading to make it easier
    if (eventCode == NSStreamEventHasBytesAvailable)
    {
        NSInputStream *input = (NSInputStream*)aStream; 
        
        unsigned int chunkSize = 1024;
        unsigned char buffer[chunkSize];
        NSInteger length = [input read:buffer maxLength:chunkSize];
        
        [self.inputData appendBytes:buffer length:length];
        
        //More data needs to be read
        if (length == chunkSize) 
        {
            while (length == chunkSize)
            {
                length = [input read:buffer maxLength:chunkSize];
                [self.inputData appendBytes:buffer length:length];
            }
        }
    }
    
    NSString *key = [NSString stringWithFormat:@"NSStreamEvent_%i",eventCode];
    NSStreamEventBlock eventBlock = [self.streamEventHandlers objectForKey:key];
    
    if (eventBlock)
    {
        eventBlock(aStream);
    }   
}

#pragma mark - Accessors

- (NSMutableDictionary*)streamEventHandlers
{
    if (!streamEventHandlers)
    {
        streamEventHandlers = [NSMutableDictionary dictionary];
    }
                               
    return streamEventHandlers;
}

- (NSMutableData*)inputData
{
    if (!inputData)
    {
        inputData = [NSMutableData data];
    }
    
    return inputData;
}

@end
