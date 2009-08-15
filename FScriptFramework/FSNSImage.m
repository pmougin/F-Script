/*   FSNSImage.m Copyright (c) 2002-2009 Philippe Mougin.  */
/*   This software is open source. See the license.   */

#import "FSNSImage.h"
#import "FSImageInspector.h"

@implementation NSImage (FSNSImage)

-(void)inspect
{
  [FSImageInspector imageInspectorWithImage:self];
}

@end
