/* ArrayRepBoolean.h Copyright (c) 1998-2009 Philippe Mougin. */
/*   This software is open source. See the license.       */

#import <Foundation/Foundation.h>
#import "ArrayRep.h"

@interface ArrayRepBoolean : NSObject <ArrayRep>
{
  NSUInteger retainCount;
@public
  char *t;     // the booleans, represented by an array of char
  NSUInteger count;
  NSUInteger capacity;  
}


- (void)addBoolean:(char)aBoolean;
- (char *)booleansPtr;
- (NSUInteger)indexOfObject:(id)anObject inRange:(NSRange)range identical:(BOOL)identical;
- (id)init;
- (id)initFilledWithBoolean:(char)elem count:(NSUInteger)nb; // contract: a return value of nil means not enough memory
- (id)initWithCapacity:(NSUInteger)aNumItems; // contract: a return value of nil means not enough memory
- (id)initWithBooleans:(char *)elems count:(NSUInteger)nb;
- (id)initWithBooleansNoCopy:(char *)tab count:(NSUInteger)nb;
- (id)copyWithZone:(NSZone *)zone;
- (void)replaceBooleanAtIndex:(NSUInteger)index withBoolean:(char)aBoolean;
- (enum ArrayRepType)repType;


@end
