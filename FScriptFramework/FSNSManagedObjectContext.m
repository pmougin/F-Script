/* FSNSManagedObjectContext.m Copyright (c) 2005-2009 Philippe Mougin.  */
/*   This software is open source. See the license.  */ 

#import "FSNSManagedObjectContext.h"
#import "FSManagedObjectContextInspector.h"
#import "FScriptFunctions.h"
#import "FSSystemPrivate.h"

@implementation NSManagedObjectContext(FSNSManagedObjectContext)

- (void)inspectWithSystem:(FSSystem *)system
{
  FSVerifClassArgsNoNil(@"inspectWithSystem:",1,system,[FSSystem class]);
  if (![system interpreter]) FSExecError(@"Sorry, can't open the inspector because there is no FSInterpreter associated with the FSSystem object passed as argument");

  [FSManagedObjectContextInspector managedObjectContextInspectorWithmanagedObjectContext:self interpreter:[system interpreter]];
}


@end
