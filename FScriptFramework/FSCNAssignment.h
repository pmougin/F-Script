/*   FSCNAssignment.h Copyright (c) 2008 Philippe Mougin. */
/*   This software is open source. See the license.   */

#import "FSCNBase.h"

@interface FSCNAssignment : FSCNBase 
{
  @public
    FSCNBase *left;
    FSCNBase *right;
}

- (void)dealloc;
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (id)initWithLeft:(FSCNBase *)l right:(FSCNBase *)r;
- (void)translateCharRange:(long)translation;

@end
