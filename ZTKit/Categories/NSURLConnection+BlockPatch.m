//
//  NSURLConnection+BlockPatch.m
//  ZTKit
//
//  Created by Zachry Thayer on 4/23/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "NSURLConnection+BlockPatch.h"

#import <objc/runtime.h>


@interface NSURLConnection (ActualBlockPatch)

+ (void)patch_sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;

@end

@implementation NSURLConnection (ActualBlockPatch)

+ (void)patch_sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    
    void (^asyncRequestBlock)() = ^(){
        
        NSURLResponse* theResponse;
        NSError* theError;
        
        NSData *theData = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
        
        handler(theResponse, theData, theError);
        
    };
    
    
    if (queue)
    {
        [queue addOperationWithBlock:asyncRequestBlock];
    }
    else
    {
        dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_async(dispatchQueue, asyncRequestBlock);   
    }
    
}

@end

@implementation NSURLConnection (BlockPatch)

+ (void)load
{
	const char *targetName = "NSURLConnection";
    Class targetClass = objc_getClass(targetName);
    
	if(targetClass)// NSURLConnection exists
	{
        
        SEL sendAsyncSelector = @selector(sendAsynchronousRequest:queue:completionHandler:);
        
        Method sendAsync = class_getClassMethod(targetClass, sendAsyncSelector);
        
        if (sendAsync == NULL) // async blocks requests don't exist, so, lets add it
        {
            SEL sendAsyncSelector_patch = @selector(patch_sendAsynchronousRequest:queue:completionHandler:);

            Method sendAsync_patch = class_getClassMethod(targetClass, sendAsyncSelector_patch);
            IMP sendAsyncImplementation = method_getImplementation(sendAsync_patch);
            //class_replaceMethod(targetClass, sendAsyncSelector, sendAsyncImplementation, method_getTypeEncoding(sendAsync_patch));
            
            // Class Methonds must be added to the metaClass
            Class targetMetaClass = object_getClass(targetClass);
            
            assert(class_addMethod(targetMetaClass, sendAsyncSelector, sendAsyncImplementation, method_getTypeEncoding(sendAsync_patch)));
                       
        }
                
	}
    else
    {
        // TODO: Inject NSURLConnection class (should never be relevant)
    }
}

@end
