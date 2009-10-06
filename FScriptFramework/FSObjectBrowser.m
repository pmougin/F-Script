//  FSObjectBrowser.m Copyright (c) 2001-2009 Philippe Mougin.
//  This software is open source. See the license.

#import "build_config.h" 
#import "FSObjectBrowser.h"
#import "FSObjectBrowserView.h"
#import "FSObjectBrowserToolbar.h"
#import "FSObjectBrowserButtonsInspector.h"
#import "FSMiscTools.h"
     
static FSObjectBrowserButtonsInspector *buttonsInspector;
static NSPoint topLeftPoint = {0,0}; // Used for cascading windows.

@implementation FSObjectBrowser 

+(FSObjectBrowser *)objectBrowserWithRootObject:(id)object interpreter:(FSInterpreter *)interpreter
{
  return [[self alloc] initWithRootObject:object interpreter:interpreter]; // NO autorelease. The window will be released when closed.
}
 
- (void) browseWorkspace { [[self contentView] browseWorkspace]; } 
 
-(void) dealloc
{
  //NSLog(@"\n FSObjectBrowser dealloc\n");
  [super dealloc];
} 

- (NSSearchField *)visibleSearchField
{
  NSArray *visibleItems = [[self toolbar] visibleItems];
  for (NSUInteger i = 0, count = [visibleItems count]; i < count; i++)
  {
    if ([[[visibleItems objectAtIndex:i] itemIdentifier] isEqualToString:@"Filter"])
    {
      return (NSSearchField *)[((NSToolbarItem *)[visibleItems objectAtIndex:i]) view];
    }
  }
  return nil;  
}
 
-(FSObjectBrowser *)initWithRootObject:(id)object interpreter:(FSInterpreter *)interpreter
{
  FSObjectBrowserView *bbv;
  
  [super initWithContentRect:NSMakeRect(100,100,830,400) styleMask:NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask /*| NSTexturedBackgroundWindowMask*/ backing:NSBackingStoreBuffered defer:NO];
  
  [self setMinSize:NSMakeSize(130,130)]; // FSObjectBrowserView has weird behavior if the window becomes too tiny
    
  bbv = [[FSObjectBrowserView alloc] initWithFrame:[[self contentView] bounds]];
  [bbv setRootObject:object];
  [bbv setInterpreter:interpreter];
  [bbv setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
  [self setContentView:bbv];
  // jg added from here
  if ([bbv respondsToSelector:@selector(setupToolbarWithWindow:)]) {
    if ([bbv doSetupToolbar])
      [bbv setupToolbarWithWindow:self]; // defined in FSObjectBrowserToolBar.m
  }
  // jg added to here
  [bbv release];
  
  NSSearchField *searchField = [self visibleSearchField]; 
  if (searchField) [self setInitialFirstResponder:searchField];  
  
  //[self makeFirstResponder:bbv];  // If I don't do that, the mouse moved events are not sent to the bbv.
  
  [self setContentBorderThickness:FSObjectBrowserBottomBarHeight+1 forEdge:NSMinYEdge]; // Adding 1 here to FSObjectBrowserBottomBarHeight produces a prettier visual effect

  [self setAcceptsMouseMovedEvents:YES];
  [self setTitle:@"F-Script Object Browser"];
  topLeftPoint = [self cascadeTopLeftFromPoint:topLeftPoint];
  //[self makeKeyAndOrderFront:nil];
  return self;
}

- (void)sendEvent:(NSEvent *)theEvent
{
  // Goal: route most key events directly to the searchfield
 
  if ([theEvent type] == NSKeyDown)
  {
    unichar character = [[theEvent characters] characterAtIndex:0];
    if (character != NSLeftArrowFunctionKey && character != NSRightArrowFunctionKey && character != NSUpArrowFunctionKey && character != NSDownArrowFunctionKey)    
    {
      NSSearchField *searchField = [self visibleSearchField]; 
      if (searchField && [searchField currentEditor] == nil) // If the searchfield is not already active then we make it become the first responder
        [self makeFirstResponder:searchField]; 
    }
  }  
  [super sendEvent:theEvent];
}

- (void)runToolbarCustomizationPalette:(id)sender
{
  if (!buttonsInspector) buttonsInspector = [[FSObjectBrowserButtonsInspector alloc] init];
  [super runToolbarCustomizationPalette:sender];
  [buttonsInspector activate];
}

- (BOOL)worksWhenModal
{
  // Since F-Script is often used as a debugging tool, we want it to 
  // continue working even when some other window is being run modally
  return YES;
}

@end
