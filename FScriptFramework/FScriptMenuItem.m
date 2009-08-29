/* FScriptMenuItem.m Copyright (c) 2004-2009 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import "FScriptMenuItem.h"
#import "FSInterpreter.h"
#import "FSInterpreterView.h"

@implementation FScriptMenuItem
 
+ (void)initialize
{  
  NSMutableDictionary *registrationDict = [NSMutableDictionary dictionary];

  [registrationDict setObject:[NSNumber numberWithDouble:[[NSFont userFixedPitchFontOfSize:-1] pointSize]] forKey:@"FScriptFontSize"];
  [registrationDict setObject:@"YES" forKey:@"FScriptAutomaticallyIntrospectDeclaredProperties"];  
 
  [[NSUserDefaults standardUserDefaults] registerDefaults:registrationDict];
}

+ (void)insertInMainMenu
{
  [[[NSApplication sharedApplication] mainMenu] addItem:[[[self alloc] init] autorelease]];
}


- (id)init
{
  //NSLog(@"FScriptMenuItem init");  
  return [self initWithTitle:@"F-Script" action:@selector(submenuAction:) keyEquivalent:@""];
}

/*- (id)initWithCoder:(NSCoder *)coder
{
   NSLog(@"FScriptMenuItem initWithCoder:");
   return [super initWithCoder:coder];
}  */


- (id)initWithTitle:(NSString *)itemName action:(SEL)anAction keyEquivalent:(NSString *)charCode
{
  //NSLog(@"FScriptMenuItem initWithTitle:action:keyEquivalent:");
  
  if (self = [super initWithTitle:itemName action:anAction keyEquivalent:charCode])
  {
    NSMenu *submenu = [[[NSMenu alloc] initWithTitle:@"F-Script"] autorelease];
    
	NSMenuItem *item1 = [[[NSMenuItem alloc] initWithTitle:@"Show Console" action:@selector(showConsole:) keyEquivalent:@""] autorelease];
    [item1 setTarget:self];
    [submenu addItem:item1];
    
    NSMenuItem *item2 = [[[NSMenuItem alloc] initWithTitle:@"Open Object Browser" action:@selector(openObjectBrowser:) keyEquivalent:@""] autorelease];
    [item2 setTarget:self];
    [submenu addItem:item2];
    
    NSMenuItem *item3 = [[[NSMenuItem alloc] initWithTitle:@"Preferences..." action:@selector(showPreferencePanel:) keyEquivalent:@""] autorelease];
    [item3 setTarget:self];
    [submenu addItem:item3];

	[self setSubmenu:submenu];

    return self;
  }
  return nil;  
}

- (FSInterpreterView *) interpreterView
{
  if (!interpreterView) [NSBundle loadNibNamed:@"FSConsole.nib" owner:self];
  return interpreterView;
}

- (IBAction)openObjectBrowser:(id)sender
{
  [[[self interpreterView] interpreter] browse]; 
} 

- (IBAction)showConsole:(id)sender
{
  [[[self interpreterView] window] makeKeyAndOrderFront:nil];
}

- (void)showPreferencePanel:(id)sender
{
  if (!preferencePanel) 
  {
    if (![NSBundle loadNibNamed:@"FScriptPreferences" owner:self])  
    {
      NSLog(@"Failed to load FScriptPreferences.nib");
      NSBeep();
      return;
    }
    [preferencePanel center];
  }
  [fontSizeUI setDoubleValue:[[self interpreterView] fontSize]];
  [automaticallyIntrospectDeclaredPropertiesUI setState:[[NSUserDefaults standardUserDefaults] boolForKey:@"FScriptAutomaticallyIntrospectDeclaredProperties"]];

  [preferencePanel makeKeyAndOrderFront:nil];
}

- (IBAction)updatePreference:(id)sender // action
{
  //NSLog(@"** updatePreference");
  if (sender == fontSizeUI)
  {
    [[NSUserDefaults standardUserDefaults] setFloat:[fontSizeUI doubleValue] forKey:@"FScriptFontSize"];
    [[self interpreterView] setFontSize:[fontSizeUI doubleValue]];
  }
  else if (sender == automaticallyIntrospectDeclaredPropertiesUI)
  {
    [[NSUserDefaults standardUserDefaults] setBool:[automaticallyIntrospectDeclaredPropertiesUI state] forKey:@"FScriptAutomaticallyIntrospectDeclaredProperties"];
  }
}

@end
