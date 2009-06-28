/* FSDemoController.m Copyright (c) 2007 Philippe Mougin.  */
/*   This software is open source. See the license.  */ 

#import "FSDemoController.h"
#import "FSNSString.h"


@implementation FSDemoController

- (IBAction)drawLine:sender
{
  [self putCommand:@"p := NSBezierPath bezierPath. p moveToPoint:0<>0; lineToPoint:300<>300; stroke."];
}

- (IBAction)drawCircle:sender
{
  [self putCommand:@"(NSBezierPath bezierPathWithOvalInRect:(400<>300 extent:200<>200)) stroke."];
}

- (IBAction)converter:sender
{
  [self putCommand:@"\n\"--- F-SCRIPT CURRENCY CONVERTER ---\"\n"
                   @"\n"
                   @"\"--- Instantiate and configure the window ---\"\n"
                   @"\n"
                   @"window := NSWindow alloc initWithContentRect:(125<>513 extent:383<>175)\n"
                   @"                         styleMask:NSTitledWindowMask + NSClosableWindowMask\n"
                   @"                         backing:NSBackingStoreBuffered defer:NO.\n" 
                   @"\n"
                   @"\"--- Create the script that will compute the currency conversion ---\"\n"
                   @"\n"
				   @"conversionScript := [(form cellAtIndex:2) setStringValue:(form cellAtIndex:0) floatValue * (form cellAtIndex:1) floatValue].\n"
                   @"\n"
                   @"\"--- Instantiate and configure the form ---\"\n"
                   @"\n"
				   @"form := NSForm alloc initWithFrame:(15<>70 extent:348<>85).\n"
                   @"form addEntry:@{'Exchange Rate per $1','Dollars to Convert','Amount in Other Currency'}.\n"
				   @"form setInterlineSpacing:9; setAutosizesCells:YES; setTarget:conversionScript; setAction:#value.\n"
				   @"\n"
				   @"\"--- Instantiate and configure the button ---\"\n"
                   @"\n"
                   @"button := NSButton alloc initWithFrame:(247<>15 extent:90<>30).\n"
                   @"button setBezelStyle:NSRoundedBezelStyle; setTitle:'Convert'; setTarget:conversionScript;\n"
                   @"setAction:#value; setKeyEquivalent:'\\r'.\n"
                   @"\n"
                   @"\"--- Instantiate and configure the decorative line ---\"\n"
                   @"\n"
                   @"line := NSBox alloc initWithFrame:(15<>59 extent:353<>2).\n"
                   @"\n"
                   @"\" ---Put the various components in the window and put the window onscreen ---\"\n"
                   @"\n"
                   @"window contentView addSubview:@{form, button, line}.\n" 
                   @"window setTitle:'Currency Converter'; orderFront:nil.\n"];
}


- (IBAction)loadImage:sender
{
  [self putCommand:@"image := CIImage imageWithContentsOfURL:(NSURL fileURLWithPath:'/Users/pmougin/Desktop/Clown Fish.png')."];
}

- (IBAction)displayImage:sender
{
  [self putCommand:@"image drawInRect:(200<>150 extent:image extent extent) fromRect:image extent operation:NSCompositeSourceOver fraction:1."];
}

- (IBAction)perspective:sender
{
  [self putCommand:@"perspective := CIFilter filterWithName:'CIPerspectiveTransform'.\n"
                   @"perspective setValue:(CIVector vectorWithX:0 Y:306) forKey:'inputTopLeft'.\n"
                   @"perspective setValue:(CIVector vectorWithX:490 Y:306) forKey:'inputTopRight'.\n"
                   @"perspective setValue:(CIVector vectorWithX:590 Y:0) forKey:'inputBottomRight'.\n"
                   @"perspective setValue:(CIVector vectorWithX:-100 Y: 0) forKey:'inputBottomLeft'.\n"
                   @"\n"
                   @"perspective setValue:image forKey:'inputImage'.\n"
                   @"image := perspective valueForKey:'outputImage'."];
}

- (IBAction)hueAdjust:sender
{
  [self putCommand:@"hueAdjust := CIFilter filterWithName:'CIHueAdjust'.\n"
                   @"hueAdjust setValue:2.094 forKey:'inputAngle'.\n"
                   @"\n"
                   @"hueAdjust setValue:image forKey:'inputImage'.\n"
                   @"image := hueAdjust valueForKey:'outputImage'."];
}

- (IBAction)bump:sender
{
  [self putCommand:@"bump := CIFilter filterWithName:'CIBumpDistortion'.\n"
                   @"bump setValue:(CIVector vectorWithX:300 Y:150) forKey:'inputCenter'.\n"
                   @"bump setValue:130 forKey:'inputRadius'.\n"
                   @"bump setValue:0.7 forKey:'inputScale'.\n"
                   @"\n"
                   @"bump setValue:image forKey:'inputImage'.\n"
                   @"image := bump valueForKey:'outputImage'."];
}

- (IBAction)eges:sender
{
  [self putCommand:@"edges := CIFilter filterWithName:'CIEdges'.\n"
                   @"edges setValue:20 forKey:'inputIntensity'.\n"
                   @"\n"
                   @"edges setValue:image forKey:'inputImage'.\n"
                   @"image := edges valueForKey:'outputImage'.\n"];
}


- (IBAction)bumpAnimate:sender
{
  [self putCommand:@"image := CIImage imageWithContentsOfURL:(NSURL fileURLWithPath:'/Users/pmougin/Desktop/Clown Fish.png').\n"
				   @"window := NSApplication sharedApplication keyWindow.\n"
                   @"destinationRect := (200<>150 extent:image extent extent).\n"
                   @"\n"
                   @"bump := CIFilter filterWithName:'CIBumpDistortion'.\n"
                   @"bump setValue:130 forKey:'inputRadius'.\n"
                   @"bump setValue:0.7 forKey:'inputScale'.\n"
                   @"bump setValue:image forKey:'inputImage'.\n"
                   @"\n"
                   @"0 to:600 do:\n"
                   @"[:i|\n"
                   @"  bump setValue:(CIVector vectorWithX:i Y:150) forKey:'inputCenter'.\n"
                   @"  result := bump valueForKey:'outputImage'.\n"
                   @"  result drawInRect:destinationRect fromRect:image extent operation:NSCompositeSourceOver fraction:1.\n"
                   @"  window flushWindow.\n"
                   @"].\n"];
}


- (void)putCommand:(NSString *)command
{
  NSArray *fragments = [command componentsSeparatedByString:@" "];
  
  for (unsigned int i = 0, n = [fragments count]; i < n; i++)
  {
    [interpreterView putCommand:[fragments objectAtIndex:i]];
    [interpreterView putCommand:@" "];
	[interpreterView display];
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.02]];
  }
  [[interpreterView window] makeKeyWindow];
}

@end
