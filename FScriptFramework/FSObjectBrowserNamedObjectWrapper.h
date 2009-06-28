//  FSObjectBrowserNamedObjectWrapper.h Copyright (c) 2005-2009 Philippe Mougin.
//  This software is open source. See the license.

#import <Cocoa/Cocoa.h>


@interface FSObjectBrowserNamedObjectWrapper : NSObject 
{
  NSString *name;
  id object;
}

+ (id)namedObjectWrapperWithObject:(id)theObject name:(NSString *)theName;

- (id)initWithObject:(id)theObject name:(NSString *)theName;
- (id)object;
- (NSString *)description;

@end
