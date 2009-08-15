/* FSArchiver.h Copyright (c) 2001-2009 Philippe Mougin.  */
/*   This software is open source. See the license.  */

#import <Foundation/Foundation.h>


@interface FSArchiver : NSArchiver 
{}

- (void)encodeValueOfObjCType:(const char *)valueType at:(const void *)address;

@end
