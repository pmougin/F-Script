/* ArrayRepBoolean.h Copyright (c) 1998-2009 Philippe Mougin. */
/*   This software is open source. See the license.       */

#import <Foundation/Foundation.h>
#import "ArrayRep.h"

@interface ArrayRepBoolean : NSObject <ArrayRep>
{
  NSUInteger retainCount;
@public
  NSUInteger *t;     // the booleans, represented by an array of unsigned
  NSUInteger count;
  NSUInteger capacity;  
}
 

- (void)addBoolean:(char)aBoolean;
- (char *)booleansPtr;
- init;
- initFilledWithBoolean:(char)elem count:(NSUInteger)nb; // contract: a return value of nil means not enough memory
- initWithCapacity:(NSUInteger)aNumItems; // contract: a return value of nil means not enough memory
- initWithBooleans:(NSUInteger *)elems count:(NSUInteger)nb;
- initWithBooleansNoCopy:(char *)tab count:(NSUInteger)nb;
- copyWithZone:(NSZone *)zone;
- (void)replaceBooleanAtIndex:(NSUInteger)index withBoolean:(char)aBoolean;
- (enum ArrayRepType)repType;


@end
