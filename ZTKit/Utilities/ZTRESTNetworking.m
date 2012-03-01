//
//  ZTRESTNetworking.m
//  ZTKit
//
//  Created by Zachry Thayer on 9/30/11.
//  Copyright 2011 Zachry Thayer. All rights reserved.
//

#import "ZTRESTNetworking.h"
#import "JSONKit.h"

@interface ZTRESTConnection : NSObject {
    
    NSMutableData *data;
    NSURLConnection *connection;
    NSString *collection;
    NSArray *param;
    ZTCompletionBlock block;
    NSURLResponse *response;
}

@property (retain, readonly) NSData *data;
@property (retain) NSURLResponse *response;

- (id)initWithCollection:(NSString *)_collection 
                   param:(NSArray *)_param 
              connection:(NSURLConnection *)_connection 
              completion:(ZTCompletionBlock)_block;

- (void)addData:(NSData *)newData;

- (void)didFinish;
- (void)didFinishWithError:(NSError *)error;

@end


@implementation ZTNetworking

@synthesize apiURL;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
        
        apiURL = [[NSURL alloc] initWithString:@"http://thayer-remodeling.com/ZT/api/"];
        
        connections = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    self.apiURL = nil;
    [connections release];
    
    [super dealloc];
}

- (NSString *)keyForConnection:(NSURLConnection *)connection
{
    return [NSString stringWithFormat:@"%X",[connection hash]];
}

- (NSURL *)urlForCollection:(NSString *)collection
                      param:(NSArray *)param
{
    NSString *params = nil;
    if(param == nil)
        params = @"";
    else
        params = [param componentsJoinedByString:@"/"];
    
    NSString *str = [NSString stringWithFormat:@"%@/%@",collection,params];
    return [NSURL URLWithString:str
                  relativeToURL:apiURL];
}

- (void)getFromCollection:(NSString *)collection
               parameters:(NSArray *)param
               completion:(ZTCompletionBlock)block
{
    NSURL *url = [self urlForCollection:collection
                                  param:param];
    
    // Create the request
    NSURLConnection *urlConnection = [NSURLConnection alloc];
    urlConnection = [urlConnection initWithRequest:[NSURLRequest requestWithURL:url]
                                          delegate:self];
    
    if(urlConnection)
    {
        ZTRESTConnection *conn = [ZTRESTConnection alloc];
        conn = [conn initWithCollection:collection 
                                  param:param 
                             connection:urlConnection 
                             completion:block];
        
        [connections setObject:conn forKey:[self keyForConnection:urlConnection]];
        [conn release];
    }
    else
    {
        if(block)
            block(collection,param,[NSError errorWithDomain:@"ZTNetworkingDomain"
                                                       code:1 // can't connect
                                                   userInfo:nil]);
    }
}

- (void)postToCollection:(NSString *)collection
                    data:(NSData *)data
              parameters:(NSArray *)param
              completion:(ZTCompletionBlock)block
{
    NSURL *url = [self urlForCollection:collection
                                  param:param];
    
    NSString *wrapper = @"data=";
    NSMutableData *rdata = [NSMutableData dataWithBytes:[wrapper UTF8String]
                                                 length:[wrapper lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    [rdata appendData:data];
    
    // Create the request
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:rdata];
    [req setValue:[NSString stringWithFormat:@"%d",[rdata length]] forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *urlConnection = [NSURLConnection alloc];
    urlConnection = [urlConnection initWithRequest:req
                                          delegate:self];
    
    if(urlConnection)
    {
        ZTRESTConnection *conn = [ZTRESTConnection alloc];
        conn = [conn initWithCollection:collection 
                                  param:param 
                             connection:urlConnection 
                             completion:block];
        
        [connections setObject:conn forKey:[self keyForConnection:urlConnection]];
        [conn release];
    }
    else
    {
        if(block)
            block(collection,param,[NSError errorWithDomain:@"ZTNetworkingDomain"
                                                       code:1 // can't connect
                                                   userInfo:nil]);
    }
}

- (void)putToCollection:(NSString *)collection
                   data:(NSData *)data
             parameters:(NSArray *)param
             completion:(ZTCompletionBlock)block
{
    NSURL *url = [self urlForCollection:collection
                                  param:param];
    
    // Create the request
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"PUT"];
    [req setHTTPBody:data];
    [req setValue:[NSString stringWithFormat:@"%d",[data length]] forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *urlConnection = [NSURLConnection alloc];
    urlConnection = [urlConnection initWithRequest:req
                                          delegate:self];
    
    if(urlConnection)
    {
        ZTRESTConnection *conn = [ZTRESTConnection alloc];
        conn = [conn initWithCollection:collection 
                                  param:param 
                             connection:urlConnection 
                             completion:block];
        
        [connections setObject:conn forKey:[self keyForConnection:urlConnection]];
        [conn release];
    }
    else
    {
        if(block)
            block(collection,param,[NSError errorWithDomain:@"ZTNetworkingDomain"
                                                       code:1 // can't connect
                                                   userInfo:nil]);
    }
}

#pragma mark - Connection delegate

- (void)connection:(NSURLConnection *)connection 
    didReceiveData:(NSData *)data
{
    ZTRESTConnection *conn = [connections objectForKey:[self keyForConnection:connection]];
    if(conn == nil)
        return;
    [conn addData:data];
}

- (void)connection:(NSURLConnection *)connection 
didReceiveResponse:(NSURLResponse *)response
{
    ZTRESTConnection *conn = [connections objectForKey:[self keyForConnection:connection]];
    if(conn == nil)
        return;
    [conn setResponse:response];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    ZTRESTConnection *conn = [connections objectForKey:[self keyForConnection:connection]];
    if(conn == nil)
        return;
    [conn didFinish];
    [connections removeObjectForKey:[self keyForConnection:connection]];
    [connection release];
}

- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error
{
    ZTRESTConnection *conn = [connections objectForKey:[self keyForConnection:connection]];
    if(conn == nil)
        return;
    [conn didFinishWithError:error];
    
    // Remove and release the object. This should also dealloc the object
    [connections removeObjectForKey:[self keyForConnection:connection]];
    [connection release];
}

@end

@implementation ZTRESTConnection

@synthesize data, response;

- (id)initWithCollection:(NSString *)_collection 
                   param:(NSArray *)_param 
              connection:(NSURLConnection *)_connection 
              completion:(ZTCompletionBlock)_block
{
    self = [super init];
    if (self)
    {
        data = [[NSMutableData alloc] init];
        collection = [_collection retain];
        param = [_param retain];
        connection = [_connection retain];
        block = [_block copy];
    }
    
    return self;
}

- (void)dealloc {

    [data release];
    [param release];
    [collection release];
    [block release];
    [connection release];
    
    [super dealloc];
}

- (void)addData:(NSData *)newData {
    if(newData)
    {
        [data appendData:newData];
    }
}

- (void)didFinish
{
    if(response && [response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if(statusCode != 200 /*OK*/
           && statusCode != 201 /*CREATED*/
           )
        {
            if(block)
                block(collection,param,[NSError errorWithDomain:@"ZTNetworkingDomain"
                                                           code:statusCode
                                                       userInfo:nil]);
            return;
        }
    }
    
    id jsonObj = [data objectFromJSONData];
    if(block)
        block(collection,param,jsonObj);
}

- (void)didFinishWithError:(NSError *)error
{
    if(block)
        block(collection,param,error);
}

@end
