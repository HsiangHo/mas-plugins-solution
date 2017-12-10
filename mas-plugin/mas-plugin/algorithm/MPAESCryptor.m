//
//  MPAESCryptor.m
//  mas-plugin
//
//  Created by Jovi on 12/10/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "MPAESCryptor.h"

@implementation MPAESCryptor

+ (NSData*)encryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv{
    NSData* result = nil;
    
    unsigned char cKey[MPENCRYPT_KEY_SIZE];
    bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:MPENCRYPT_KEY_SIZE];
    
    char cIv[MPENCRYPT_BLOCK_SIZE];
    bzero(cIv, MPENCRYPT_BLOCK_SIZE);
    if (NULL != iv) {
        [iv getBytes:cIv length:MPENCRYPT_BLOCK_SIZE];
    }
    
    size_t bufferSize = [data length] + MPENCRYPT_BLOCK_SIZE;
    void *buffer = malloc(bufferSize);
    
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          MPENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
                                          cKey,
                                          MPENCRYPT_KEY_SIZE,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (kCCSuccess == cryptStatus) {
        result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
    } else {
        free(buffer);
    }
    
    return result;
}

+ (NSData*)decryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv{
    NSData* result = nil;
    
    unsigned char cKey[MPENCRYPT_KEY_SIZE];
    bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:MPENCRYPT_KEY_SIZE];
    
    char cIv[MPENCRYPT_BLOCK_SIZE];
    bzero(cIv, MPENCRYPT_BLOCK_SIZE);
    if (NULL != iv) {
        [iv getBytes:cIv length:MPENCRYPT_BLOCK_SIZE];
    }
    
    size_t bufferSize = [data length] + MPENCRYPT_BLOCK_SIZE;
    void *buffer = malloc(bufferSize);
    
    size_t decryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          MPENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
                                          cKey,
                                          MPENCRYPT_KEY_SIZE,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &decryptedSize);
    
    if (kCCSuccess == cryptStatus) {
        result = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
    } else {
        free(buffer);
    }
    
    return result;
}

@end
