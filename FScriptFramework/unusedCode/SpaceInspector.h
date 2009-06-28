/* SpaceInspector.h Copyright 1998,1999 Philippe Mougin.  */
/*   This software is Open Source. See the license.  */  

#import "Space.h"
#import "SymbolTableView.h"

@class NSWindow;

@interface SpaceInspector:NSObject
{
  Space *inspectedObj;
  NSWindow *window;            // outlet
  SymbolTableView *localView;  // outlet
}

//////// USER METHODS

+ spaceInspectorWithSpace:(Space*)space;

- (void) activate;

///////// SYSTEM METHOD

- (void) dealloc;
- initWithSpace:(Space*)space;

- (void)windowWillClose:(NSNotification *)aNotification;

@end
