/* FSTestObjCClass1.h Copyright (c) 2008-2009 Philippe Mougin. */ 
/* This software is open source. See the license. */

#import <Cocoa/Cocoa.h>


@interface FSTestObjCClass1 : NSObject 
{
  _Bool              iv__Bool;
  char               iv_char;
  unsigned char      iv_unsigned_char;
  short              iv_short;
  unsigned short     iv_unsigned_short;
  int                iv_int;
  unsigned int       iv_unsigned_int;
  long               iv_long;
  unsigned long      iv_unsigned_long;
  long long          iv_long_long;
  unsigned long long iv_unsigned_long_long;
  id                 iv_id;
  Class              iv_Class;
  float              iv_float;
  double             iv_double;
  SEL                iv_SEL;
  NSRange            iv_NSRange;
  NSSize             iv_NSSize;
  CGSize             iv_CGSize;
  NSPoint            iv_NSPoint;
  CGPoint            iv_CGPoint;
  NSRect             iv_NSRect;
  CGRect             iv_CGRect;
  void *             iv_voidPtr;
  
  NSMutableString *deallocationProof;    
}

- (id) init;
- (void) dealloc;
- (id)tags;
- (void) setDeallocationProof:(NSMutableString *)proof;
- (void *) voidPtr;

@end