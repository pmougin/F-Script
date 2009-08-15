/*   FSNSFont.m Copyright (c) 2004-2009 Philippe Mougin.  */
/*   This software is open source. See the license.   */  

#import "FSNSFont.h"


@implementation NSFont (FSNSFont)

-(void)inspect
{
  [[NSFontManager sharedFontManager] setSelectedFont:self isMultiple:NO];
  [[NSFontManager sharedFontManager] orderFrontFontPanel:self];
}

@end
