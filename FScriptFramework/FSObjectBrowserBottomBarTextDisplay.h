/* FSObjectBrowserBottomBarTextDisplay.h Copyright (c) 2009 Philippe Mougin.  */
/* This software is open source. See the license.                        */ 

#import <Cocoa/Cocoa.h>

@interface FSObjectBrowserBottomBarTextDisplay : NSButton {

}

- (id)initWithFrame:(NSRect)frameRect;
- (void)setString:(NSString *)string;

@end
