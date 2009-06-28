/*   FSNSAffineTransform.h Copyright (c) 2009 Philippe Mougin.  */
/*   This software is open source. See the license.   */  

#import <Cocoa/Cocoa.h>

@interface NSAffineTransform (FSNSAffineTransform)

- (float)m11;
- (float)m12;
- (float)m21;
- (float)m22;
- (void) setM11:(float)m11 m12:(float)m12 m21:(float)m21 m22:(float)m22 tX:(float)tX tY:(float)tY;
- (float)tX;
- (float)tY;

@end
