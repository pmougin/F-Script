/* FSManagedObjectContextInspector.h Copyright (c) 2005-2009 Philippe Mougin.  */
/*   This software is open source. See the license.             */  

#import <Cocoa/Cocoa.h>
#import "FSInterpreter.h"
#import "FSCollectionInspectorView.h"

@class NSManagedObjectContext;

@interface FSManagedObjectContextInspector : NSObject 
{
  NSManagedObjectContext *model;
  FSInterpreter *interpreter;
  NSEntityDescription *lastFetchedEntity; 
  NSMutableArray *fetchedObjects;
  
  IBOutlet NSTabView *tabView;
  IBOutlet FSCollectionInspectorView *collectionInspectorView;
  IBOutlet NSTextView *messageTextView;
  IBOutlet NSTextView *predicateTextView;
  IBOutlet NSPopUpButton *entityList;
  IBOutlet NSButton *fetchAutomaticallyButton;
  IBOutlet NSObjectController *controller; 
}

+ (FSManagedObjectContextInspector *)managedObjectContextInspectorWithmanagedObjectContext:(id)theContext interpreter:(FSInterpreter *)theInterpreter;

- (IBAction)changeEntity:(id)sender;

- (IBAction)changeFetchAutomatically:(id)sender;

- (void)executeRequest;

- (IBAction)executeRequest:(id)sender;

- (BOOL)fetchAutomatically;

- (FSManagedObjectContextInspector *)initWithmanagedObjectContext:(id)theContext interpreter:(FSInterpreter *)theInterpreter;

- (IBAction)newInspector:(id)sender; 

- (void) setLastFetchedEntity:(NSEntityDescription *)entity;

@end
