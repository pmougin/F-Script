/*   FSNewlyAllocatedObject.h Copyright (c) 2009 Philippe Mougin.     */
/*   This software is open source. See the license.                   */

#import <Cocoa/Cocoa.h>


@interface FSNewlyAllocatedObject : NSProxy 
{
  NSUInteger retainCount;
  id target; 
}

+ (id)newlyAllocatedObjectWithTarget:(id)theTarget;

- (NSString *)description;
- (void)forwardInvocation:(NSInvocation *)anInvocation;
- (id)initWithTarget:(id)theTarget;
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
- (void)release;
- (id)retain;

@end
