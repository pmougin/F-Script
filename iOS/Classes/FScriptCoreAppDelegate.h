//
//  FScriptCoreAppDelegate.h
//  FScript-iOS
//
//  Created by Steve White on 8/16/11.
//  Copyright 2011 Steve White. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSInterpreter.h"

@interface FScriptCoreAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *_window;
  FSInterpreter *_interpreter;
  
  UITextField *_inputTextField;
  UITextView *_outputTextView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITextField *inputTextField;
@property (nonatomic, retain) IBOutlet UITextView *outputTextView;

@end

