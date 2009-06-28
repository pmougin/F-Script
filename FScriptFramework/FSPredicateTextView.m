/*   FSPredicateTextView.m Copyright (c) 2005-2006 Philippe Mougin.  */
/*   This software is open source. See the license.   */

#import "FSPredicateTextView.h"

static NSAttributedString *predicatePrompt;

@implementation FSPredicateTextView

+(void)initialize 
{ 
  static BOOL initialized = NO; 
  if (!initialized) 
  { 
    NSColor *txtColor = [NSColor grayColor];
    NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:txtColor, NSForegroundColorAttributeName, nil];
    predicatePrompt = [[NSAttributedString alloc] initWithString:@" <Enter a predicate here>" attributes:txtDict];
  } 
} 

- (BOOL)becomeFirstResponder
{
  [self setNeedsDisplay:YES];
  return [super becomeFirstResponder];
}

- (void)drawRect:(NSRect)rect 
{
  [super drawRect:rect];
  if ([[self string] isEqualToString:@""] && self != [[self window] firstResponder])
    [predicatePrompt drawAtPoint:NSMakePoint(0,0)];
}

- (BOOL)resignFirstResponder
{
  [self setNeedsDisplay:YES];
  return [super resignFirstResponder];
}


@end
