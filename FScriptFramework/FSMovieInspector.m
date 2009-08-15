//  FSMovieInspector.m Copyright (c) 2005-2009 Philippe Mougin.
//  This software is open source. See the license.

#import "FSMovieInspector.h"
#import "FSMiscTools.h"
#import "FSInspectorUniquier.h"

static NSPoint topLeftPoint = {0,0}; // Used for cascading windows.

@implementation FSMovieInspector

+ (FSMovieInspector *)movieInspectorWithMovie:(QTMovie *)movie
{
  return [[[self alloc] initWithMovie:movie] autorelease];
} 

- (FSMovieInspector *)initWithMovie:(QTMovie *)movie
{
  if ((self = [super init]))
  {     
    FSMovieInspector *existingInspector = [FSInspectorUniquier inspectorForObject:movie];
    if (existingInspector)
    {
      [existingInspector retain]; // Because we are in a init... method
      [self release];
      [existingInspector->window makeKeyAndOrderFront:nil];
      return existingInspector;
    }
    else
    {
      inspectedObject = [movie retain];
      [NSBundle loadNibNamed:@"FSMovieInspector.nib" owner:self]; 
      [self retain]; // To balance the autorelease in windowWillClose:
      [movieView setMovie:inspectedObject];
      [movieView setEditable:YES]; // Supposed to work without that (because already configured in IB), but this is not the case. TODO: Test on final Tiger release to see if it has been fixed.
      [FSInspectorUniquier addObject:movie inspector:self];
      topLeftPoint = [window cascadeTopLeftFromPoint:topLeftPoint];
      [window makeKeyAndOrderFront:nil];
      return self;
    }  
  }
  return nil;
}

-(void) dealloc
{
  //NSLog(@"\n FSMovieInspector dealloc\n");
  [inspectedObject release];
  [super dealloc];
}

/////////////////// Window delegate callbacks

- (void)windowWillClose:(NSNotification *)aNotification
{
  //NSLog(@"\n WindowWillClose\n");
  [FSInspectorUniquier removeEntryForInspector:self];
  [self autorelease];
}

@end

