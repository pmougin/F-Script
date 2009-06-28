//  FSObjectBrowserMatrix.m Copyright (c) 2002-2009 Philippe Mougin.
//  This software is open source. See the license.

#import <AppKit/AppKit.h>
#import "FSObjectBrowserMatrix.h"


@implementation FSObjectBrowserMatrix

/*- (id)initWithFrame:(NSRect)frameRect mode:(int)aMode cellClass:(Class)classId numberOfRows:(int)numRows numberOfColumns:(int)numColumns
{
  NSLog(@"initWithFrameblabla:");
  [super initWithFrame:frameRect mode:NSRadioModeMatrix cellClass:classId numberOfRows:numRows numberOfColumns:numColumns];
  [self setMode:NSRadioModeMatrix];
  return self;
  
}

- (id)initWithFrame:(NSRect)frameRect
{
  NSLog(@"initWithFrame:");
  [super initWithFrame:frameRect];
  [self setMode:NSRadioModeMatrix];
  return self;
}  */

/*- (id)initWithFrame:(NSRect)frameRect mode:(int)aMode prototype:(NSCell *)aCell numberOfRows:(int)numRows numberOfColumns:(int)numColumns
{
  NSLog(@"initWithFrameblabla2:");
  [super initWithFrame:frameRect mode:NSListModeMatrix prototype:aCell numberOfRows:numRows numberOfColumns:numColumns];
  [self setMode:NSListModeMatrix];
  return self;

}

- (void)mouseMoved:(NSEvent *)theEvent
{
  NSLog(@"moved");
}

- (void)mouseDragged:(NSEvent *)theEvent
{
  NSSize dragOffset = NSMakeSize(0.0, 0.0);
  NSPasteboard *pboard;

  NSLog(@"dragged");

  pboard = [NSPasteboard pasteboardWithName:NSDragPboard];
  [pboard declareTypes:[NSArray arrayWithObject:NSTIFFPboardType] owner:self];
  [pboard setData:[[[NSBundle mainBundle] loadImageNamed:@"build.tiff"] TIFFRepresentation] forType:NSTIFFPboardType];

  [self dragImage:[[NSBundle mainBundle] loadImageNamed:@"build.tiff"] at:[NSEvent mouseLocation] offset:dragOffset event:theEvent  pasteboard:pboard source:self slideBack:YES];

  [super mouseDragged:(NSEvent *)theEvent];
}

- (void)setMode:(NSMatrixMode)aMode
{
  [super setMode:NSListModeMatrix];
}

- (NSMatrixMode)mode
{
  return NSListModeMatrix;
}

- (void)mouseDown:(NSEvent *)theEvent
{
  //NSSize dragOffset = NSMakeSize(0.0, 0.0);
  //NSPasteboard *pboard;

  NSLog(@"mouseDown:");
  NSLog(@"mode=%d", [self mode]);

  //pboard = [NSPasteboard pasteboardWithName:NSDragPboard];
  //[pboard declareTypes:[NSArray arrayWithObject:NSTIFFPboardType] owner:self];
  //[pboard setData:[[[NSBundle mainBundle] loadImageNamed:@"build.tiff"] TIFFRepresentation] forType:NSTIFFPboardType];

  //[self dragImage:[[NSBundle mainBundle] loadImageNamed:@"build.tiff"] at:[NSEvent mouseLocation] offset:dragOffset event:theEvent  pasteboard:pboard source:self slideBack:YES];

  [super mouseDown:(NSEvent *)theEvent];
}

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal
{
  if (isLocal) return NSDragOperationEvery;
  else return NSDragOperationCopy;
}*/

+ allocWithZone:(NSZone *)zone
{
  id r = [super allocWithZone:zone];
  //NSLog([NSString stringWithFormat:@"FSObjectBrowserMatrix %p allocWithZone:", r]);
  return r;
}

- retain
{
  //NSLog([NSString stringWithFormat:@"FSObjectBrowserMatrix %p retain", self]);
  return [super retain];
}

- (void)release
{
  //NSLog([NSString stringWithFormat:@"FSObjectBrowserMatrix %p release", self]);
  [super release];
}

- (void) dealloc
{
  //NSLog([NSString stringWithFormat:@"FSObjectBrowserMatrix %p dealloc", self]);
  [super dealloc];
}

@end
