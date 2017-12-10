//
//  MPPackageWrapper.m
//  mas-plugin
//
//  Created by Jovi on 12/10/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "MPPackageWrapper.h"
#import "MPAESCryptor.h"

@implementation MPPackageWrapper

+ (BOOL)packPlugin:(NSString *)dirPath key:(NSString *)key outPath:(NSString *)outPath{
    if(nil == dirPath || [dirPath isEqualToString:@""] || nil == key || [key isEqualToString:@""] || nil == outPath || [outPath isEqualToString:@""]){
        return NO;
    }
    //pack
    NSString *tmpPath = [[outPath stringByDeletingLastPathComponent] stringByAppendingString:[NSString stringWithFormat:@"/tmp_E_%ld.zip",time(NULL)]];
    NSString *command = [NSString stringWithFormat:@"cd '%@';zip -q -r -X '%@' folder '%@'",[dirPath stringByDeletingLastPathComponent],tmpPath,[dirPath lastPathComponent]];
    system([command UTF8String]);
    
    //encrypt
    NSData *zipData = [[NSData alloc] initWithContentsOfFile:tmpPath];
    if(nil == zipData){
        return NO;
    }
    NSData *encryptedData = [MPAESCryptor encryptData:zipData key:[key dataUsingEncoding:NSUTF8StringEncoding] iv:nil];
    [encryptedData writeToFile:outPath atomically:NO];
    [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
    return YES;
}

+ (BOOL)unpackPlugin:(NSString *)path key:(NSString *)key outDir:(NSString *)outDir{
    if(nil == path || [path isEqualToString:@""] || nil == key || [key isEqualToString:@""] || nil == outDir || [outDir isEqualToString:@""]){
        return NO;
    }
    //decrypt
     NSString *tmpPath = [outDir stringByAppendingString:[NSString stringWithFormat:@"/tmp_D_%ld.zip",time(NULL)]];
    NSData *encryptedData = [[NSData alloc] initWithContentsOfFile:path];
    if(nil == encryptedData){
        return NO;
    }
    NSData *decryptedData = [MPAESCryptor decryptData:encryptedData key:[key dataUsingEncoding:NSUTF8StringEncoding] iv:nil];
    [decryptedData writeToFile:tmpPath atomically:NO];
    
    //unpack
    NSString *command = [NSString stringWithFormat:@"unzip -o '%@' -d '%@'", tmpPath, outDir];
    system([command UTF8String]);
    
    [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
    return YES;
}

@end
