/* FSObjectBrowserArgumentPanel.h Copyright (c) 2002-200ç Philippe Mougin.  */
/*   This software is open source. See the license.  */ 

#import <AppKit/AppKit.h>

@class FScriptTextView;

@interface FSObjectBrowserArgumentPanel : NSPanel
{
  FScriptTextView *editor;
}

- (void) dealloc;
- (NSText *) fieldEditor:(BOOL)createFlag forObject:(id)anObject;

@end
