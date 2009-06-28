/* FSConstantListBuilder.h Copyright (c) 2002-2006 Philippe Mougin.  */
/*   This software is open source. See the licence.  */  

#import <Foundation/Foundation.h>
 

@interface FSConstantListBuilder : NSObject
{
  NSMutableString *constantsInitializerString;
}

-(void)analyseFileAtPath:(NSString *)path;
-(void)analyseDirectoryAtPath:(NSString *)path;
-(NSString *)constantsInitializerString;

@end
