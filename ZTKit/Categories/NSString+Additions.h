//
//  NSString+Additions.h
//  ZTKit
//
//  Created by Zachry Thayer on 10/09/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

#pragma mark - URL Encoding
- (NSString *)URLEncodeString;
+ (NSString *)URLEncodeString:(NSString *)string;


#pragma mark - MD5 Encryption
- (NSString *)MD5EncryptString;
+ (NSString *)MD5EncryptString:(NSString *)string;


#pragma mark - Sha1 Encryption
- (NSString *)Sha1EncryptString;
+ (NSString *)Sha1EncryptString:(NSString *)string;


#pragma mark - Base 64
- (NSString *)base64EncodeString;
+ (NSString *)base64EncodeString:(NSString *)string;


#pragma mark - Miscellaneous
- (NSString *)reverse;
+ (NSString *)reverseString:(NSString *)string;

- (NSString *)trim;
+ (NSString *)trim:(NSString *)string;

- (BOOL)startsWithString:(NSString *)string;
- (BOOL)containsString:(NSString *)string;

- (NSString *)substringFrom:(NSInteger)from to:(NSInteger)to;
- (NSInteger)indexOf:(NSString *)subString from:(NSInteger)start;


@end
