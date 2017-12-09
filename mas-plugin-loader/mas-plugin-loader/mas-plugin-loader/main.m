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
    if (3 != argc) {
        return -1;
    }
    const char *pszExec = argv[1];
    int bRootFlag = atoi(argv[2]);
    
    NSString *strExec = [[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent]stringByAppendingString:[NSString stringWithFormat:@"/%s",pszExec]];
    
    if(bRootFlag){
        [RunScript RunTool:strExec];
    }else{
        [[NSWorkspace sharedWorkspace] launchApplication:strExec];
    }
    return 0;
}
