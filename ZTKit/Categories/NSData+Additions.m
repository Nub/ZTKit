//
//  NSData+Additions.m
//  ZTKit
//
//  Created by Zachry Thayer on 10/09/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import <zlib.h>
#import <CommonCrypto/CommonCryptor.h>

#import "NSData+Additions.h"

@implementation NSData (Additions)


#pragma mark - AES Encryption

- (NSData *)AESEncryptWithKey:(NSString *)key {
    
	char keyPtr[kCCKeySizeAES256+1];
	bzero(keyPtr, sizeof(keyPtr));
	
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	NSUInteger dataLength = [self length];

    
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesEncrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
	
    if (cryptStatus == kCCSuccess) 
		return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
	
    
	free(buffer);
	return nil;
}

- (NSData *)AESDecryptWithKey:(NSString *)key {
	
	char keyPtr[kCCKeySizeAES256+1];
	bzero(keyPtr, sizeof(keyPtr));
	
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	NSUInteger dataLength = [self length];
	
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesDecrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
	
	if (cryptStatus == kCCSuccess)
		return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
	
	free(buffer);
	return nil;
}


#pragma mark - Base 64

+ (NSData *)dataWithBase64EncodedString:(NSString *)string {
    
    NSData *result = [[NSData alloc] initWithBase64EncodedString:string];
    return result;
    
}

- (id)initWithBase64EncodedString:(NSString *)string {
    
    NSMutableData *mutableData = nil;
    
    if (string) {
        unsigned long ixtext = 0;
        unsigned long lentext = 0;
        unsigned char ch = 0;
        unsigned char inbuf[4], outbuf[3];
        short i = 0, ixinbuf = 0;
        BOOL flignore = NO;
        BOOL flendtext = NO;
        NSData *base64Data = nil;
        const unsigned char *base64Bytes = nil;
        
        // Convert the string to ASCII data.
        base64Data = [string dataUsingEncoding:NSASCIIStringEncoding];
        base64Bytes = [base64Data bytes];
        mutableData = [NSMutableData dataWithCapacity:[base64Data length]];
        lentext = [base64Data length];
        
        while (YES) {
            if( ixtext >= lentext ) break;
            ch = base64Bytes[ixtext++];
            flignore = NO;
            
            if( ( ch >= 'A' ) && ( ch <= 'Z' ) ) ch = ch - 'A';
            else if( ( ch >= 'a' ) && ( ch <= 'z' ) ) ch = ch - 'a' + 26;
            else if( ( ch >= '0' ) && ( ch <= '9' ) ) ch = ch - '0' + 52;
            else if( ch == '+' ) ch = 62;
            else if( ch == '=' ) flendtext = YES;
            else if( ch == '/' ) ch = 63;
            else flignore = YES; 
            
            if (!flignore ) {
                short ctcharsinbuf = 3;
                BOOL flbreak = NO;
                
                if (flendtext) {
                    if (!ixinbuf ) break;
                    if (( ixinbuf == 1) || (ixinbuf == 2)) ctcharsinbuf = 1;
                    else ctcharsinbuf = 2;
                    ixinbuf = 3;
                    flbreak = YES;
                }
                
                inbuf [ixinbuf++] = ch;
                
                if (ixinbuf == 4) {
                    ixinbuf = 0;
                    outbuf [0] = ( inbuf[0] << 2 ) | ( ( inbuf[1] & 0x30) >> 4 );
                    outbuf [1] = ( ( inbuf[1] & 0x0F ) << 4 ) | ( ( inbuf[2] & 0x3C ) >> 2 );
                    outbuf [2] = ( ( inbuf[2] & 0x03 ) << 6 ) | ( inbuf[3] & 0x3F );
                    
                    for( i = 0; i < ctcharsinbuf; i++ ) 
                        [mutableData appendBytes:&outbuf[i] length:1];
                }
                
                if (flbreak)  break;
            }
        }
    }
    
    self = [self initWithData:mutableData];
    return self;
    
}


#pragma mark - Gzip

- (NSData *)gzipDeflate {
	
    if ([self length] == 0) return self;
	
	z_stream strm;
	
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = Z_NULL;
	strm.total_out = 0;
	strm.next_in=(Bytef *)[self bytes];
	strm.avail_in = [self length];
	
	if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
	
	NSMutableData *compressed = [NSMutableData dataWithLength:16384];
	
	do {
		
		if (strm.total_out >= [compressed length])
			[compressed increaseLengthBy: 16384];
		
		strm.next_out = [compressed mutableBytes] + strm.total_out;
		strm.avail_out = [compressed length] - strm.total_out;
		
		deflate(&strm, Z_FINISH);  
		
	} while (strm.avail_out == 0);
	
	deflateEnd(&strm);
	
	[compressed setLength: strm.total_out];
	return [NSData dataWithData:compressed];
    
}

- (NSData *)gzipInflate {
    
	if ([self length] == 0) return self;
	
	unsigned full_length = [self length];
	unsigned half_length = [self length] / 2;
	
	NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
	BOOL done = NO;
	int status;
	
	z_stream strm;
	strm.next_in = (Bytef *)[self bytes];
	strm.avail_in = [self length];
	strm.total_out = 0;
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	
	if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
	while (!done) {
		
		if (strm.total_out >= [decompressed length])
			[decompressed increaseLengthBy: half_length];
		strm.next_out = [decompressed mutableBytes] + strm.total_out;
		strm.avail_out = [decompressed length] - strm.total_out;
		
		status = inflate (&strm, Z_SYNC_FLUSH);
		if (status == Z_STREAM_END) done = YES;
		else if (status != Z_OK) break;
	}
	if (inflateEnd (&strm) != Z_OK) return nil;
	
	if (done) {
		[decompressed setLength: strm.total_out];
		return [NSData dataWithData: decompressed];
	} else 
        return nil;
    
}


#pragma mark - TBXML

+ (NSData *)dataWithUncompressedContentsOfFile:(NSString *)file {
	
	NSData * result;
    
	if ([[file pathExtension] isEqualToString:@"gz"]) {
		NSData * compressedData = [NSData dataWithContentsOfFile:file];
		result = [compressedData gzipInflate];
	}
	else
		result = [NSData dataWithContentsOfFile:file];
    
    return result;
    
}


#pragma mark - Miscellaneous

- (NSString *)hexString {
    
    NSMutableString *string = [NSMutableString stringWithCapacity:64];
    int length = [self length];
    char *bytes = malloc(sizeof(char) * length);
    
    [self getBytes:bytes length:length];
    
    for (int i = 0; i < length; i++)
        [string appendFormat:@"%02.2hhx", bytes[i]];
        
    free(bytes);
    
    return string;
    
}


@end
