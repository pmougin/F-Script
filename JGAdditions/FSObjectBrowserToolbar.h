//
//  DistributorToolbar.h
//  RubatoFrameworks
//
//  FSObjectBrowserToolbar.h Copyright (c) 2002 Joerg Garbers.
//  This software is open source. See the license.

#import <Cocoa/Cocoa.h>
#import "FSObjectBrowserView.h"

@interface FSObjectBrowserView (ToolbarController) 

- (BOOL)doSetupToolbar;
- (BOOL)doSetupOldToolbar;

- (void) setupToolbarWithWindow:(NSWindow *)window;
- (NSToolbarItem *) toolbar: (NSToolbar *)toolbar itemForItemIdentifier: (NSString *) itemIdent willBeInsertedIntoToolbar:(BOOL) willBeInserted;
- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar *) toolbar;
- (NSArray *) toolbarAllowedItemIdentifiers: (NSToolbar *) toolbar;
- (void)toolbarDidRemoveItem:(NSNotification *)notification; 

// There will be the same Menu for all Windows. It contains only titles, no targets.
// [self is called with customBlockMenuAction:sender]
// self uses title to identify a block, which must be defined in its interpreter.
// (can be different for different interpreters)
// The result is: [block value], which should have side effects.
// Example: Type this in Interpreter window:
// accumulator:={}. collectSelection := [:browser | accumulator addObject:(browser selectedObject)]. FSObjectBrowserView addCustomBlockMenuIdentifier:'collectSelection'.

+ (NSMenu *) customBlockMenu;
+ (void) addCustomBlockMenuIdentifier:(NSString *)blockIdentifier;
+ (void) removeCustomBlockMenuIdentifier:(NSString *)blockIdentifier;
- (void) customBlockMenuAction:(id)sender;
@end
