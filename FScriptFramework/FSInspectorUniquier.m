//  FSInspectorUniquier.m Copyright (c) 2005-2009 Philippe Mougin.
//  This software is open source. See the license.

#import "FSInspectorUniquier.h"

static NSMutableArray *inspectedObjects;
static NSMutableArray *inspectors;

@implementation FSInspectorUniquier

+ (void)initialize
{
  static BOOL tooLate = NO;
  if ( !tooLate ) 
  {
    inspectedObjects = [[NSMutableArray alloc] init]; 
    inspectors       = [[NSMutableArray alloc] init]; 
    tooLate = YES;
  }
}

+ (void)addObject:(id)inspectedObject inspector:(id)inspector
{
  [inspectedObjects addObject:inspectedObject];
  [inspectors       addObject:inspector];
}

+ (id)inspectorForObject:(id)inspectedObject
{
  NSUInteger index = [inspectedObjects indexOfObject:inspectedObject];
  if (index == NSNotFound) return nil;
  else return [inspectors objectAtIndex:index];
}

+ (void)removeEntryForInspector:(id)inspector
{
  NSUInteger index = [inspectors indexOfObject:inspector];
  [inspectors       removeObjectAtIndex:index];
  [inspectedObjects removeObjectAtIndex:index];  
}

@end
