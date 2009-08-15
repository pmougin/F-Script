//  FSInspectorUniquier.h Copyright (c) 2005-2009 Philippe Mougin.
//  This software is open source. See the license.

#import <Cocoa/Cocoa.h>


@interface FSInspectorUniquier : NSObject {

}

+ (void)initialize;
+ (void)addObject:(id)model inspector:(id)inspector;
+ (id)inspectorForObject:(id)model;
+ (void)removeEntryForInspector:(id)inspector;

@end
