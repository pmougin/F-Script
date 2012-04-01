/*   SymbolTableView.m Copyright 1998,1999 Philippe Mougin.  */
/*   This software is Open Source. See the license.  */  

#import "SymbolTableView.h"
#import "Array.h"
#import <Foundation/Foundation.h>

@implementation SymbolTableView

- (BOOL)browser:(NSBrowser *)sender isColumnValid:(NSInteger)column
{
  if (column == 0) return isValid;
  else return YES;
}
  
- (void)browser:(NSBrowser *)sender createRowsForColumn:(NSInteger)column inMatrix:(NSMatrix *)matrix
{
  NSEnumerator *enumerator = [[model allDefinedSymbols] objectEnumerator];
  NSString *str;
  NSInteger i = 0;
  while (str = [enumerator nextObject]) 
  {
     NSBrowserCell *cell;
     
     [matrix addRow];
     cell = [matrix cellAtRow:i column:0];
     [cell setStringValue:str];
     [cell setLeaf:YES];
     [cell setLoaded:YES];
     i++;
  }
  isValid = YES;
}

- (void)dealloc
{
  [model autorelease];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super dealloc];
}  

- (id)initWithFrame:(NSRect)frameRect
{
  if ([super initWithFrame:frameRect])
  { 
    model = nil;
    isValid = NO;
    [self setHasHorizontalScroller:NO];
    [self setTitled:NO];
    [self setMinColumnWidth:1]; 
    //^^^^^^^ the doc advice to do this before calling setMaxVisibleColumns:
    [self setMaxVisibleColumns:1]; 
    [self setAllowsEmptySelection:YES];
    [self setTarget:self];
    [self setAction:@selector(rowSelected:)];
    
    return self;
  }
  return nil;
}

- (void)setModel:(SymbolTable *)theModel
{
  [model autorelease];
  model = [theModel retain];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:@"changed" object:model];
  [self setDelegate:self];
}  

- update:(NSNotification*)notification;
{
  isValid = NO;
  [self displayAllColumns];
  return self; 
}

// action message received as target of mySelf
- rowSelected:sender
{
  [[[model valueWrapperForIndex:[model indexOfSymbol:[[self selectedCell] stringValue]]] value] inspect];
  return self;
}  


@end