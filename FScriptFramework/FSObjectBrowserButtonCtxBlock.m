/*   FSObjectBrowserButtonCtxBlock.m Copyright (c) 2002-2009 Philippe Mougin.  */
/*   This software is open source. See the license.                  */ 

#import "FSObjectBrowserButtonCtxBlock.h"


@implementation FSObjectBrowserButtonCtxBlock

- (void)dealloc
{
  //NSLog(@"FSObjectBrowserButtonCtxBlock dealloc"); 
  [master release];
  [super dealloc];
}  

- (BlockInspector *)inspector { return [master inspector]; } 

- (void) setMaster:(FSBlock *)theMaster
{
  [theMaster retain];
  [master release];
  master = theMaster;
}

@end
