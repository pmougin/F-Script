//  FSGenericObjectInspector.m Copyright (c) 2001-2009 Philippe Mougin.
//  This software is open source. See the license.

#import "FSGenericObjectInspector.h"
#import "FSMiscTools.h"

static NSPoint topLeftPoint = {0,0}; // Used for cascading windows.

@implementation FSGenericObjectInspector

+(FSGenericObjectInspector *)genericObjectInspectorWithObject:(id)object
{
  return [[[self alloc] initWithObject:object] autorelease]; 
}
 
-(FSGenericObjectInspector *)initWithObject:(id)object 
{
  if ((self = [super init]))
  {
    inspectedObject = [object retain];
    [NSBundle loadNibNamed:@"genObjInspector.nib" owner:self];
    [self retain]; // To balance the autorelease in windowWillClose:
    [self updateAction:nil];
    topLeftPoint = [window cascadeTopLeftFromPoint:topLeftPoint];
    [window makeKeyAndOrderFront:nil];
    return self;
  }
  return nil;
}

-(void) dealloc
{
  //NSLog(@"\n FSGenericObjectInspector dealloc\n");
  [inspectedObject release];
  [super dealloc];
}

- (void)updateAction:(id)sender
{
  [window setTitle:[NSString stringWithFormat:@"Inspecting %@ at address %p",descriptionForFSMessage(inspectedObject), inspectedObject]];
  [printStringView setFont:[NSFont userFixedPitchFontOfSize:userFixedPitchFontSize()]];
  [printStringView setString:printString(inspectedObject)];
}

/////////////////// Window delegate callbacks

- (void)windowWillClose:(NSNotification *)aNotification
{
  [self autorelease];
} 


@end
