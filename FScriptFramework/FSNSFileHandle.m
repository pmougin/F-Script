/*   FSNSFileHandle.m Copyright (c) 2009 Philippe Mougin.  */
/*   This software is open source. See the license.        */  

#import "FSNSFileHandle.h"


@implementation NSFileHandle (FSNSFileHandle)

- (void) print:(NSString *)string
{
  [self writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
