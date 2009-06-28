/*   FSObjectBrowserToolbarItem.m Copyright (c) 2002-2009 Philippe Mougin.  */
/*   This software is open source. See the license.               */

#import "FSObjectBrowserToolbarItem.h"
#import "FSObjectBrowserToolbarButton.h"
#import "FSBlock.h"
#import "FSObjectBrowserView.h"
 
@implementation FSObjectBrowserToolbarItem

- (void)validate
{
  NSInteger argumentCount = 0; // intitialization of argumentCount in order to avoid a warning
  NSString *identifier = [self itemIdentifier];
  
  [self setEnabled:YES];
  
  if ([[self view] isKindOfClass:[FSObjectBrowserToolbarButton class]])
  {
    @try
    {
      argumentCount = [[(FSObjectBrowserToolbarButton *)[self view] block] argumentCount];
    }
    @catch (id exception)
    {
      argumentCount = 0;
    }
  }
  
  if (   [identifier isEqualToString:@"Name"] 
      || [identifier isEqualToString:@"Self"] 
      || [identifier isEqualToString:@"Inspect"]
      || [identifier isEqualToString:@"Browse"]
      || ([[self view] isKindOfClass:[FSObjectBrowserToolbarButton class]] && argumentCount != 0))
  {
    if ([[(NSButton *)[self view] target] selectedObject] == nil)
      [self setEnabled:NO];
  }  
}

@end
