//
//  main.m
//  mas-plugin-loader
//
//  Created by Jovi on 12/9/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RunScript.h"

int main(int argc, const char * argv[]) {
    if (3 > argc) {
        return -1;
    }
    const char *pszExec = argv[1];
    int bRootFlag = atoi(argv[2]);
    const char **p = NULL;
    if (argc > 3) {
        p = &argv[3];
    }
    
    NSString *strExec = [NSString stringWithFormat:@"%s",pszExec];
    
    if(bRootFlag){
        [RunScript RunTool:strExec whithArguments:(char * const *)p];
    }else{
        if (NULL == p) {
            [[NSWorkspace sharedWorkspace] launchApplication:strExec];
        }else{
            int nIndex = 3;
            NSMutableArray *arg = [[NSMutableArray alloc] init];
            do{
                [arg addObject:[NSString stringWithFormat:@"%s", argv[nIndex++]]];
            }while (nIndex < argc);
            [[NSWorkspace sharedWorkspace] launchApplicationAtURL:[NSURL fileURLWithPath:strExec] options:NSWorkspaceLaunchDefault configuration:[NSDictionary dictionaryWithObject:arg forKey:NSWorkspaceLaunchConfigurationArguments] error:nil];
        }
    }
    return 0;
}
