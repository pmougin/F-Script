/* FSFlight.m Copyright (c) 1998-2009 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import "FSFlight.h"

@implementation FSFlight    


////////////////////////////////// User methods ////////////////////////////////

+ (id) flightWithIdent:(id)theIdent pilot:(id)thePilot airplane:(id)theAirplane departureDate:(id)theDepartureDate arrivalDate:(id)theArrivalDate departureLocation:(id)theDepartureLocation arrivalLocation:(id)theArrivalLocation
{
  return [[[self alloc] initWithIdent:theIdent pilot:thePilot airplane:theAirplane departureDate:theDepartureDate arrivalDate:theArrivalDate departureLocation:theDepartureLocation arrivalLocation:theArrivalLocation] autorelease];
} 

- (id)   airplane                    {return airplane;}
- (void) airplane:(id)theAirplane    {[theAirplane retain]; [airplane release]; airplane = theAirplane ;}
- (void) setAirplane:(id)theAirplane {[theAirplane retain]; [airplane release]; airplane = theAirplane ;}
   
- (id)   arrivalDate                       {return arrivalDate;}
- (void) arrivalDate:(id)theArrivalDate    {[theArrivalDate retain]; [arrivalDate release]; arrivalDate = theArrivalDate ;}
- (void) setArrivalDate:(id)theArrivalDate {[theArrivalDate retain]; [arrivalDate release]; arrivalDate = theArrivalDate ;}

- (id)   arrivalLocation                           {return arrivalLocation;}
- (void) arrivalLocation:(id)theArrivalLocation    {[theArrivalLocation retain]; [arrivalLocation release]; arrivalLocation = theArrivalLocation;}
- (void) setArrivalLocation:(id)theArrivalLocation {[theArrivalLocation retain]; [arrivalLocation release]; arrivalLocation = theArrivalLocation;}

- (id)   departureDate                         {return departureDate;}
- (void) departureDate:(id)theDepartureDate    {[theDepartureDate retain]; [departureDate release]; departureDate = theDepartureDate;}
- (void) setDepartureDate:(id)theDepartureDate {[theDepartureDate retain]; [departureDate release]; departureDate = theDepartureDate;}

- (id)   departureLocation                             {return departureLocation;}
- (void) departureLocation:(id)theDepartureLocation    {id old = departureLocation; departureLocation = [theDepartureLocation retain]; [old release];}
- (void) setDepartureLocation:(id)theDepartureLocation {[theDepartureLocation retain]; [departureLocation release]; departureLocation = theDepartureLocation;}

- (id)   ident                 {return ident;}
- (void) ident:(id)theIdent    {id old = ident; ident = [theIdent retain]; [old release];} 
- (void) setIdent:(id)theIdent {[theIdent retain]; [ident release]; ident = theIdent;} 

- (id)   pilot                 {return pilot;}
- (void) pilot:(id)thePilot    {id old = pilot; pilot = [thePilot retain]; [old release];}
- (void) setPilot:(id)thePilot {[thePilot retain]; [pilot release]; pilot = thePilot;}


////////////////////////////////// Programmer methods ////////////////////////////////

- (id)copyWithZone:(NSZone *)zone
{
  return [[[self class] allocWithZone:zone] initWithIdent:ident pilot:pilot airplane:airplane departureDate:departureDate arrivalDate:arrivalDate departureLocation:departureLocation arrivalLocation:arrivalLocation];
}

-(void) dealloc
{
  [ident release];               
  [pilot release];          
  [airplane release];      
  [departureDate release];    
  [arrivalDate release];  
  [departureLocation release];
  [arrivalLocation release]; 
  [super dealloc];
}

- (NSString *)description
{ return [NSString stringWithFormat:@"FSFlight(id=%@, pil=%@, plane=%@, dep=%@, arr=%@, dep=%@, arr=%@)",ident,[pilot name],[airplane ident],departureDate,arrivalDate, departureLocation, arrivalLocation];}  

-(void) encodeWithCoder:(NSCoder *)coder
{
  if ([coder allowsKeyedCoding]) 
  {
    [coder encodeObject:ident forKey:@"FSFlight ident"];
    [coder encodeObject:pilot forKey:@"FSFlight pilot"];
    [coder encodeObject:airplane forKey:@"FSFlight airplane"];
    [coder encodeObject:departureDate forKey:@"FSFlight departureDate"];
    [coder encodeObject:arrivalDate forKey:@"FSFlight arrivalDate"];
    [coder encodeObject:departureLocation forKey:@"FSFlight departureLocation"];
    [coder encodeObject:arrivalLocation forKey:@"FSFlight arrivalLocation"];
  }
  else
  {
    [coder encodeObject:ident];
    [coder encodeObject:pilot];
    [coder encodeObject:airplane];
    [coder encodeObject:departureDate];
    [coder encodeObject:arrivalDate];
    [coder encodeObject:departureLocation];
    [coder encodeObject:arrivalLocation];
  }  
} 

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super init];
  if ([coder allowsKeyedCoding]) 
  {
    ident             = [[coder decodeObjectForKey:@"FSFlight ident"] retain];
    pilot             = [[coder decodeObjectForKey:@"FSFlight pilot"] retain];
    airplane          = [[coder decodeObjectForKey:@"FSFlight airplane"] retain];
    departureDate     = [[coder decodeObjectForKey:@"FSFlight departureDate"] retain];
    arrivalDate       = [[coder decodeObjectForKey:@"FSFlight arrivalDate"] retain];
    departureLocation = [[coder decodeObjectForKey:@"FSFlight departureLocation"] retain];
    arrivalLocation   = [[coder decodeObjectForKey:@"FSFlight arrivalLocation"] retain];
  }
  else
  {
    ident             = [[coder decodeObject] retain];
    pilot             = [[coder decodeObject] retain];
    airplane          = [[coder decodeObject] retain];
    departureDate     = [[coder decodeObject] retain];
    arrivalDate       = [[coder decodeObject] retain];
    departureLocation = [[coder decodeObject] retain];
    arrivalLocation   = [[coder decodeObject] retain];
  }  

  return self;
}  

- (id) initWithIdent:(id)theIdent pilot:(id)thePilot airplane:(id)theAirplane departureDate:(id)theDepartureDate arrivalDate:(id)theArrivalDate departureLocation:(id)theDepartureLocation arrivalLocation:(id)theArrivalLocation
{
  if ((self = [super init]))
  {
    [self setIdent:theIdent];
    [self setPilot:thePilot];
    [self setAirplane:theAirplane];
    [self setDepartureDate:theDepartureDate];
    [self setArrivalDate:theArrivalDate];
    [self setDepartureLocation:theDepartureLocation];
    [self setArrivalLocation:theArrivalLocation];
    return self;
  }
  return nil;
}

@end
