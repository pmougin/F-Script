/*   FSNSProtocolChecker.h Copyright (c) 2002-2006 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import <Foundation/Foundation.h>

@interface NSProtocolChecker(FSNSProtocolChecker)

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)selector;

@end
