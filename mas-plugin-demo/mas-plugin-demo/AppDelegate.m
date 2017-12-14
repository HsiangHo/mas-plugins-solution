//
//  AppDelegate.m
//  mas-plugin-demo
//
//  Created by Jovi on 12/12/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "AppDelegate.h"
#import <MasPluginLib/MasPluginLib.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSString *pluginPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/Contents/Resources/1.xy"];
    MPPluginObject *plugin = [[MPPluginObject alloc] initWithMPPluginFile:pluginPath withKey:@"123456"];
    [plugin loadPlugin];
    [plugin setLoaderPath:@"/untitled folder 2/mas-plugin-loader.app"];
    [plugin launchExec:@"/untitled folder 2/plugin.app/Contents/MacOS/plugin" withArgument:@[@"worinima",@"fuckyou",@"hahaha"] withPrivilege:NO];
    sleep(10);
    [plugin unloadPlugin];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
