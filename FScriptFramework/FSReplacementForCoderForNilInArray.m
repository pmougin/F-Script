//  ReplacementForCoderForNilInArray.m Copyright (c) 2003-2006 Philippe Mougin.
//  This software is open source. See the license.

#import "FSReplacementForCoderForNilInArray.h"

void __attribute__ ((constructor)) initializeFSReplacementForCoderForNilInArray(void) 
{
  [NSKeyedUnarchiver setClass:[FSReplacementForCoderForNilInArray class] forClassName:@"ReplacementForCoderForNilInArray"];
  [NSUnarchiver decodeClassName:@"ReplacementForCoderForNilInArray" asClassName:@"FSReplacementForCoderForNilInArray"];  
}

@implementation FSReplacementForCoderForNilInArray

- (void)encodeWithCoder:(NSCoder *)encoder {}

- (id)initWithCoder:(NSCoder *)decoder { return [super init]; }

@end
