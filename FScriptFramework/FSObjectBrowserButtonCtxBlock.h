/*   FSObjectBrowserButtonCtxBlock.h Copyright (c) 2002-2009 Philippe Mougin.  */
/*   This software is open source. See the license.                  */  

#import <Foundation/Foundation.h>
#import "BlockPrivate.h"

@interface FSObjectBrowserButtonCtxBlock : FSBlock 
{
  FSBlock *master; 
}

- (void)dealloc;
- (BlockInspector *)inspector;  
- (void)setMaster:(FSBlock *)theMaster;

@end
