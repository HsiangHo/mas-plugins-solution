//
//  RunScript.h
//  Random
//
//  Created by blizzard on 13-5-24.
//  Copyright (c) 2013年 blizzard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunScript : NSObject
+ (BOOL) runProcess:(NSString*)scriptPath
      withArguments:(NSArray *)arguments
             output:(NSString **)output
   errorDescription:(NSString **)errorDescription
    asAdministrator:(BOOL)runAsAdmin;
+(OSStatus) RunTool:(NSString*) myToolPath;
+(OSStatus) RunTool:(NSString*) myToolPath whithArguments:(char * const *)arguments;
+ (void) Test;
+ (void) Test2;
+ (void) Test3;
@end
