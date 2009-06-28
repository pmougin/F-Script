//  FSCollectionInspectorTableView.m Copyright (c) 2003-2006 Philippe Mougin.
//  This software is open source. See the license.

#import "FSCollectionInspectorTableView.h"


#define BACKSPACE @"\177"

@implementation FSCollectionInspectorTableView

/*- (BOOL)respondsToSelector:(SEL)selector
{
  NSLog(NSStringFromSelector(selector));
  return [super respondsToSelector:selector];
}*/


- (void)keyDown:(NSEvent *)theEvent
{
  if ([[theEvent characters] isEqualToString:BACKSPACE] || [[theEvent characters] characterAtIndex:0] == NSDeleteFunctionKey) 
    [[self target] remove:self];
  else 
    [super keyDown:theEvent];
}

@end
