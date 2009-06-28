/* FSDemoController.h Copyright (c) 2007 Philippe Mougin.  */
/*   This software is open source. See the license.  */ 

#import <Cocoa/Cocoa.h>
#import "FSInterpreterView.h"


@interface FSDemoController : NSObject 
{
  IBOutlet FSInterpreterView *interpreterView;
}


- (IBAction)drawLine:sender;
- (IBAction)drawCircle:sender;
- (IBAction)converter:sender;
- (IBAction)loadImage:sender;
- (IBAction)displayImage:sender;
- (IBAction)perspective:sender;
- (IBAction)hueAdjust:sender;
- (IBAction)bump:sender;
- (IBAction)eges:sender;
- (IBAction)bumpAnimate:sender;

- (void)putCommand:(NSString *)command;

@end
