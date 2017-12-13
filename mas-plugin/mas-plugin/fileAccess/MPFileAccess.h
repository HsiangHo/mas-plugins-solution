//
//  MPFileAccess.h
//  mas-plugin
//
//  Created by Jovi on 12/13/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MPFileAccessBlock)();

@interface MPFileAccess : NSObject

+(BOOL)persistAccessFilePath:(NSURL *)path withBlock:(MPFileAccessBlock)block;
-(BOOL)accessFilePath:(NSURL *)path persistPermission:(BOOL)persist withBlock:(MPFileAccessBlock)block;

@end
