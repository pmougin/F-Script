/* FSTestObjCClass2.m Copyright (c) 2008-2009 Philippe Mougin. */ 
/* This software is open source. See the license. */

#import "FSTestObjCClass2.h"


@implementation FSTestObjCClass2

- (id) init
{
  self = [super init];
  if (self != nil) 
  {
    iv__Bool2              = false;
    iv_char2               = NO;
    iv_unsigned_char2      = 0;
    iv_short2              = -1515;
    iv_unsigned_short2     = 1905;
    iv_int2                = 35;
    iv_unsigned_int2       = 1;
    iv_long2               = -1234;
    iv_unsigned_long2      = 99;
    iv_long_long2          = 77;
    iv_unsigned_long_long2 = 789;
    iv_id2                 = @"world";
    iv_Class2              = [NSButton class];
    iv_float2              = 2345;
    iv_double2             = 56.2;
    iv_SEL2                = @selector(between:and:);
    iv_NSRange2            = NSMakeRange(0, 51);
    iv_NSSize2             = NSMakeSize(100, 6.3);
    iv_CGSize2             = CGSizeMake(100, 6.3) ;
    iv_NSPoint2            = NSMakePoint(0, 500);
    iv_CGPoint2            = CGPointMake(0, 500);
    iv_NSRect2             = NSMakeRect(0, 0, 1024, 768);
    iv_CGRect2             = CGRectMake(0, 0, 1024, 768);
    iv_voidPtr2            = NSAllocateCollectable(1,0);  
  }
  return self;
}

- (void) dealloc
{
  [iv_id2 release];
  free(iv_voidPtr2);
  [deallocationProof appendString:@" FSTestObjCClass2 "];
  [super dealloc];
}


- tags 
{
  return [[super tags] arrayByAddingObject:@"FSTestObjCClass2"];
}

/*
- callToSupperFromObjCToFScript
{
  return [super fscriptMethodAddedToObjCClass];
}
*/

@end
