/*   FSInterpreterViewIBHeader.h Copyright (c) 1998-2006 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

/* This is not he real header for FSInterpreterView. 
   Instead,this is the header to parse in IB, to inform
   IB of object1, object2 etc..
*/

#import <AppKit/AppKit.h>
#import <FScript/FSInterpreter.h>

@interface FSInterpreterView : NSView
{
  FSInterpreter *interpreter;
  id object1;
  id object2;
  id object3;
  id object4;
  id object5;
  id object6;
  id object7;
  id object8;
  id object9;
} 

- (CGFloat)fontSize;
- (FSInterpreter *)interpreter;
- (void)notifyUser:(NSString *)message;
- (void)putCommand:(NSString *)command;
- (void)setFontSize:(CGFloat)theSize;

@end