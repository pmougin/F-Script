/*   FSNSProtocolChecker.m Copyright (c) 2002-2006 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import "FSNSProtocolChecker.h"

@interface NSMethodSignature(UndocumentedNSMethodSignature)
+ (NSMethodSignature*) signatureWithObjCTypes:(char *)types;
@end

@implementation NSProtocolChecker(FSNSProtocolChecker)

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
  // Partial fix for broken Mac OS X implementation of NSProxy meta-class level.
  // Limitation: this is all hard wired here, and thus will not work for methods added in new categories or new subclasses.

  if   (selector ==  @selector(protocolCheckerWithTarget:protocol:))  return [NSMethodSignature signatureWithObjCTypes:"@@:@@"];
  else return [[NSProxy class] methodSignatureForSelector:selector];
  // A strange bug in GCC3 (beta) makes using "super" seemingly impossible here.
  // We can't use [self superclass] instead because it's buggy too (it returns NSProxy meta class)!
  // So we hard-wire the use of NSProxy.
}

@end
