//
//  NSString+Additions.m
//  ZTKit
//
//  Created by Zachry Thayer on 10/09/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "NSData+Additions.h"
#import "NSString+Additions.h"

@implementation NSString (Additions)

#pragma mark - URL Encoding
- (NSString *)URLEncodeString {
    
    return [NSString URLEncodeString:self];
    
}

+ (NSString *)URLEncodeString:(NSString *)string {
    
    CFStringRef encodedString = CFURLCreateStringByAddingPercentEscapes(
                                                                        kCFAllocatorDefault, 
                                                                        (__bridge CFStringRef)string,
                                                                        NULL,
                                                                        CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                        kCFStringEncodingUTF8);
    NSString *result = CFBridgingRelease(encodedString);
    return result;
    
}


#pragma mark - MD5 Encryption

- (NSString *)MD5EncryptString {
    
    return [NSString MD5EncryptString:self];
    
}

+ (NSString *)MD5EncryptString:(NSString *)string {
    
    if (string == nil || [string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    
    return outputString;
    
}


#pragma mark - Sha1 Encryption

- (NSString *)Sha1EncryptString {
    
    return [NSString Sha1EncryptString:self];
    
}

+ (NSString *)Sha1EncryptString:(NSString *)string {
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    CC_SHA1(data.bytes, data.length, digest);
    
    NSData *encrypedData = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    return [encrypedData hexString];
    
}


#pragma mark - Base 64

static char encodingTable[64] = {
	'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
	'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
	'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
	'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/' };

- (NSString *)base64EncodeString {
    
    return [NSString base64EncodeString:self];
    
}

+ (NSString *)base64EncodeString:(NSString *)string {
    
    unsigned int lineLength = 0;
    
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    const unsigned char    *bytes = [stringData bytes];
    NSMutableString *result = [NSMutableString stringWithCapacity:[stringData length]];
    unsigned long ixtext = 0;
    unsigned long lentext = [stringData length];
    long ctremaining = 0;
    unsigned char inbuf[3], outbuf[4];
    short i = 0;
    short charsonline = 0, ctcopy = 0;
    unsigned long ix = 0;
    
    while( YES ) {
        ctremaining = lentext - ixtext;
        if( ctremaining <= 0 ) break;
        
        for( i = 0; i < 3; i++ ) {
            ix = ixtext + i;
            if( ix < lentext ) inbuf[i] = bytes[ix];
            else inbuf [i] = 0;
        }
        
        outbuf [0] = (inbuf [0] & 0xFC) >> 2;
        outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
        outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
        outbuf [3] = inbuf [2] & 0x3F;
        ctcopy = 4;
        
        switch( ctremaining ) {
            case 1: 
                ctcopy = 2; 
                break;
            case 2: 
                ctcopy = 3; 
                break;
        }
        
        for( i = 0; i < ctcopy; i++ )
            [result appendFormat:@"%c", encodingTable[outbuf[i]]];
        
        for( i = ctcopy; i < 4; i++ )
            [result appendFormat:@"%c",'='];
        
        ixtext += 3;
        charsonline += 4;
        
        if( lineLength > 0 ) {
            if (charsonline >= lineLength) {
                charsonline = 0;
                [result appendString:@"\n"];
            }
        }
    }
    
    return result;
    
}


#pragma mark - Miscellaneous

- (NSString *)reverse {
    
    return [NSString reverseString:self];
    
}

+ (NSString *)reverseString:(NSString *)string {
    
    NSInteger l = [string length] - 1;
    NSMutableString *ostr = [NSMutableString stringWithCapacity:[string length]];
    
    while (l >= 0) {
        
        NSRange range = [string rangeOfComposedCharacterSequenceAtIndex:l];
        [ostr appendString:[string substringWithRange:range]];
        l -= range.length;
        
    }
    
    return ostr;
    
}


- (NSString *)trim {
    
    return [NSString trim:self];
    
}

+ (NSString *)trim:(NSString *)string {
    
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}


- (BOOL)startsWithString:(NSString *)string {
    
    if ([self length] < [string length])
        return NO;
    else
        return [string isEqualToString:[self substringFrom:0 to:[string length]]];
    
}

- (BOOL)containsString:(NSString *)string {
    
    if (string == nil) return NO;
    
    NSRange range = [[self lowercaseString] rangeOfString:[string lowercaseString]];
    return range.location != NSNotFound;
    
}


- (NSString *)substringFrom:(NSInteger)from to:(NSInteger)to {
    
    NSRange range;
    range.location = from;
    range.length = (to - from);
    
    return [self substringWithRange:range];
    
}

- (NSInteger)indexOf:(NSString *)subString from:(NSInteger)start {
    
    NSRange range;
    range.location = start;
    range.length = ([self length] - start);
    
    NSRange index = [self rangeOfString:subString options:NSLiteralSearch range:range];
    if (index.location == NSNotFound)
        return -1;
        
    return (index.location + index.length);
    
}


@end
