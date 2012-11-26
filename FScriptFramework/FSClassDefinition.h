/*   FSClassDefinition.h Copyright (c) 2008-2009 Philippe Mougin. */
/*   This software is open source. See the license.   */

#import <Cocoa/Cocoa.h>

@interface FSClassDefinition : NSObject 
{
@package
  NSMutableArray  *methodHolders;
  NSSet           *ivarNames;
}

+ (id)classDefinition;
- (NSSet *)ivarNames;
- (NSMutableArray *)methodHolders;
- (void)setIvarNames:(NSSet *)theIvarNames;

@end
