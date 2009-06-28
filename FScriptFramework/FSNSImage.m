/*   FSNSImage.m Copyright (c) 2002-2006 Philippe Mougin.  */
/*   This software is open source. See the license.   */

#import "FSNSImage.h"
#import "FSImageInspector.h"

@implementation NSImage (FSNSImage)

-(void)inspect
{
  [FSImageInspector imageInspectorWithImage:self];
}

@end
