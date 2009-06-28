//  FSObjectBrowserToolbarButton.h Copyright (c) 2002-2009 Philippe Mougin.
//  This software is open source. See the license.

#import <AppKit/AppKit.h>

@class FSBlock;

@interface FSObjectBrowserToolbarButton : NSSegmentedControl
{
  FSBlock *block;
  NSString *identifier;
  NSToolbarItem *toolbarItem;
}

- (id) initWithFrame:(NSRect)frameRect;
- (FSBlock *) block;
- (void) configure:(id)sender;
- (id)copyWithZone:(NSZone *)zone;
- (NSString *) identifier;
- (void) inspectBlock:(id)sender;
- (NSString *) name;
- (void) setBlock:(FSBlock *)theBlock;
- (void) setIdentifier:(NSString *)theIdentifier;
- (void) setToolbarItem:(NSToolbarItem *)item;
- (void) takeNameFrom:(id)sender;
- (void) setName:(NSString *)name;

@end
