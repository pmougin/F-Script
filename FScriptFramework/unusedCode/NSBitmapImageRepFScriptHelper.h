//
//  NSBitmapImageRepFScriptHelper.h
//  NSBitmapImageRepFScriptHelper
//
//  Created by Philippe Mougin on Thu Jun 12 2003-2004.
//  Copyright (c) 2003-2004 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSBitmapImageRep(NSBitmapImageRepFScriptHelper)

-(NSArray *)bitmapDataAsArray;
-(void)setBitmapDataFromArray:(NSArray *)bitmapArray;

@end
