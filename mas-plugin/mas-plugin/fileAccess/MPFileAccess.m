//
//  MPFileAccess.m
//  mas-plugin
//
//  Created by Jovi on 12/13/17.
//  Copyright © 2017 Jovi. All rights reserved.
//

#import "MPFileAccess.h"
#import <Cocoa/Cocoa.h>

#define CFBundleDisplayName         @"CFBundleDisplayName"
#define CFBundleName                @"CFBundleName"
#define URL_2_BOOKMARKKEY(url)      [NSString stringWithFormat:@"bd_%1$@", [url absoluteString]]

@implementation MPFileAccess{
    NSOpenPanel             *_panel;
    NSString                *_accessTitle;
    NSString                *_accessMessage;
    NSString                *_prompt;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self __initializeAppSandboxFileAccess];
    }
    return self;
}

-(void)__initializeAppSandboxFileAccess{
    NSString *applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:CFBundleDisplayName];
    if (!applicationName) {
        applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:CFBundleName];
    }
    _accessTitle = NSLocalizedString(@"Allow Access", @"Sandbox Access panel title.");
    NSString *formatString = NSLocalizedString(@"%@ needs to access this path to continue. Click Allow to continue.", @"Sandbox Access panel message.");
    _accessMessage = [NSString stringWithFormat:formatString, applicationName];
    _prompt = NSLocalizedString(@"Allow", @"Sandbox Access panel prompt.");
}

+(BOOL)persistAccessFilePath:(NSURL *)path withBlock:(MPFileAccessBlock)block{
    NSURL *allowedURL = nil;
    NSData *bookmarkData = [[NSUserDefaults standardUserDefaults] objectForKey:URL_2_BOOKMARKKEY(path)];
    BOOL bookmarkDataIsStale;
    allowedURL = [NSURL URLByResolvingBookmarkData:bookmarkData options:NSURLBookmarkResolutionWithSecurityScope|NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:&bookmarkDataIsStale error:NULL];
    if(nil != allowedURL){
        @try {
            [allowedURL startAccessingSecurityScopedResource];
            block();
        }@finally {
            [allowedURL stopAccessingSecurityScopedResource];
        }
    }
    return nil != allowedURL;
}

-(BOOL)accessFilePath:(NSURL *)path persistPermission:(BOOL)persist withBlock:(MPFileAccessBlock)block{
    __block NSURL *allowedURL = nil;
    if(nil == path){
        return NO;
    }
    if (0 == access([[path path] UTF8String], R_OK ) || 0 == access([[path path] UTF8String], R_OK )) {
        block();
        return YES;
    }
    do{
        if(persist){
            //gain scope
            if ([MPFileAccess persistAccessFilePath:path withBlock:block]) {
                break;
            }
        }else{
            //clear scope
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:URL_2_BOOKMARKKEY(path)];
        }
        
        //gain access
        dispatch_block_t openPanel_block = ^{
            _panel = [NSOpenPanel openPanel];
            [_panel setMessage:_accessMessage];
            [_panel setCanCreateDirectories:NO];
            [_panel setCanChooseFiles:YES];
            [_panel setCanChooseDirectories:YES];
            [_panel setAllowsMultipleSelection:NO];
            [_panel setShowsHiddenFiles:NO];
            [_panel setExtensionHidden:NO];
            [_panel setDirectoryURL:path];
            [_panel setPrompt:_prompt];
            [_panel setTitle:_accessTitle];
            NSInteger openPanelButtonPressed = [_panel runModal];
            if(openPanelButtonPressed == NSFileHandlingPanelOKButton) {
                allowedURL = [_panel URL];
                if (persist) {
                    NSError *error=nil;
                    NSData * newBookMark = [allowedURL bookmarkDataWithOptions: NSURLBookmarkCreationWithSecurityScope
                                                includingResourceValuesForKeys: nil
                                                                 relativeToURL: nil
                                                                         error: &error];
                    [[NSUserDefaults standardUserDefaults] setObject:newBookMark forKey:URL_2_BOOKMARKKEY(allowedURL)];
                }
                block();
            }
        };
        if([NSThread isMainThread]){
            openPanel_block();
        }else{
            dispatch_sync(dispatch_get_main_queue(), openPanel_block);
        }
    }while (false);
    
    return nil != allowedURL;
}

@end
