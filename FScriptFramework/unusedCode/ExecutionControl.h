/*   ExecutionControl.h Copyright (c) 1998-2001 Philippe Mougin.  */
/*   This software is Open Source. See the license.           */   

#import "FSNSObject.h"

@class ExecEngine;
@class Block;

@interface ExecutionControl : NSObject <NSCopying , NSCoding>
{
  ExecEngine *execEngine;
  Block *block;
}

+ executionControlWithExecEngine:(ExecEngine *)e block:(Block*)b;
+ (void)initialize;

- copy;
- copyWithZone:(NSZone *)zone;
- (void)dealloc;
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (ExecEngine *)execEngine;
- (void)executionDidEnd;
- initWithExecEngine:(ExecEngine *)e block:(Block*)b;
- (id)initWithCoder:(NSCoder *)aDecoder;

///////////////////////////////// USER METHODS ////////////////////////

- (Block*) block;
- (ExecutionControl*) clone;
- (ExecutionControl*) dup;
- (void) return;
- (void) return:(id)rv;
- (void)setValue:(id)operand2;

@end
