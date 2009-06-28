//  FSAttributedStringInspector.h Copyright (c) 2004-2006 Philippe Mougin.
//  This software is open source. See the license.

#import <AppKit/AppKit.h>

@interface FSAttributedStringInspector : NSObject
{
  id inspectedObject;
  IBOutlet NSWindow   *window;
  IBOutlet NSTextView *printStringView;
  IBOutlet NSTextView *attributedStringView;    
}

+ (FSAttributedStringInspector *)attributedStringInspectorWithAttributedString:(NSAttributedString *)object;
- (FSAttributedStringInspector *)initWithAttributedString:(NSAttributedString *)object;
- (IBAction)updateAction:(id)sender;

- (void)windowWillClose:(NSNotification *)aNotification;

@end 
