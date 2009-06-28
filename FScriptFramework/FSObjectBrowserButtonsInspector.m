//  FSObjectBrowserButtonsInspector.m Copyright (c) 2002-2009 Philippe Mougin.
//  This software is open source. See the license.

#import "FSObjectBrowserButtonsInspector.h"
#import "FSObjectBrowserView.h"


@implementation FSObjectBrowserButtonsInspector

- (void) activate 
{
  if (!window) 
  {
    NSArray *buttons;
    
    [NSBundle loadNibNamed:@"FSObjectBrowserButtonsInspector.nib" owner:self];
    buttons = [FSObjectBrowserView customButtons];
    
    [t1  setTarget:[buttons objectAtIndex: 0]]; [t1  setAction:@selector(takeNameFrom:)]; [t1  setStringValue:[[buttons objectAtIndex: 0] name]];
    [t2  setTarget:[buttons objectAtIndex: 1]]; [t2  setAction:@selector(takeNameFrom:)]; [t2  setStringValue:[[buttons objectAtIndex: 1] name]];
    [t3  setTarget:[buttons objectAtIndex: 2]]; [t3  setAction:@selector(takeNameFrom:)]; [t3  setStringValue:[[buttons objectAtIndex: 2] name]];
    [t4  setTarget:[buttons objectAtIndex: 3]]; [t4  setAction:@selector(takeNameFrom:)]; [t4  setStringValue:[[buttons objectAtIndex: 3] name]];
    [t5  setTarget:[buttons objectAtIndex: 4]]; [t5  setAction:@selector(takeNameFrom:)]; [t5  setStringValue:[[buttons objectAtIndex: 4] name]];
    [t6  setTarget:[buttons objectAtIndex: 5]]; [t6  setAction:@selector(takeNameFrom:)]; [t6  setStringValue:[[buttons objectAtIndex: 5] name]];
    [t7  setTarget:[buttons objectAtIndex: 6]]; [t7  setAction:@selector(takeNameFrom:)]; [t7  setStringValue:[[buttons objectAtIndex: 6] name]];
    [t8  setTarget:[buttons objectAtIndex: 7]]; [t8  setAction:@selector(takeNameFrom:)]; [t8  setStringValue:[[buttons objectAtIndex: 7] name]];
    [t9  setTarget:[buttons objectAtIndex: 8]]; [t9  setAction:@selector(takeNameFrom:)]; [t9  setStringValue:[[buttons objectAtIndex: 8] name]];
    [t10 setTarget:[buttons objectAtIndex: 9]]; [t10 setAction:@selector(takeNameFrom:)]; [t10 setStringValue:[[buttons objectAtIndex: 9] name]];

    [b1  setTarget:[buttons objectAtIndex: 0]]; [b1  setAction:@selector(inspectBlock:)];
    [b2  setTarget:[buttons objectAtIndex: 1]]; [b2  setAction:@selector(inspectBlock:)];
    [b3  setTarget:[buttons objectAtIndex: 2]]; [b3  setAction:@selector(inspectBlock:)];
    [b4  setTarget:[buttons objectAtIndex: 3]]; [b4  setAction:@selector(inspectBlock:)];
    [b5  setTarget:[buttons objectAtIndex: 4]]; [b5  setAction:@selector(inspectBlock:)];
    [b6  setTarget:[buttons objectAtIndex: 5]]; [b6  setAction:@selector(inspectBlock:)];
    [b7  setTarget:[buttons objectAtIndex: 6]]; [b7  setAction:@selector(inspectBlock:)];
    [b8  setTarget:[buttons objectAtIndex: 7]]; [b8  setAction:@selector(inspectBlock:)];
    [b9  setTarget:[buttons objectAtIndex: 8]]; [b9  setAction:@selector(inspectBlock:)];
    [b10 setTarget:[buttons objectAtIndex: 9]]; [b10 setAction:@selector(inspectBlock:)];

  } 
  [window makeKeyAndOrderFront:self]; 
}

- (void)windowWillClose:(NSNotification *)aNotification
{
  [FSObjectBrowserView saveCustomButtonsSettings];
}

@end
