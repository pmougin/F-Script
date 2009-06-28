/*   FSAutoreleasePool.m Copyright (c) 2008 Philippe Mougin. */
/*   This software is open source. See the license.   */

#import "FSAutoreleasePool.h"


@implementation FSAutoreleasePool

- (id) init
{
  self = [super init];
  if (self != nil) 
  {
    retainCount = 1;
  }
  return self;
}

- (id)retain { retainCount++; return self; }

- (void)release { if (--retainCount == 0) [super release]; }  

@end
