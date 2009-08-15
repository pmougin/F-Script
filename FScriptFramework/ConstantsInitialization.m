/* ConstantsInitialisation.m Copyright (c) 1999-2009 Philippe Mougin.  */
/*   This software is open source. See the licence.  */  

#import "ConstantsInitialization.h"
#import "FSInterpreter.h"

#import <Cocoa/Cocoa.h>

void constantsInitialization(NSMutableDictionary *d)
{
  NSString *path;
  NSBundle *bundle = [NSBundle bundleForClass:[FSInterpreter class]];
  NSString *constantsDictionaryFileName = @"constantsDictionary";

  if ((path = [bundle pathForResource:constantsDictionaryFileName ofType:@""]))
  {
    [d addEntriesFromDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:path]]; 
  } 
 
  if (NSMultipleValuesMarker) [d setObject:NSMultipleValuesMarker forKey:@"NSMultipleValuesMarker"]; 
  if (NSNoSelectionMarker)    [d setObject:NSNoSelectionMarker    forKey:@"NSNoSelectionMarker"]; 
  if (NSNotApplicableMarker)  [d setObject:NSNotApplicableMarker  forKey:@"NSNotApplicableMarker"];
  
  if (NSErrorMergePolicy)                      [d setObject:NSErrorMergePolicy                      forKey:@"NSErrorMergePolicy"]; 
  if (NSMergeByPropertyStoreTrumpMergePolicy)  [d setObject:NSMergeByPropertyStoreTrumpMergePolicy  forKey:@"NSMergeByPropertyStoreTrumpMergePolicy"]; 
  if (NSMergeByPropertyObjectTrumpMergePolicy) [d setObject:NSMergeByPropertyObjectTrumpMergePolicy forKey:@"NSMergeByPropertyObjectTrumpMergePolicy"]; 
  if (NSOverwriteMergePolicy)                  [d setObject:NSOverwriteMergePolicy                  forKey:@"NSOverwriteMergePolicy"]; 
  if (NSRollbackMergePolicy)                   [d setObject:NSRollbackMergePolicy                   forKey:@"NSRollbackMergePolicy"]; 
 
  [d setObject:[NSNumber numberWithUnsignedLongLong:NSNotFound]   forKey:@"NSNotFound"];
  [d setObject:[NSNumber numberWithLong:NSIntegerMax]             forKey:@"NSIntegerMax"];
  [d setObject:[NSNumber numberWithLong:NSIntegerMin]             forKey:@"NSIntegerMin"];
  [d setObject:[NSNumber numberWithUnsignedLong:NSUIntegerMax]    forKey:@"NSUIntegerMax"];
  [d setObject:[NSNumber numberWithLong:NSUndefinedDateComponent] forKey:@"NSUndefinedDateComponent"];
}
