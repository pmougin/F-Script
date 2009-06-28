//  FSObjectBrowser.h Copyright (c) 2001-2009 Philippe Mougin.
//  This software is open source. See the license.

#import <AppKit/AppKit.h>

@class FSInterpreter;

@interface FSObjectBrowser : NSWindow 
{
}

+ (FSObjectBrowser *)objectBrowserWithRootObject:(id)object interpreter:(FSInterpreter *)interpreter;
- (void) browseWorkspace;
- (void)dealloc;
- (FSObjectBrowser *)initWithRootObject:(id)object interpreter:(FSInterpreter *)interpreter;
- (BOOL)worksWhenModal;

@end
