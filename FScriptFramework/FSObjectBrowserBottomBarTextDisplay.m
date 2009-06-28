/* FSObjectBrowserBottomBarTextDisplay.m Copyright (c) 2009 Philippe Mougin.  */
/* This software is open source. See the license.                        */ 

#import "FSObjectBrowserBottomBarTextDisplay.h"

@implementation FSObjectBrowserBottomBarTextDisplay

- (id)initWithFrame:(NSRect)frameRect
{
  self = [super initWithFrame:frameRect];
  if (self)
  {
    [self setBezelStyle:NSTexturedRoundedBezelStyle];
    [self setBordered:NO];
    [self setAlignment:NSLeftTextAlignment];
    [self setAutoresizingMask:NSViewWidthSizable | NSViewMaxYMargin];
    [self setTitle:@""];
  }
  return self;
}

- (void)setString:(NSString *)string
{
  [self setTitle:[string stringByReplacingOccurrencesOfString:@"\n" withString:@" "]];
}

- (BOOL)mouseDownCanMoveWindow
{
  return YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{
  // We want to avoid the button highlighting
  return;
}


@end
