/* FSAirplane.h Copyright (c) 1998-2009 Philippe Mougin. */ 
/* This software is open source. See the license. */

#import <Foundation/Foundation.h>

@interface FSAirplane : NSObject <NSCoding>
{
  id ident;
  id model;
  id capacity;
  id location;
}

////////////////////////////////// User methods ////////////////////////////////

+ (id) airplaneWithIdent:(id)theIdent model:(id)theModel capacity:(id)theCapacity location:(id)theLocation;

- (id)   capacity;
- (void) setCapacity:(id)theCapacity;  
- (id)   ident;
- (void) setIdent:(id)theIdent;
- (id)   location;
- (void) setLocation:(id)theLocation;
- (id)   model;
- (void) setModel:(id)theModel;


////////////////////////////////// Programmer methods ////////////////////////////////

- (void)dealloc;
- (NSString *)description;
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (id) initWithIdent:(id)theIdent model:(id)theModel capacity:(id)theCapacity location:(id)theLocation;

@end
