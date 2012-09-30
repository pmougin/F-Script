/*   SpaceInspector.m Copyright 1998,1999 Philippe Mougin.  */
/*   This software is Open Source. See the license.  */  

#import "SpaceInspector.h"
#import "SymbolTableView.h"
#import <assert.h>
#import "String.h"
#import <AppKit/AppKit.h>

@implementation SpaceInspector

//////// USER METHODS

+ spaceInspectorWithSpace:(Space*)space
{
  return [[[self alloc] initWithSpace:space] autorelease];
}

- (void) activate
{ 
  if (!window)
  {    
    [NSBundle loadNibNamed:@"spaceInspector.nib" owner:self];
    [localView setModel:[inspectedObj localSymbolTable]];
    [self retain]; // We are the window delegate and thus we must stay alaive at least as long as the window. But the delegate is not retained, so we do put a retain here // TODO_TAG
  }    
  [window makeKeyAndOrderFront:self];
}

//////////////  OTHER METHODS

- (void)dealloc
{
  //printf("\n SpaceInspector dealloc\n");
  assert(window == nil);
  [inspectedObj release];
  [super dealloc];
}

- initWithSpace:(Space*)space
{
  assert([space isKindOfClass:[Space class]]);
  if ([super init])
  {
    inspectedObj = [space retain];
    window = nil;
    [self activate];
    
    return self;
  }
  return nil;
}  

- (void)windowWillClose:(NSNotification *)aNotification
{
  [window setDelegate:nil];
  window = nil;
  //[self release];
}

@end
