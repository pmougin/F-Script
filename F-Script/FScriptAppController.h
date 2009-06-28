/* FScriptAppController.h Copyright 1998-2006 Philippe Mougin.  */
/*   This software is open source. See the license.  */   

#import <Cocoa/Cocoa.h>

@class FSInterpreterView;
@class NSPanel;
@class NSTextField; 
@class NSButton;
@class NSApplication;

void RestartWithCorrectGarbageCollectionSettingIfNecessary();

@interface FScriptAppController : NSObject
{
  IBOutlet FSInterpreterView *interpreterView;  
  IBOutlet NSPanel *infoPanel;                  
  IBOutlet NSPanel *preferencePanel;            
  IBOutlet NSTextField *fontSizeUI;             
  IBOutlet NSButton *shouldJournalUI;
  IBOutlet NSButton *confirmWhenQuittingUI;
  IBOutlet NSButton *runWithObjCAutomaticGarbageCollectionUI;
  IBOutlet NSButton *displayObjectBrowserAtLaunchTimeUI;
  IBOutlet NSButton *automaticallyIntrospectDeclaredPropertiesUI;
  
  NSMenuItem *showConsoleMenuItem;
  
  BOOL quitConfirmed;
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename;
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender;

- (void)newObjectBrowser:sender;
- (void)showConsole:(id)sender;
- (void)newDemoAssistant:(id)sender;
- (void)showInfoPanel:(id)sender;
- (void)showPreferencePanel:(id)sender;
- (void)updatePreference:(id)sender;

- (void)windowWillClose:(NSNotification *)aNotification;

@end
