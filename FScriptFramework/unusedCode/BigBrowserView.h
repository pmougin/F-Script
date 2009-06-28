//  BigBrowserView.h Copyright 2000 Philippe Mougin.
//  This software is Open Source. See the license.

#import "build_config.h"

#ifdef BUILD_WITH_APPKIT

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@class FSInterpreter;


@interface BigBrowserView : NSView 
{
  NSArray *rootObject;
  BOOL isDisabled; // When the user is entering the arguments, we should
                   // disable the user interaction with the BigBrowserView  
  FSInterpreter *interpreter;
  NSWindow *argumentsWindow;
  NSBrowser *b1;
  NSBrowser *b2;
  BOOL twoLevelsEnabled;
}

-(id) initWithFrame:(NSRect)frameRect;
-(void) setInterpreter:(FSInterpreter *)theInterpreter;
-(void) setRootObject:(NSArray *)theRootObject;

@end

#endif
