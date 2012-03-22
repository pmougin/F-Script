/* FSCollectionInspector.h Copyright (c) 1998-2009 Philippe Mougin. */
/* This software is open source. See the license.              */

#import <Cocoa/Cocoa.h>

@class NTableView;
@class NSTableColumn;
@class FSInterpreter;
@class FSCollectionInspectorView;
 
@interface FSCollectionInspector : NSObject
{
  IBOutlet FSCollectionInspectorView *collectionInspectorView;
}

// You can pass nil for blocks. In this case the inspector will use a default block set. 

+ (FSCollectionInspector *)collectionInspectorWithCollection:(id)theCollection interpreter:(FSInterpreter *)theInterpreter blocks:(NSArray *)blocks;
+ (FSCollectionInspector *)collectionInspectorWithCollection:(id)theCollection interpreter:(FSInterpreter *)theInterpreter blocks:(NSArray *)blocks showExternals:(BOOL)showExternals;

- (FSCollectionInspector *)initWithCollection:(id)theCollection interpreter:(FSInterpreter *)theInterpreter blocks:(NSArray *)blocks showExternals:(BOOL)showExternals;

@end
