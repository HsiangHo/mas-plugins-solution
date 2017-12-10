//
//  MPPackageWrapper.h
//  mas-plugin
//
//  Created by Jovi on 12/10/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPPackageWrapper : NSObject

+ (BOOL)packPlugin:(NSString *)dirPath key:(NSString *)key outPath:(NSString *)outPath;
+ (BOOL)unpackPlugin:(NSString *)path key:(NSString *)key outDir:(NSString *)outDir;

@end
