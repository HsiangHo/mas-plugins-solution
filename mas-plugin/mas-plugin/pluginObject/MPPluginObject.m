//
//  MPPluginObject.m
//  mas-plugin
//
//  Created by Jovi on 12/11/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "MPPluginObject.h"
#import "MPPackageWrapper.h"
#import "MPFileAccess.h"
#import <Cocoa/Cocoa.h>

#define TMP_DIR             NSTemporaryDirectory()

@implementation MPPluginObject{
    NSString            *_pluginPath;
    NSString            *_key;
    NSString            *_tmpDir;
    NSString            *_loaderPath;
    MPFileAccess        *_fileAccess;
    BOOL                _bLoaded;
}

-(instancetype)initWithMPPluginFile:(NSString *)path withKey:(NSString *)key{
    if (self = [super init]) {
        _pluginPath = path;
        _key = key;
        _bLoaded = NO;
        _tmpDir = [TMP_DIR stringByAppendingString:[NSString stringWithFormat:@"%ld",time(NULL)]];
        _loaderPath = [_tmpDir stringByAppendingString:@"/mas-plugin-loader.app"];
        _fileAccess = [[MPFileAccess alloc] init];
    }
    return self;
}

-(BOOL)loadPlugin{
    if (!_bLoaded) {
        [_fileAccess accessFilePath:[NSURL URLWithString:@"file:///"] persistPermission:YES withBlock:^{
            [[NSFileManager defaultManager] createDirectoryAtPath:_tmpDir withIntermediateDirectories:NO attributes:nil error:nil];
            if([MPPackageWrapper unpackPlugin:_pluginPath key:_key outDir:_tmpDir]){
                _bLoaded = YES;
            }
        }];
    }
    return _bLoaded;
}

-(void)unloadPlugin{
    if (nil != _tmpDir) {
        [_fileAccess accessFilePath:[NSURL URLWithString:@"file:///"] persistPermission:YES withBlock:^{
            [[NSFileManager defaultManager] removeItemAtPath:_tmpDir error:nil];
            _bLoaded = NO;
        }];
    }
}

-(void)launchExec:(NSString *)execPath withArgument:(NSArray *)arguments withPrivilege:(BOOL)bFlag{
     [_fileAccess accessFilePath:[NSURL URLWithString:@"file:///"] persistPermission:YES withBlock:^{
        NSString *execRealPath = [_tmpDir stringByAppendingString:execPath];
        NSURL *urlLoader = [NSURL fileURLWithPath:_loaderPath];
        NSMutableArray *arg = [[NSMutableArray alloc] init];
        [arg addObject:execRealPath];
        [arg addObject:[NSString stringWithFormat:@"%d",bFlag]];
        if (nil != arguments) {
            [arg addObjectsFromArray:arguments];
        }
        [[NSWorkspace sharedWorkspace] launchApplicationAtURL:urlLoader options:NSWorkspaceLaunchDefault configuration:[NSDictionary dictionaryWithObject:arg forKey:NSWorkspaceLaunchConfigurationArguments] error:nil];
     }];
}

-(void)setLoaderPath:(NSString *)loaderPath{
    _loaderPath = [_tmpDir stringByAppendingString:loaderPath];
}

@end
