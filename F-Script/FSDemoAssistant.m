/* FSDemoController.m Copyright (c) 2007-2009 Philippe Mougin.  */
/*   This software is open source. See the license.  */ 

#import "FSDemoAssistant.h"
#import "FSNSString.h"


@implementation FSDemoAssistant

@synthesize loadImage;
@synthesize displayImage;
@synthesize lockFocus;
@synthesize perspective;
@synthesize hueAdjust;
@synthesize bump;
@synthesize bumpAnimate;

- (void)activate
{
  if (![NSBundle loadNibNamed:@"DemoAssistant" owner:self])  
  {
    NSLog(@"Failed to load DemoAssistant nib file");
    NSBeep();
    return; 
  }
}

- (void) dealloc
{
  [interpreterView release];
  [super dealloc];
}

- (id)initWithInterpreterView:(FSInterpreterView *)theInterpreterView
{
  self = [super init];
  if (self != nil) 
  {
    interpreterView = [theInterpreterView retain];
  }
  return self;
}



- (IBAction)loadCode:sender
{
  [self putCommand:[[self performSelector:NSSelectorFromString([sender title])] string]];
}

- (void)putCommand:(NSString *)command
{
  NSArray *fragments = [command componentsSeparatedByString:@" "];
  
  for (unsigned int i = 0, n = [fragments count]; i < n; i++)
  {
    [interpreterView putCommand:[fragments objectAtIndex:i]];
    [interpreterView putCommand:@" "];
	[interpreterView display];
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
  }
  [[interpreterView window] makeKeyWindow];
}

@end
