/*   FSAutoreleasePool.h Copyright (c) 2008 Philippe Mougin. */
/*   This software is open source. See the license.   */

#import <Cocoa/Cocoa.h>


@interface FSAutoreleasePool : NSAutoreleasePool 
{
  NSUInteger retainCount;
}

@end
