//
//  main.m
//  mas-plugin-loader
//
//  Created by Jovi on 12/9/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RunScript.h"

#define MAX_ARGC        256

int main(int argc, const char * argv[]) {
    NSPasteboard *pboard = [NSPasteboard pasteboardWithName:@"mas-plugin-pasteBoard"];
    NSArray* array = [pboard propertyListForType:NSStringPboardType];
    NSUInteger nCount = [array count];
    if(nil == array || 2 > nCount){
        [pboard clearContents];
        return 0;
    }
    
    NSString *strExec = [array objectAtIndex:0];
    int bRootFlag = [[array objectAtIndex:1] intValue];
    NSMutableArray *arg = [[NSMutableArray alloc] init];
    
    int nIndex = 0;
    const char **p = NULL;
    const char *execArgv[MAX_ARGC] = { 0 };
    while (nIndex < nCount - 2) {
        execArgv[nIndex] = [((NSString *)[array objectAtIndex:2 + nIndex]) UTF8String];
        [arg addObject:[array objectAtIndex:2 + nIndex]];
        ++nIndex;
    }
    p = &execArgv[0];
    
    if(bRootFlag){
        [RunScript RunTool:strExec whithArguments:(char * const *)p];
    }else{
        if (NULL == *p) {
            [[NSWorkspace sharedWorkspace] launchApplication:strExec];
        }else{
            [[NSWorkspace sharedWorkspace] launchApplicationAtURL:[NSURL fileURLWithPath:strExec] options:NSWorkspaceLaunchDefault configuration:[NSDictionary dictionaryWithObject:arg forKey:NSWorkspaceLaunchConfigurationArguments] error:nil];
        }
    }
    [pboard clearContents];
    return 0;
}
