//
//  NSData+Additions.h
//  ZTKit
//
//  Created by Zachry Thayer on 10/09/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Additions)


#pragma mark - AES Encryption

- (NSData *)AESEncryptWithKey:(NSString *)key;
- (NSData *)AESDecryptWithKey:(NSString *)key;


#pragma mark - Base 64

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (id)initWithBase64EncodedString:(NSString *)string;


#pragma mark - Gzip

- (NSData *)gzipDeflate;
- (NSData *)gzipInflate;


#pragma mark - TBXML

+ (NSData *)dataWithUncompressedContentsOfFile:(NSString *)file;


#pragma mark - Miscellaneous

- (NSString *)hexString;

@end
