/* FScriptMenuItem.h Copyright (c) 2004-2009 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import <AppKit/AppKit.h>

@class FSInterpreterView;

@interface FScriptMenuItem : NSMenuItem 
{
  IBOutlet FSInterpreterView *interpreterView;
  IBOutlet NSPanel *preferencePanel;
  IBOutlet NSTextField *fontSizeUI;
  IBOutlet NSButton *automaticallyIntrospectDeclaredPropertiesUI;
}

- (FSInterpreterView *)interpreterView;
- (IBAction)openObjectBrowser:(id)sender;
- (IBAction)showConsole:(id)sender;
- (IBAction)showPreferencePanel:(id)sender;
- (IBAction)updatePreference:(id)sender; 

@end

