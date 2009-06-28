/* FSObjectBrowserArgumentPanel.m Copyright (c) 2002-2009 Philippe Mougin.  */
/*   This software is open source. See the license.  */ 

#import "FSObjectBrowserArgumentPanel.h"
#import "FScriptTextView.h"

@implementation FSObjectBrowserArgumentPanel

- (NSText *)fieldEditor:(BOOL)createFlag forObject:(id)anObject
{
  if (createFlag && !editor) editor = [[FScriptTextView alloc] initWithFrame:NSMakeRect(0,0,400,400)];
  return editor;
}

- (void) dealloc
{
  [editor release];
  [super dealloc];
}

@end
