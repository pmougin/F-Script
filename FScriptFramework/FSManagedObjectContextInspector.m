/* FSManagedObjectContextInspector.m Copyright (c) 2005-2006 Philippe Mougin.  */
/*   This software is open source. See the license.             */  

#import "FSManagedObjectContextInspector.h"
#import <CoreData/CoreData.h>
#import "FSNSString.h"
#import "FSMiscTools.h"

/* for test

TestFS managed managedObjectContext inspectWithSystem:sys

*/

static NSPoint topLeftPoint = {0,0}; // Used for cascading windows.

@implementation FSManagedObjectContextInspector


+ (FSManagedObjectContextInspector *)managedObjectContextInspectorWithmanagedObjectContext:(id)theContext interpreter:(FSInterpreter *)theInterpreter
{
  return [[[self alloc] initWithmanagedObjectContext:theContext interpreter:theInterpreter] autorelease];
}

- (void)dealloc 
{
  //NSLog(@"FSManagedObjectContextInspector dealloc");
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [controller setContent:nil]; // Workaround for a Cocoa bindings bug
  [model release];
  [interpreter release];
  [lastFetchedEntity release];
  [fetchedObjects release];
  [super dealloc];
}

- (IBAction)changeEntity:(id)sender
{
  if ([self fetchAutomatically]) [self executeRequest];
}

- (IBAction)changeFetchAutomatically:(id)sender
{
  if ([self fetchAutomatically]) [self executeRequest]; 
}

- (void)executeRequest
{
  NSFetchRequest *request = [[[NSClassFromString(@"NSFetchRequest") alloc] init] autorelease];
  NSManagedObjectModel *objectModel = [[model persistentStoreCoordinator] managedObjectModel];
  NSEntityDescription *entity = [[objectModel entitiesByName] objectForKey:[entityList titleOfSelectedItem]];
  NSPredicate *predicate = nil;
  
  [request setEntity:entity];
  
  @try
  {
    if ([[[predicateTextView string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) 
      predicate = [NSClassFromString(@"NSPredicate") predicateWithValue:YES];
    else
      predicate = [NSClassFromString(@"NSPredicate") predicateWithFormat:[predicateTextView string]]; // TODO: handle the case where the user typed % signs in the predicate
  }
  @catch (id exception)
  {
    [messageTextView setString:[@"\n\n\n" stringByAppendingString:printString(exception)]];
    [tabView selectTabViewItemWithIdentifier:@"message"];
  }
  
  if (predicate) 
  {
    [request setPredicate:predicate];
    NSError *error;
    NSArray *requestResult;
        
    @try 
    {
      requestResult = [model executeFetchRequest:request error:&error];
    }
    @catch (id exception)
    {
      requestResult = nil;
      error = nil;
      [messageTextView setString:[@"\n\n\n" stringByAppendingString:FSErrorMessageFromException(exception)]];
      [tabView selectTabViewItemWithIdentifier:@"message"];
    }

    if (requestResult != nil)
    {
      [fetchedObjects setArray:requestResult];
      [tabView selectTabViewItemWithIdentifier:@"collection"];
      
      if ([[lastFetchedEntity name] isEqualToString:[entity name]]) 
        // We want to keep existing blocks and sorting column
        [collectionInspectorView refresh:nil]; 
      else
      {
        [collectionInspectorView setCollection:fetchedObjects interpreter:interpreter blocks:[FSCollectionInspectorView blocksForEntity:entity interpreter:interpreter] showExternals:NO];
      }
      [self setLastFetchedEntity:entity];
    }
    else if (error != nil)
    {
      [messageTextView setString:[NSString stringWithFormat:@"\n\n\n%@\n%@", [error localizedDescription], [error localizedRecoverySuggestion] ? [error localizedRecoverySuggestion] : @""]];
      [tabView selectTabViewItemWithIdentifier:@"message"];
    }
  }
}

- (IBAction)executeRequest:(id)sender
{
  [self executeRequest];
}

- (BOOL)fetchAutomatically
{
  return [fetchAutomaticallyButton state] == NSOnState; 
}

- (FSManagedObjectContextInspector *)initWithmanagedObjectContext:(id)theContext interpreter:(FSInterpreter *)theInterpreter
{
  if (self = [super init])
  {
    [self retain]; // we must stay alive while our window exist cause we are its delegate (and NSWindow doesn't retain its delegate).
 
    model = [theContext retain];
	  interpreter = [theInterpreter retain];
    lastFetchedEntity = nil;
    fetchedObjects = [[NSMutableArray alloc] init];
 
    [NSBundle loadNibNamed:@"FSManagedObjectContextInspector.nib" owner:self];
    
    [controller setContent:model];
    
    [entityList removeAllItems];
    [entityList addItemsWithTitles:[[[[model persistentStoreCoordinator] managedObjectModel] entitiesByName] allKeys]];
    
    [predicateTextView setFont:[NSFont userFixedPitchFontOfSize:[[NSUserDefaults standardUserDefaults] floatForKey:@"FScriptFontSize"]]];
    [messageTextView   setFont:[NSFont boldSystemFontOfSize:[[NSUserDefaults standardUserDefaults] floatForKey:@"FScriptFontSize"]]];

    [predicateTextView selectAll:nil];
    
    [messageTextView setAlignment:NSCenterTextAlignment];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectsDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:model];

    topLeftPoint = [[predicateTextView window] cascadeTopLeftFromPoint:topLeftPoint];
    [[predicateTextView window] makeKeyAndOrderFront:nil]; // We configure the interface in the background before putting the window on screen 
  }
  return self;
}

- (void)managedObjectsDidChange:(NSNotification *)aNotification
{
  if ([self fetchAutomatically]) [self executeRequest];
  else                           [collectionInspectorView refresh:nil];
}

- (IBAction)newInspector:(id)sender
{
  [FSManagedObjectContextInspector managedObjectContextInspectorWithmanagedObjectContext:model interpreter:interpreter]; 
}

- (void) setLastFetchedEntity:(NSEntityDescription *)entity
{
  [entity retain];
  [lastFetchedEntity release];
  lastFetchedEntity = entity;
}


/////////////////// TextView delegate callbacks

- (void)textDidChange:(NSNotification *)aNotification
{
  if ([self fetchAutomatically]) [self executeRequest];
}

/////////////////// Window delegate callbacks

- (void)windowWillClose:(NSNotification *)aNotification 
{
  [self autorelease];
} 

@end
