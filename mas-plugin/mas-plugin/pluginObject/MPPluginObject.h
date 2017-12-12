//
//  MPPluginObject.h
//  mas-plugin
//
//  Created by Jovi on 12/11/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPPluginObject : NSObject

@property (strong,nonatomic)        NSString        *loaderPath;

-(instancetype)initWithMPPluginFile:(NSString *)path withKey:(NSString *)key;
-(BOOL)loadPlugin;
-(void)unloadPlugin;
-(void)launchExec:(NSString *)execPath withArgument:(NSArray *)arguments withPrivilege:(BOOL)bFlag;

@end
