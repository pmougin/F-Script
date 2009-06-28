/* FSCollectionInspectorView.h Copyright (c) 1998-2006 Philippe Mougin.  */
/*   This software is open source. See the license.  */  
 
#import <Cocoa/Cocoa.h>

@class FSInterpreter;

@interface FSCollectionInspectorView : NSView 
{
  IBOutlet NSView *contentView;
  IBOutlet NSTableView *tableView;
  IBOutlet NSButton *modifyButton;
  IBOutlet NSButton *removeButton;
  IBOutlet NSButton *sortButton;
  IBOutlet NSButton *inspectButton;
  IBOutlet NSButton *narrowButton;
  IBOutlet NSButton *browseButton;
  IBOutlet id searchField;
  
  id model;
  NSArray *sortedModelArray;
  NSArray *sortedExternals;
  NSArray *filteredSortedModelArray;
  NSArray *filteredSortedExternals;
  NSTableColumn *sortColumn;
  FSInterpreter *interpreter;
  NSString *filterString; 
}

+ (NSArray *)blocksForEntity:(NSEntityDescription *)entity interpreter:(FSInterpreter *)interpreter;

- (id) initWithFrame:(NSRect)frame;

- (void) setCollection:(id)theCollection interpreter:(FSInterpreter *)theInterpreter blocks:(NSArray *)blocks showExternals:(BOOL)showExternals;
// You can pass nil for blocks. In this case the view will use a default block set. 

- (IBAction)add:(id)sender;
- (IBAction)browse:(id)sender;
- (IBAction)filter:(id)sender;
- (IBAction)inspect:(id)sender;
- (IBAction)modify:(id)sender;
- (IBAction)narrow:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)sort:(id)sender;

@end
