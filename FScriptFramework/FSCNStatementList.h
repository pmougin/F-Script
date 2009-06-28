/*   FSCNStatementList.h Copyright (c) 2008 Philippe Mougin. */
/*   This software is open source. See the license.   */

#import "FSCNBase.h"


@interface FSCNStatementList : FSCNBase 
{
  @public
    unsigned statementCount;
    __strong FSCNBase **statements;
}

- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)coder;
- (id)initWithStatements:(NSArray *)theStatements;
- (void)translateCharRange:(long)translation;

@end
