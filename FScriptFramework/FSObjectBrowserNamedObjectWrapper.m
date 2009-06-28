//  FSObjectBrowserNamedObjectWrapper.m Copyright (c) 2005-2009 Philippe Mougin.
//  This software is open source. See the license.

#import "FSObjectBrowserNamedObjectWrapper.h"

@implementation FSObjectBrowserNamedObjectWrapper

+ (id)namedObjectWrapperWithObject:(id)theObject name:(NSString *)theName
{
  return [[[self alloc] initWithObject:theObject name:theName] autorelease];
}

- (void)dealloc
{
  [name release];
  [object release];
  [super dealloc];
}

- (id)initWithObject:(id)theObject name:(NSString *)theName
{
  if ((self = [super init]))
  {
    object = [theObject retain];
    name = [theName retain];
    return self;
  }
  return nil;
}

- (id)object { return object; }

- (NSString *)description
{
  return name;
}

@end
