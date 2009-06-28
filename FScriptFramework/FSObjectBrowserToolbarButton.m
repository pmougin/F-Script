//  FSObjectBrowserToolbarButton.m Copyright (c) 2002-2009 Philippe Mougin.
//  This software is open source. See the license.

#import "FSObjectBrowserToolbarButton.h"
#import "FSObjectBrowserView.h"
#import "FSBlock.h"
#import "FSNSString.h"

@implementation FSObjectBrowserToolbarButton

- (FSBlock *)block
{
  //[block inspect];
  /*if (block == nil)
  {
    [self configure:self];
    return nil;
  }
  else */
  
  return block;
}

- (void) configure:(id)sender
{
  [block inspect];
}

- (id)copyWithZone:(NSZone *)zone
{
  FSObjectBrowserToolbarButton *r = [[[self class] alloc] initWithFrame:[self frame]];
  
  [r setSegmentCount:1];
  [r setSegmentStyle:NSSegmentStyleTexturedSquare];
  //[r setSegmentStyle:NSSegmentStyleCapsule];
  [r setWidth:80 forSegment:0];
  [[r cell] setTrackingMode:NSSegmentSwitchTrackingMomentary]; 

  [r setAction:[self action]];
  [r setTarget:[self target]];
  [r setBlock:block];
  [r setIdentifier:identifier];
  [r setToolbarItem:toolbarItem];
  [r setName:[self name]]; 
  return r; 
}

- (void) dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [block release];
  [identifier release];
  [super dealloc];
}

- (id) initWithFrame:(NSRect)frameRect
{
  self = [super initWithFrame:frameRect];
  if (self)
  {
    [self setSegmentCount:1];
	[self setSegmentStyle:NSSegmentStyleTexturedSquare];
	//[self setSegmentStyle:NSSegmentStyleCapsule];
	[self setWidth:80 forSegment:0];
	[[self cell] setTrackingMode:NSSegmentSwitchTrackingMomentary]; 
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:@"FSObjectBrowserToolBarButtonUpdated" object:nil];
  }
  return self;
}

- (NSString *) identifier
{
  return identifier;
}

- (void) inspectBlock:(id)sender
{
  [[self block] inspect];
}

- (NSString *) name
{
  return [self labelForSegment:0];
}

- (void) setBlock:(FSBlock *)theBlock
{
  [theBlock retain];
  [block release];
  block = theBlock;
}

- (void) setIdentifier:(NSString *)theIdentifier
{
  [theIdentifier retain];
  [identifier release];
  identifier = theIdentifier;
}

- (void)setName:(NSString *)name
{
  [self setLabel:name forSegment:0];
  
  [[toolbarItem menuFormRepresentation] setTitle:name];  
  // Note that the toolbar item will not notice this change in the menu promptly.
  // But the messages below (setLabel:) will, as a side effect, make the toolbar item update itself and notice this change.
  
  [toolbarItem setLabel:name];
  [toolbarItem setPaletteLabel:name];
  
  // not working 
  //[toolbarItem setMinSize:[[self cell] cellSize]];
  [toolbarItem setMinSize:[[self cell] cellSize].width < 85 ? NSMakeSize(85, [self frame].size.height) : [[self cell] cellSize]];
  [toolbarItem setMaxSize:([self frame].size.width < 85 ? NSMakeSize(85, [self frame].size.height) : [[self cell] cellSize])];
  
  [[toolbarItem toolbar] validateVisibleItems];
     
  //--------- force the toolBarItem to redisplay itself
  /*[self retain];
  [toolbarItem setView:nil];
  [toolbarItem setView:self];
  [self release];*/
  //---------
}

- (void)setNameAndNotify:(NSString *)name
{
  [self setName:name];
  [FSObjectBrowserView saveCustomButtonsSettings];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"FSObjectBrowserToolBarButtonUpdated" object:self];
}

- (void) setToolbarItem:(NSToolbarItem *)item
{
  toolbarItem = item; // No retain because it would create a cycle. 
}
 
- (void)selectedFromMenuItem:(NSMenuItem *)menuItem
{
  [self performClick:self];
}

- (void) takeNameFrom:(id)sender
{
  [self setNameAndNotify:[sender stringValue]];
}

-(void)update:(NSNotification *)notification
{
  FSObjectBrowserToolbarButton *master = [notification object];
  
  if ([[master identifier] isEqualToString:identifier] && master != self)
  {  
    [self setName:[master name]];
  }   
}

/*- (void)textDidEndEditing:(NSNotification *)aNotification
{
  NSString *title;
  NSMenuItem *menuFormRep;
  NSText *textObject = [aNotification object];
  
  title = [[textObject string] copy];
  [[self cell] endEditing:textObject];
  [textObject setString:@""];
  [self setTitle:title];
  [BigBrowserView setTitle:title forCustomButtonWithIdentifier:identifier];
  [toolbarItem setLabel:title];
  [toolbarItem setPaletteLabel:title];
  
  menuFormRep = [[[NSMenuItem alloc] init] autorelease];
  [menuFormRep setTitle: title];
  [menuFormRep setAction:@selector(selectedFromMenuItem:)];
  [menuFormRep setTarget:self];
  [toolbarItem setMenuFormRepresentation:menuFormRep];
  
  [title release];
  [[self cell] setEditable:NO];
}*/

@end
