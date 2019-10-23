//
//  NSObject+String_Encrypt.m
//  Bloomr
//
//  Created by Tan Tan on 10/5/19.
//  Copyright © 2019 phdv. All rights reserved.
//

#import "NSString+Crypto.h"

@implementation NSString (Crypto)
- (NSString *)encryptDESByKey:(NSString *)key iv:(NSString*)iv
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    plainTextBufferSize = [self length];
    vplainText = (const void *) [self UTF8String];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const unsigned char *keyString = (const unsigned char *)[key cStringUsingEncoding: NSUTF8StringEncoding];
    const unsigned char *initializeVactorString = (const unsigned char *)[iv cStringUsingEncoding: NSUTF8StringEncoding];
    
    uint8_t ivData[kCCBlockSize3DES];
    memset((void *) ivData, 0x0, (size_t) sizeof(ivData));
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       keyString,
                       kCCKeySize3DES,
                       initializeVactorString,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result;
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    
    if ([myData respondsToSelector:@selector(base64EncodedStringWithOptions:)])
    {
        result = [myData base64EncodedStringWithOptions:0];  // iOS 7+
    }
    
    return result;
}

- (NSString *)decryptDESByKey:(NSString *)key iv:(NSString*)iv
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    NSData *encryptData;
    
    if ([NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)])
    {
        encryptData = [[NSData alloc]initWithBase64EncodedString:self options:0];  // iOS 7+
    }
    
    plainTextBufferSize = [encryptData length];
    vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const unsigned char *keyString = (const unsigned char *)[key cStringUsingEncoding: NSUTF8StringEncoding];
    const unsigned char *initializeVactorString = (const unsigned char *)[iv cStringUsingEncoding: NSUTF8StringEncoding];
    
    uint8_t ivData[kCCBlockSize3DES];
    memset((void *) ivData, 0x0, (size_t) sizeof(ivData));
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       keyString,
                       kCCKeySize3DES,
                       initializeVactorString,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData: [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSASCIIStringEncoding];
    
    return result;
}

@end
