//  BigBrowserToolbar.m Copyright (c) 2002 Joerg Garbers.
//  This software is open source. See the license.

#import "BigBrowserToolbar.h"
#import "Block.h"
#import "FSInterpreter.h"
#import "BigBrowserToolbarButton.h"
#import "System.h"
#import "FSNSString.h" 

@implementation BigBrowserView (ToolbarController)

static NSMutableArray *customButtons; // Added by PM for f-script 1.2.3

+ (NSArray *)customButtons // Added by PM for f-script 1.2.3
{
  return customButtons;
}

/*+(void) initialize // Added by PM for f-script 1.2.3
{
  static BOOL tooLate = NO;
  if ( !tooLate ) 
  {  
    int i;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    customButtons = [[NSMutableArray alloc] init];
    
    for (i = 1; i < 11; i++)
    {
      BigBrowserToolbarButton *button = [[BigBrowserToolbarButton alloc] initWithFrame:NSMakeRect(0,0,93,30)];
      NSString *buttonName  = [defaults stringForKey:[NSString stringWithFormat:@"BigBrowserToolbarButtonCustom%dName",i]];
      NSData *blockData = [defaults objectForKey:[NSString stringWithFormat:@"BigBrowserToolbarButtonCustom%dBlock",i]];
      Block *block = nil;
      
      block = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:[NSString stringWithFormat:@"BigBrowserToolbarButtonCustom%dBlock",i]]];
      
      if (blockData)
      {
        //NS_DURING
        block = [NSUnarchiver unarchiveObjectWithData:blockData];
        //NS_HANDLER
        //  NSLog([NSString stringWithFormat:@"Syntax error found while loading a block for an F-Script object browser custom button: %@", [localException reason]]);
        //  blockSource = nil; // We will fall back to the default block template
        //NS_ENDHANDLER
      }
      
      if (!buttonName)  buttonName  = [NSString stringWithFormat:@"Custom%d", i];
      
      if (!block) 
      {
        NSString *blockSource = @"[:selectedObject| selectedObject  \"Define your custom block here.\"]";
        block = [blockSource asBlock];
      }  
      
      [button setIdentifier:[NSString stringWithFormat:@"Custom%d", i]];
      [button setName:buttonName];
      [button setBlock:block];
      [button setAction:@selector(applyBlockAction:)];
      [customButtons addObject:button];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCustomButtonsSettings:) name:NSApplicationWillTerminateNotification object:nil];
  }
}*/

+ (void)saveCustomButtonsSettings // Added by PM for F-Scrip 1.2.3
{
  NSInteger i;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  for (i = 0; i < 10; i++)
  { 
#warning 64BIT: Check formatting arguments
    [defaults setObject:[[customButtons objectAtIndex:i] name] forKey:[NSString stringWithFormat:@"BigBrowserToolbarButtonCustom%dName",i+1] inDomain:@"NSGlobalDomain"]; // This is an undocumented Cocoa API in Mac OS X 10.1
    //[defaults setObject:[NSArchiver archivedDataWithRootObject:[[customButtons objectAtIndex:i] block]] forKey:[NSString stringWithFormat:@"BigBrowserToolbarButtonCustom%dBlock",i+1] inDomain:@"NSGlobalDomain"]; // This is an undocumented Cocoa API in Mac OS X 10.1
  } 
  [defaults synchronize];
}

+ (void)saveCustomButtonsSettings:(NSNotification *)aNotification // Added by PM for F-Scrip 1.2.3
{
  [self saveCustomButtonsSettings];
}

- (BOOL)doSetupToolbar;
{
  static BOOL yn=YES;
  return yn;
}
- (BOOL)doSetupOldToolbar;
{
  static BOOL yn=NO;
  return yn;
}

- (void) setupToolbarWithWindow:(NSWindow *)window;
{
  // Create a new toolbar instance, and attach it to our document window
  NSToolbar *toolbar = [[[NSToolbar alloc] initWithIdentifier: @"BigBrowserToolbar"] autorelease];

  // Set up toolbar properties: Allow customization, give a default display mode, and remember state in user defaults
  [toolbar setAllowsUserCustomization: YES];
  [toolbar setAutosavesConfiguration: YES];
  [toolbar setDisplayMode:NSToolbarDisplayModeIconOnly]; //  NSToolbarDisplayModeIconAndLabel

  // We are the delegate
  [toolbar setDelegate: self];

  // Attach the toolbar to the document window
  [window setToolbar: toolbar];
}

- (NSToolbarItem *) toolbar: (NSToolbar *)toolbar itemForItemIdentifier: (NSString *) itemIdent willBeInsertedIntoToolbar:(BOOL) willBeInserted // Modified by PM for f-script 1.2.3
{
  // Required delegate method   Given an item identifier, self method returns an item
  // The toolbar will use self method to obtain toolbar items that can be displayed in the customization sheet, or in the toolbar itself
  
  NSToolbarItem *toolbarItem; 
  
  if (![[toolbar identifier] isEqualToString:@"BigBrowserToolbar"]) return nil;
  
  if ([itemIdent hasPrefix:@"Custom"])
  {
    toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier: itemIdent] autorelease];
  
    NSMenuItem *menuFormRep;
    BigBrowserToolbarButton *button;
    NSInteger i = 0;
       
    while (![[[customButtons objectAtIndex:i] identifier] isEqualToString:itemIdent])
      i++;
      
    button = [[[customButtons objectAtIndex:i] copy] autorelease];
    [button setTarget:self]; 
    [toolbarItem setView:button];
    [button setToolbarItem:toolbarItem];
    
    menuFormRep = [[[NSMenuItem alloc] init] autorelease];
    [menuFormRep setAction:@selector(selectedFromMenuItem:)];
    [menuFormRep setTarget:button];
    [menuFormRep setTitle:[button name]];
    [toolbarItem setMenuFormRepresentation: menuFormRep];    
    [toolbarItem setTarget:self];
    [toolbarItem setLabel:[button name]];
    [toolbarItem setPaletteLabel:[button name]];
    
    [toolbarItem setMinSize:[[button cell] cellSize].width < 93 ? NSMakeSize(93, [button frame].size.height) : [[button cell] cellSize]];
    [toolbarItem setMaxSize:([button frame].size.width < 93 ? NSMakeSize(93, [button frame].size.height) : [[button cell] cellSize])];
    //[toolbarItem setMinSize:[button frame].size];
    //[toolbarItem setMaxSize:[button frame].size];
  }
  else
  {
    toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier: itemIdent] autorelease];
    NSString *buttonTitle=nil;
    NSString *toolTip=nil;
    SEL action=nil;
  
    // defaults
    buttonTitle=itemIdent; 
  
    if ([itemIdent isEqual: @"Classes"]) {
      action=@selector(classesAction:);
      toolTip=@"Browse loaded classes";
    }
    if ([itemIdent isEqual: @"Workspace"]) {
      action=@selector(workspaceAction:);
      toolTip=@"Browse workspace";
    }
    if ([itemIdent isEqual: @"Update"]) {
      action=@selector(updateAction:);
      toolTip=@"Update the diplay of objects";
    }
    if ([itemIdent isEqual: @"Name"]) {
      action=@selector(nameObjectAction:);
      toolTip=@"Assign the selected object to an identifier in the F-Script environment";
    }
    if ([itemIdent isEqual: @"Self"]) {
      action=@selector(selfAction:);
      toolTip=@"Send the \"self\" message to the selected object";
    }
    if ([itemIdent isEqual: @"Inspect"]) {
      action=@selector(inspectObjectAction:);
      toolTip=@"Inspect the selected object";
    }
    if ([itemIdent isEqual: @"Key-value"]) {
      action=@selector(browseKVAction:);
      toolTip=@"Browse the selected object relations";
    }
    if ([itemIdent isEqual: @"Select view"]){
      action=@selector(selectViewAction:);
      toolTip=@"Lets you select a view with the mouse and browse it";
    }
  
    // if it is a button of the above, action is set to non nil.
    if (action) 
    {
      NSMenuItem *menuFormRep = nil;
      NSButton *button = [[[NSButton alloc] initWithFrame:NSMakeRect(0,0,93,30)] autorelease];
      
      [button setBezelStyle:NSRoundedBezelStyle];
      [button setTitle:buttonTitle];
      [button setAction:action];
      [button setTarget:self];
      [button setToolTip:toolTip];
      
      [toolbarItem setLabel: buttonTitle];
      [toolbarItem setPaletteLabel: buttonTitle];
      [toolbarItem setLabel: buttonTitle];
      [toolbarItem setPaletteLabel: buttonTitle];
      [toolbarItem setTarget:self];

      [toolbarItem setView:button];
      [toolbarItem setMinSize:[[button cell] cellSize].width < 93 ? NSMakeSize(93, [button frame].size.height) : [[button cell] cellSize]];
      [toolbarItem setMaxSize:([button frame].size.width < 93 ? NSMakeSize(93, [button frame].size.height) : [[button cell] cellSize])];
      //[toolbarItem setMinSize:[button frame].size];
      //[toolbarItem setMaxSize:[button frame].size];
      [toolbarItem setToolTip:toolTip];


      menuFormRep = [[[NSMenuItem alloc] init] autorelease];
      [menuFormRep setTitle: buttonTitle];
      [menuFormRep setAction:action];
      [menuFormRep setTarget:[toolbarItem target]];
      [toolbarItem setMenuFormRepresentation: menuFormRep];
       

    } /*else if([itemIdent isEqual: @"ApplyBlock"]) {
      NSMenu *submenu = [[self class] customBlockMenu]; // always the same instance (allows us to add to submenu in one place only)
      NSMenuItem *menuFormRep = nil;
      NSRect r=NSMakeRect(0.0,0.0,150.0,30.0);
      NSPopUpButton *popUpButton=[[[NSPopUpButton alloc] initWithFrame:r pullsDown:NO] autorelease];
      [popUpButton setMenu:submenu];
      [popUpButton setTitle:itemIdent];

      [toolbarItem setToolTip: @"Run Selection with User defined Block."];
      [toolbarItem setView:popUpButton];
      [toolbarItem setMinSize:NSMakeSize(150,NSHeight([popUpButton frame]))];
      [toolbarItem setMaxSize:NSMakeSize(250,NSHeight([popUpButton frame]))];
  
      // By default, in text only mode, a custom items label will be shown as disabled text, but you can provide a
      // custom menu of your own by using <item> setMenuFormRepresentation]
      menuFormRep = [[[NSMenuItem alloc] init] autorelease];
      [menuFormRep setSubmenu: submenu];
      [menuFormRep setTitle: [toolbarItem label]];
      [toolbarItem setMenuFormRepresentation: menuFormRep];
    }*/ else {
        // itemIdent refered to a toolbar item that is not provide or supported by us or cocoa
        // Returning nil will inform the toolbar self kind of item is not supported
        toolbarItem = nil;
    }
  }
  return toolbarItem;
}

- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar *) toolbar;
{
  // Required delegate method   Returns the ordered list of items to be shown in the toolbar by default
  // If during the toolbar's initialization, no overriding values are found in the user defaults, or if the
  // user chooses to revert to the default items self set will be used
  return [NSArray arrayWithObjects: @"Workspace", @"Classes", @"Select view", @"Name", @"Self", @"Inspect", nil];
}

- (NSArray *) toolbarAllowedItemIdentifiers: (NSToolbar *) toolbar;
{
  // Required delegate method   Returns the list of all allowed items by identifier   By default, the toolbar
  // does not assume any items are allowed, even the separator   So, every allowed item must be explicitly listed
  // The set of allowed items is used to construct the customization palette
  
  return [NSArray arrayWithObjects: @"Workspace",@"Classes",@"Select view",@"Name",@"Self",@"Inspect",
    @"Update",@"Key-value", @"Custom1", @"Custom2", @"Custom3", @"Custom4", @"Custom5", @"Custom6", @"Custom7", @"Custom8", @"Custom9", @"Custom10", NSToolbarCustomizeToolbarItemIdentifier,
    NSToolbarFlexibleSpaceItemIdentifier, NSToolbarSpaceItemIdentifier, NSToolbarSeparatorItemIdentifier, nil];
   /* return [NSArray arrayWithObjects: @"Classes",@"Workspace",@"Name",@"Self",@"Inspect",
    @"Update",@"Key-value", NSToolbarCustomizeToolbarItemIdentifier,
    NSToolbarFlexibleSpaceItemIdentifier, NSToolbarSpaceItemIdentifier, NSToolbarSeparatorItemIdentifier, nil];*/
}

+ (NSMenu *) customBlockMenu;
{
  static NSMenu *menu=nil;
  if (!menu) {
    menu=[[NSMenu alloc] initWithTitle:@"ApplyBlock"];
  }
  return menu;
}

+ (void) addCustomBlockMenuIdentifier:(NSString *)blockIdentifier;
{
  NSMenu *menu=[self customBlockMenu];
  NSMenuItem *item=[[NSMenuItem alloc] initWithTitle:blockIdentifier action:@selector(customBlockMenuAction:) keyEquivalent:@""];
  [menu addItem:item];
}
+ (void) removeCustomBlockMenuIdentifier:(NSString *)blockIdentifier;
{
  NSMenu *menu=[self customBlockMenu];
  NSInteger idx=[menu indexOfItemWithTitle:blockIdentifier];
  if (idx!=NSNotFound)
    [menu removeItemAtIndex:idx];
  else
#warning 64BIT: Check formatting arguments
    NSLog(@"Warning: removeCustomBlockMenuIdentifier called with invalid blockIdentifier %@",blockIdentifier);
}
- (void) customBlockMenuAction:(id)sender;
{
  BOOL found;
  NSString *title=[sender title];
  id selectedObject = [self selectedObject];
  id block=[interpreter objectForIdentifier:title found:&found];
  if (!found) {
#warning 64BIT: Check formatting arguments
    NSInteger choice=NSRunAlertPanel(@"Undefined Block", [NSString stringWithFormat:@"Could not find Block with name %@", title], @"Cancel", @"Remove Menu Entry", nil);
    if (choice) {
      [[self class] removeCustomBlockMenuIdentifier:title];
    }
  } else {
    [block value:selectedObject];
  }
}
@end
