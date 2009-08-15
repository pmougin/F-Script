/*   DOTest.h Copyright (c) 2001-2009 Philippe Mougin.   */
/*   This software is open source. See the license. */  

#import <Foundation/Foundation.h>


@interface DOTest : NSObject 
{
  id object;
}


-(void)setObject:(id)theObject;
-(void)setObjectByCopy:(bycopy id)theObject;

@end
