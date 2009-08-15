/*   FScriptIBPlugin.m Copyright (c) 2007-2009 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import "FScriptIBPlugin.h"
 
@implementation FScriptIBPlugin

- (NSString *)label { return @"F-Script"; }

- (NSArray *)libraryNibNames { return [NSArray arrayWithObject:@"FScriptIBPluginLibrary"]; }

/*
- (void)document:(IBDocument *)document didAddDraggedObjects:(NSArray *)roots fromDraggedLibraryView:(NSView *)view;
{
  if (view == fsMenuItemView)
  { 
    
  }
//- (void)connectAction:(NSString *)selectorName ofSourceObject:(id)source toDestinationObject:(id)destination;
}
*/


- (NSArray*)requiredFrameworks
{	
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"FScript" ofType:@"framework"]];
    return [NSArray arrayWithObject:frameworkBundle];
}

@end
