/* FSInterpreterView.h Copyright (c) 1998-2009 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import <AppKit/AppKit.h>

@class FSInterpreter;

@interface FSInterpreterView : NSView
{
  FSInterpreter *interpreter;
} 

- (CGFloat)fontSize;
- (FSInterpreter *)interpreter;
- (void)notifyUser:(NSString *)message;
- (void)putCommand:(NSString *)command;
- (void)setFontSize:(CGFloat)theSize;

@end
