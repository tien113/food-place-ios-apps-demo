//
//  NSString+Cryptography.m
//  MacAddress
//
//  Created by vo on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Cryptography.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Cryptography)

// MD5
- (NSString *)toMD5 {
    
    const char *cstr = [self UTF8String];
    unsigned char digest[16];
    
    CC_MD5(cstr, strlen(cstr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

// SHA1
- (NSString *)toSHA1 {
    
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) 
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
