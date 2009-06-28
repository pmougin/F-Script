//  FSGenericObjectInspector.h Copyright (c) 2001-2006 Philippe Mougin.
//  This software is open source. See the license.

#import <AppKit/AppKit.h>

@interface FSGenericObjectInspector : NSObject
{
  id inspectedObject;
  IBOutlet NSWindow   *window;
  IBOutlet NSTextView *printStringView;  
}

+ (FSGenericObjectInspector *)genericObjectInspectorWithObject:(id)object;
- (FSGenericObjectInspector *)initWithObject:(id)object;
- (void)updateAction:(id)sender;

- (void)windowWillClose:(NSNotification *)aNotification;

@end
