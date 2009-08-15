//  FSImageInspector.m Copyright (c) 2001-2009 Philippe Mougin.
//  This software is open source. See the license.

#import "FSImageInspector.h"
#import "FSMiscTools.h"

static NSPoint topLeftPoint = {0,0}; // Used for cascading windows.
 
@implementation FSImageInspector

+(FSImageInspector *)imageInspectorWithImage:(id)object
{
  return [[[self alloc] initWithImage:object] autorelease];
}

-(FSImageInspector *)initWithImage:(id)object
{
  if ((self = [super init]))
  { 
    inspectedObject = [object retain];
    [NSBundle loadNibNamed:@"FSImageInspector.nib" owner:self];
    [self retain]; // To balance the autorelease in windowWillClose:
    NSSize imageSize = [inspectedObject size];
    [imageView setImageScaling:NSScaleNone];

    if (!(imageSize.width == 0 && imageSize.height == 0))
    {
      [imageView setFrameSize:imageSize];
      [window setContentSize:NSMakeSize(MAX(imageSize.width+15, 120), MAX(imageSize.height+15, 20))];
      [window setMaxSize:[window frame].size];
    }
    [imageView setImage:inspectedObject];
    [imageView setImageAlignment:NSImageAlignCenter];    
    topLeftPoint = [window cascadeTopLeftFromPoint:topLeftPoint];
    [window makeKeyAndOrderFront:nil];
    return self;
  }
  return nil;
}

-(void) dealloc
{
  //NSLog(@"\n FSImageInspector dealloc\n");
  [inspectedObject release];
  [super dealloc];
}

/////////////////// Window delegate callbacks

- (void)windowWillClose:(NSNotification *)aNotification
{
  //NSLog(@"\n WindowWillClose\n");
  [self autorelease];
}

//- (unsigned)imageViewRc {return [imageView retainCount];} 

@end
