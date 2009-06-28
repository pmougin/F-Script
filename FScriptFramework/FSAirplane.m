/* FSAirplane.m Copyright (c) 1998-2006 Philippe Mougin.  */
/*   This software is open source. See the license.  */  
 
#import "FSAirplane.h"

@implementation FSAirplane  
   
////////////////////////////////// User methods ////////////////////////////////

+ (id) airplaneWithIdent:(id)theIdent model:(id)theModel capacity:(id)theCapacity location:(id)theLocation
{  
  return [[[self alloc] initWithIdent:theIdent model:theModel capacity:theCapacity location:theLocation] autorelease];
}

- (id)   capacity                    {return capacity;}
- (void) capacity:(id)theCapacity    {[theCapacity retain]; [capacity release]; capacity = theCapacity ;}   
- (void) setCapacity:(id)theCapacity {[theCapacity retain]; [capacity release]; capacity = theCapacity ;}   


- (id)   ident                 {return ident;}
- (void) ident:(id)theIdent    {[theIdent retain]; [ident release]; ident = theIdent ;} 
- (void) setIdent:(id)theIdent {[theIdent retain]; [ident release]; ident = theIdent ;} 

- (id)   location                    {return location;}
- (void) location:(id)theLocation    {[theLocation retain]; [location release]; location = theLocation ;}
- (void) setLocation:(id)theLocation {[theLocation retain]; [location release]; location = theLocation ;}


- (id)   model                 {return model;}
- (void) model:(id)theModel    {[theModel retain]; [model release]; model = theModel ;}
- (void) setModel:(id)theModel {[theModel retain]; [model release]; model = theModel ;}


////////////////////////////////// Programmer methods ////////////////////////////////

- (id)copyWithZone:(NSZone *)zone
{
  return [[[self class] allocWithZone:zone] initWithIdent:ident model:model capacity:capacity location:location];
}

- (void) dealloc
{
  [ident release];
  [model release];
  [capacity release]; 
  [location release];
  [super dealloc];
}

- (NSString *)description
{ return [NSString stringWithFormat:@"FSAirplane(ident = %@, model = %@, capacity = %@, location = %@)",ident,model,capacity,location];}  

- (void)encodeWithCoder:(NSCoder *)coder
{
  if ( [coder allowsKeyedCoding] ) 
  {
    [coder encodeObject:ident    forKey:@"FSAirplane ident"];
    [coder encodeObject:model    forKey:@"FSAirplane model"];
    [coder encodeObject:capacity forKey:@"FSAirplane capacity"];
    [coder encodeObject:location forKey:@"FSAirplane location"];
  }
  else
  {
    [coder encodeObject:ident];
    [coder encodeObject:model];
    [coder encodeObject:capacity];
    [coder encodeObject:location];
  }  
} 

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super init];
 
  if ( [coder allowsKeyedCoding] ) 
  {
    ident     = [[coder decodeObjectForKey:@"FSAirplane ident"] retain];
    model     = [[coder decodeObjectForKey:@"FSAirplane model"] retain];
    capacity  = [[coder decodeObjectForKey:@"FSAirplane capacity"] retain];
    location  = [[coder decodeObjectForKey:@"FSAirplane location"] retain];  
  }
  else
  {
    ident     = [[coder decodeObject] retain];
    model     = [[coder decodeObject] retain];
    capacity  = [[coder decodeObject] retain];
    location  = [[coder decodeObject] retain];  
  }  
  return self;
}   

- (id) initWithIdent:(id)theIdent model:(id)theModel capacity:(id)theCapacity location:(id)theLocation
{
  if ((self = [super init]))
  {
    [self setIdent:theIdent];
    [self setModel:theModel];
    [self setCapacity:theCapacity];
    [self setLocation:theLocation];
    return self;
  }
  return nil;
}

@end
