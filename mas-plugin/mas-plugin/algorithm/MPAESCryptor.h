//
//  MPAESCryptor.h
//  mas-plugin
//
//  Created by Jovi on 12/10/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

#define MPENCRYPT_ALGORITHM     kCCAlgorithmAES128
#define MPENCRYPT_BLOCK_SIZE    kCCBlockSizeAES128
#define MPENCRYPT_KEY_SIZE      kCCKeySizeAES128

@interface MPAESCryptor : NSObject

+ (NSData*)encryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*)decryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;

@end
