/*   FSNSAttributedString.m Copyright (c) 2004-2009 Philippe Mougin.  */
/*   This software is open source. See the license.   */

#import "FSNSAttributedString.h"
#import "FSAttributedStringInspector.h"

@implementation NSAttributedString (FSNSAttributedString)

-(void)inspect
{
  [FSAttributedStringInspector attributedStringInspectorWithAttributedString:self];
}

@end

