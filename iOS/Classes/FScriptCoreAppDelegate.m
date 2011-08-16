//
//  FScriptCoreAppDelegate.m
//  FScript-iOS
//
//  Created by Steve White on 8/16/11.
//  Copyright 2011 Steve White. All rights reserved.
//

#import "FScriptCoreAppDelegate.h"

@implementation FScriptCoreAppDelegate

@synthesize window = _window;
@synthesize inputTextField = _inputTextField;
@synthesize outputTextView = _outputTextView;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  _interpreter = [[FSInterpreter interpreter] retain];
  
  [self.window makeKeyAndVisible];
  
  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
   */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  /*
   Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
   */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}


- (void)applicationWillTerminate:(UIApplication *)application {
  /*
   Called when the application is about to terminate.
   See also applicationDidEnterBackground:.
   */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
  /*
   Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
   */
}


- (void)dealloc {
  [_window release];
  [_inputTextField release];
  [_outputTextView release];
  
  [super dealloc];
}

#pragma mark -
#pragma mark 
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
  FSInterpreterResult *result = [_interpreter execute:textField.text];
  NSString *currentText = [_outputTextView text];
  if (currentText == nil) {
    currentText = @"";
  }
  NSMutableString *outputText = [NSMutableString stringWithString:currentText];
  [outputText appendString:@"\n"];
  [outputText appendFormat:@"%@", [result result]];
  _outputTextView.text = outputText;
  return YES;
}

@end
