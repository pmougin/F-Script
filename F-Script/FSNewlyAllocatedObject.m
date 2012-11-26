/*   FSNewlyAllocatedObject.m Copyright (c) 2009 Philippe Mougin.     */
/*   This software is open source. See the license.                   */

#import "FSNewlyAllocatedObject.h"
#import <objc/objc-runtime.h> 

@implementation FSNewlyAllocatedObject

+ (id)newlyAllocatedObjectWithTarget:(id)theTarget
{
  return [[[self alloc] initWithTarget:theTarget] autorelease];
}

- (NSString *)description
{
  return [[@"Proxy for a newly allocated " stringByAppendingString:NSStringFromClass(object_getClass(target))] stringByAppendingString:@". Don't forget to initialize it and to use the object returned by the init... method instead of this proxy." ];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
  [anInvocation setTarget:target];
  [anInvocation invoke];
  return;
}

/*
NSProxy (10.6) unfortunately does not support fast forwarding (i.e., forwardingTargetForSelector:)
If it does in a future version, we will be able to replace forwardInvocation: and methodSignatureForSelector: by the method below

- (id)forwardingTargetForSelector:(SEL)aSelector
{
  return target;
}
*/

- (id)initWithTarget:(id)theTarget
{
  retainCount = 1;
  
  // We do not retain the target, as we stand for an object that has just been allocated but not yet initialized
  // Retaining an uninitialized object is not a good idea, in particular because its retain count is not yet initialized
  target = theTarget; 

  return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
  return [target methodSignatureForSelector:aSelector];
}

- (NSString *)printString
{
  return [self description];
}

- (id)retain 
{ 
  retainCount++; 
  return self;
}

- (NSUInteger)retainCount 
{ 
  return retainCount;
}

- (void)release 
{ 
  if (--retainCount == 0) [self dealloc];
}  

@end
