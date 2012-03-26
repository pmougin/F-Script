/*   ExecutionControl.m Copyright (c) 1998-2001 Philippe Mougin.  */
/*   This software is Open Source. See the license.  */  

#import "ExecutionControl.h"
#import "ExecEngine.h"
#import <Foundation/Foundation.h>
#import "FSVoid.h"
#import "Block.h"
#import "FScriptFunctions.h"
#import "FSVoidPrivate.h"

@implementation ExecutionControl

+ (void)initialize
{
    static BOOL tooLate = NO;
    if ( !tooLate ) {
        tooLate = YES;
    }
}

+ executionControlWithExecEngine:(ExecEngine *)e block:(Block*)b
{
  return [[[self alloc] initWithExecEngine:e block:b] autorelease];
}

- copy
{ return [self copyWithZone:NULL]; }

- copyWithZone:(NSZone *)zone
{ 
  return [[ExecutionControl allocWithZone:zone] initWithExecEngine:execEngine block:block];
}

- (void)dealloc
{
  [execEngine release];
  [block release];
  [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
  [coder encodeConditionalObject:execEngine];
  [coder encodeConditionalObject:block];
}

- (ExecEngine *)execEngine
{ return execEngine; }

- (void)executionDidEnd
{
  [block release]     ; block      = nil;       
  [execEngine release]; execEngine = nil;
}

- initWithExecEngine:(ExecEngine *)e block:(Block*)b
{
  if ((self = [super init]))
  {
    execEngine = [e retain];
    block = [b retain];
    return self;
  }
  return nil;    
}

- (id)initWithCoder:(NSCoder *)coder
{
  execEngine = [[coder decodeObject] retain];
  block      = [[coder decodeObject] retain];
  return self;
}

///////////////////////////////// USER METHODS ////////////////////////

- (Block*) block
{ return block; }

- (ExecutionControl*) clone
{ return [[self copy] autorelease];}

- (ExecutionControl*) dup
{ return [[self copy] autorelease];}

- (void) return
{ [self return:fsVoid]; } 

- (void) return:(id)returnValue
{ 
  if (!execEngine)
    FSExecError(@"receiver of method \"return\" or \"return:\" is an ExecutionControl whose execution is already finished");
    
  [execEngine return:returnValue];    
}

- (void)setValue:(id)operand2;
{ 
  FSVerifClassArgsNoNil(@"setValue:",1,operand2,[ExecutionControl class]);
  [execEngine autorelease];
  [block autorelease];
  execEngine = [[operand2 execEngine] retain];
  block      = [[operand2 block] retain];
}


@end
