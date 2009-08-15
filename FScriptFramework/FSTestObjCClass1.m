/* FSTestObjCClass1.m Copyright (c) 2008-2009 Philippe Mougin. */ 
/* This software is open source. See the license. */

#import "FSTestObjCClass1.h"


@implementation FSTestObjCClass1


- (id) init
{
  self = [super init];
  if (self != nil) 
  {
    iv__Bool              = true;
    iv_char               = YES;
    iv_unsigned_char      = 5;
    iv_short              = -1972;
    iv_unsigned_short     = 1933;
    iv_int                = -300000;
    iv_unsigned_int       = 987654321;
    iv_long               = 88;
    iv_unsigned_long      = 89;
    iv_long_long          = -123;
    iv_unsigned_long_long = 1500400300;
    iv_id                 = @"hello";
    iv_Class              = [NSView class];
    iv_float              = 3;
    iv_double             = -1.23;
    iv_SEL                = @selector(init);
    iv_NSRange            = NSMakeRange(2, 10);
    iv_NSSize             = NSMakeSize(200.3, 400.25);
    iv_CGSize             = CGSizeMake(200.3, 400.25) ;
    iv_NSPoint            = NSMakePoint(100, 200);
    iv_CGPoint            = CGPointMake(100, 200);
    iv_NSRect             = NSMakeRect(5, 5, 640, 480);
    iv_CGRect             = CGRectMake(5, 5, 640, 480);
    iv_voidPtr            = NSAllocateCollectable(1,0);  
  }
  return self;
}

- (void) dealloc
{
  [iv_id release];
  free(iv_voidPtr);
  [deallocationProof appendString:@" FSTestObjCClass1 "];
  [deallocationProof release];
  [super dealloc];
}

- (void *) voidPtr
{
  return iv_voidPtr;
}

- tags 
{
  return [NSArray arrayWithObject:@"FSTestObjCClass1"];
}


- (NSMutableString *)deallocationProof
{
  return deallocationProof;
}

- (void) setDeallocationProof:(NSMutableString *)proof
{
  [proof retain];
  [deallocationProof release];
  deallocationProof = proof;
}

@end
