//  FSAttributedStringInspector.m Copyright (c) 2004-2006 Philippe Mougin.
//  This software is open source. See the license.

#import "FSAttributedStringInspector.h"
#import "FSMiscTools.h"

static NSPoint topLeftPoint = {0,0}; // Used for cascading windows.

@implementation FSAttributedStringInspector

+(FSAttributedStringInspector *)attributedStringInspectorWithAttributedString:(NSAttributedString *)object
{
  return [[[self alloc] initWithAttributedString:object] autorelease];
}

-(FSAttributedStringInspector *)initWithAttributedString:(NSAttributedString *)object
{
  if ((self = [super init]))
  { 
    inspectedObject = [object retain];
    [NSBundle loadNibNamed:@"FSAttributedStringInspector.nib" owner:self];
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
  //NSLog(@"\n FSAttributedStringInspector dealloc\n");
  [inspectedObject release];
  [super dealloc];
}

- (void)updateAction:(id)sender
{
  [window setTitle:[NSString stringWithFormat:@"Inspecting %@ at address %p",descriptionForFSMessage(inspectedObject), inspectedObject]];
  [printStringView setFont:[NSFont userFixedPitchFontOfSize:userFixedPitchFontSize()]];  
  [printStringView setString:printString(inspectedObject)];
  
  [[attributedStringView textStorage] beginEditing];
  [[attributedStringView textStorage] setAttributedString:inspectedObject];
  [[attributedStringView textStorage] endEditing];
}

/////////////////// Window delegate callbacks

- (void)windowWillClose:(NSNotification *)aNotification
{
  //NSLog(@"\n WindowWillClose:\n");
  [self autorelease];
}

@end
