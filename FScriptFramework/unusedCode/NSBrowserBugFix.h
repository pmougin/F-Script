/* NSBrowserBugFix.h Copyright (c) 2000 Philippe Mougin. */ 
/* This software is open source. See the license. */

// Provide a replacement for the buggy setEnabled method of NSBrowser

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface NSBrowser(NSBrowserBugFix) 

- (void) replacementForBuggySetEnabled:(BOOL)shouldEnable;

@end
