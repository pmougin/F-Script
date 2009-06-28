/* ArrayRepBoolean.h Copyright (c) 1998-2006 Philippe Mougin. */
/*   This software is open source. See the license.       */

#import <Foundation/Foundation.h>
#import "ArrayRep.h"

/*typedef union
{
  vector bool char vec;
  BOOL elements[16];
} booleanVector;*/

@interface ArrayRepBoolean : NSObject /*<ArrayRep> */
{
  NSUInteger retainCount;
@public
  char *t;     // the booleans, represented by an array of chars
  NSUInteger count;
  NSUInteger capacity;  
}

- (void)addBoolean:(char)aBoolean;
- (char *)booleansPtr;
- init;
- initFilledWithBoolean:(char)elem count:(NSUInteger)nb; // contract: a return value of nil means not enough memory
- initWithCapacity:(NSUInteger)aNumItems; // contract: a return value of nil means not enough memory
- initWithBooleans:(char *)elems count:(NSUInteger)nb;
- initWithBooleansNoCopy:(char *)tab count:(NSUInteger)nb;
- copyWithZone:(NSZone *)zone;
- (void)replaceBooleanAtIndex:(NSUInteger)index withBoolean:(char)aBoolean;
- (enum ArrayRepType)repType;

@end
