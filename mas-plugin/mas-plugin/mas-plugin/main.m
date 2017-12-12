//
//  main.m
//  mas-plugin
//
//  Created by Jovi on 12/10/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MasPluginLib/MasPluginLib.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        [MPPackageWrapper packPlugin:@"/Users/jovi/Desktop/untitled folder 2" key:@"123456" outPath:@"/Users/jovi/Desktop/1.xy"];
        MPPluginObject *plugin = [[MPPluginObject alloc] initWithMPPluginFile:@"/Users/jovi/Desktop/1.xy" withKey:@"123456"];
        [plugin loadPlugin];
        [plugin setLoaderPath:@"/untitled folder 2/mas-plugin-loader.app"];
        [plugin launchExec:@"/untitled folder 2/plugin.app/Contents/MacOS/plugin" withArgument:@[@"1"] withPrivilege:YES];
        sleep(10);
        [plugin unloadPlugin];
        
        NSLog(@"Hello, World!");
    }
    return 0;
}
