/*   FSVoid.h Copyright (c) 1998-2006 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import "FSNSObject.h"

@interface FSVoid : NSObject <NSCopying,NSCoding>

+ (FSVoid*) fsVoid;

- (id)autorelease;
- awakeAfterUsingCoder:(NSCoder *)aDecoder;
- (id) copy;
- (id) copyWithZone:(NSZone *)zone;
- (NSString *) printString;
- (void) release;
- (id) retain;
- (NSUInteger) retainCount;

@end

