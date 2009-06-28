/* FSInterpreterPrivate.h Copyright (c) 2002-2006 Philippe Mougin.  */
/*   This software is open source. See the license.  */ 

#import "FSInterpreter.h"
#import "FSObjectBrowserButtonCtxBlock.h"

@interface FSInterpreter(FSInterpreterPrivate)

- (FSObjectBrowserButtonCtxBlock *)objectBrowserButtonCtxBlockFromString:(NSString *)source;

@end
