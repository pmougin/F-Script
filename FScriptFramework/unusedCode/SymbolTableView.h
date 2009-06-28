/*   SymbolTableView.h Copyright 1998,1999 Philippe Mougin.  */
/*   This software is Open Source. See the license.  */  

#import <AppKit/AppKit.h>
#import "SymbolTable.h"
#import <Foundation/Foundation.h>

@interface SymbolTableView:NSBrowser
{
  SymbolTable *model;
  BOOL isValid;
}

- (BOOL)browser:(NSBrowser *)sender isColumnValid:(NSInteger)column;
- (void)browser:(NSBrowser *)sender createRowsForColumn:(NSInteger)column inMatrix:(NSMatrix *)matrix;
- (void)dealloc;
- (id)initWithFrame:(NSRect)frameRect;
- (void)setModel:(SymbolTable *)theModel;
- update:(NSNotification*)notification;

- rowSelected:sender;

@end 