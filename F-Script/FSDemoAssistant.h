/* FSDemoController.h Copyright (c) 2007-2009 Philippe Mougin.  */
/*   This software is open source. See the license.  */ 

#import <Cocoa/Cocoa.h>
#import "FSInterpreterView.h"


@interface FSDemoAssistant : NSObject 
{
  IBOutlet FSInterpreterView *interpreterView;
  NSTextView *loadImage;
  NSTextView *displayImage;
  NSTextView *lockFocus;
  NSTextView *perspective;
  NSTextView *hueAdjust;
  NSTextView *bump;
  NSTextView *bumpAnimate;
  
  NSTextView *horloge;
  
  NSTextView *connectToITunes;
  NSTextView *volumeRamp;
} 

@property (retain) IBOutlet NSTextView *loadImage;
@property (retain) IBOutlet NSTextView *displayImage;
@property (retain) IBOutlet NSTextView *lockFocus;
@property (retain) IBOutlet NSTextView *perspective;
@property (retain) IBOutlet NSTextView *hueAdjust;
@property (retain) IBOutlet NSTextView *bump;
@property (retain) IBOutlet NSTextView *bumpAnimate;

@property (retain) IBOutlet NSTextView *horloge;

@property (retain) IBOutlet NSTextView *connectToITunes;
@property (retain) IBOutlet NSTextView *volumeRamp;

- (void)activate;
- (id)initWithInterpreterView:(FSInterpreterView *)theInterpreterView;
- (IBAction)loadCode:sender;
- (void)putCommand:(NSString *)command;

@end
