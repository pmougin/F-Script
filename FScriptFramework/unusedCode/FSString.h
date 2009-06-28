/*   FSString.h Copyright 1998,1999 Philippe Mougin.  */
/*   This software is Open Source. See the license.  */  

// Note : this file is named FSString.h instead of String.h because of a conflict when compiling on OSXPB1

#import <Foundation/Foundation.h>
#import <Foundation/NSString.h>
#import <Foundation/NSDate.h>

#import "FSNSString.h"

@class Number;
@class Array;
@class FSBoolean;

@interface String:NSMutableString 
{
  NSMutableString *rep;
  NSUInteger retainCount;
}

//////////////  USER METHODS

- (Array *) asArrayOfCharacters;
- (Array *) asArray;
- (Block *) asBlock;
- (Block *) asBlockOnError:(Block *)errorBlock;
- (id)asClass;
- (NSDate *) asDate;
- (NSString *) capitalizedString; // return a String object (not a NSString) but conforms to the declaration of the method in the superclass (return type NSString *)
- (id) connect;
- (id) connectOnHost:(String *)operand2;
- (String*) dup;
- (void)insert:(String *)str at:(Number*)index;
- (String *)max:(String *)operand2;
- (String *)min:(String *)operand2; 

- (String *)operator_plus_plus:(String *)operand2;
- (FSBoolean *)operator_greater:(String *)operand2;
- (FSBoolean *)operator_greater_equal:(String *)operand2;
- (FSBoolean *)operator_less:(id)operand2;  
- (FSBoolean *)operator_less_equal:(String *)operand2;  
- (String *)operator_period:(Number *)operand2;

- (id)reverse;
- (void)setValue:(id)operand2;
- (Number *)size;
- (String *) uppercase;

///////////////  OTHER METHODS

+ (String *)stringWithCapacity:(NSUInteger)capacity;
+ (String *)stringWithCharacters:(const unichar *)characters length:(NSUInteger)length;
+ (String *)stringWithContentsOfFile:(NSString *)filename;
+ (String *)stringWithCString:(const char *)bytes length:(NSUInteger)length;
+ (String *)stringWithCString:(const char *)bytes;
#warning 64BIT: Check formatting arguments
+ (String *)stringWithFormat:(NSString *)format, ...;
+ (String *)stringWithString:(NSString *)string;

- copy;
- (void)dealloc;
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (String *)printString;
- setCString:(const char*)cstr;
- (void)setValue:(String*)val;

@end
