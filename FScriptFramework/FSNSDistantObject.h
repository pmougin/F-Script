/*   FSNSDistantObject.h Copyright (c) 2001-2009 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import <Foundation/Foundation.h>
#import "FSNSObject.h"

@class FSBlock;

@interface NSDistantObject(FSNSDistantObject) <FSNSObject>

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)selector;

- (NSString *)descriptionLimited:(NSUInteger)nbElem;

///////////////// USER METHODS //////////////

/* FSNSObject support */

- (FSBoolean *)operator_equal_equal:(id)operand;
- (FSBoolean *)operator_tilde_tilde:(id)operand;

- (id)applyBlock:(FSBlock *)block;
- (FSArray *)enlist;
- (FSArray *)enlist:(NSNumber*)operand;
- (NSString *)printString;

- (NSConnection *)vend:(NSString *)operand __attribute__((deprecated));

@end
