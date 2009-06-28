/* NSBrowserBugFix.m Copyright (c) 2000 Philippe Mougin. */ 
/* This software is open source. See the license. */

#import "NSBrowserBugFix.h"

@implementation NSBrowser(NSBrowserBugFix)

- (void) replacementForBuggySetEnabled:(BOOL)shouldEnable
{
  NSInteger i,nb;
  for (i = 0, nb = [self lastColumn]+1; i < nb; i++) [[self matrixInColumn:i] setEnabled:shouldEnable];
  [self display];
}

@end
