/*   DOTest.m Copyright (c) 2001-2009 Philippe Mougin.   */
/*   This software is open source. See the license. */

#import "DOTest.h"


@implementation DOTest

-(void)setObject:(id)theObject
{
  [theObject retain];
  [object release];
  object = theObject;
} 

-(void)setObjectByCopy:(bycopy id)theObject;
{
  [self setObject:theObject];
}
 
- (id)object
{
  return object;
}

@end
