/*   FSNSAffineTransform.m Copyright (c) 2009 Philippe Mougin.  */
/*   This software is open source. See the license.   */  

#import "FSNSAffineTransform.h"

@implementation NSAffineTransform (FSNSAffineTransform)

- (float)m11 { return [self transformStruct].m11; }

- (float)m12 { return [self transformStruct].m12; }

- (float)m21 { return [self transformStruct].m21; }

- (float)m22 { return [self transformStruct].m22; }

- (void) setM11:(float)m11 m12:(float)m12 m21:(float)m21 m22:(float)m22 tX:(float)tX tY:(float)tY
{
  [self setTransformStruct:(NSAffineTransformStruct){m11, m12, m21, m22, tX, tY}];
}

- (float)tX { return [self transformStruct].tX; }

- (float)tY { return [self transformStruct].tY; }

@end
