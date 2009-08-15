/* FSFlight.h Copyright (c) 1998-2009 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import <Foundation/Foundation.h>

@interface FSFlight : NSObject <NSCoding>
{
  id ident;
  id pilot;
  id airplane;
  id departureDate;
  id arrivalDate;
  id departureLocation;
  id arrivalLocation;
}

////////////////////////////////// User methods ////////////////////////////////

+ (id) flightWithIdent:(id)theIdent pilot:(id)thePilot airplane:(id)theAirplane departureDate:(id)theDepartureDate arrivalDate:(id)theArrivalDate departureLocation:(id)theDepartureLocation arrivalLocation:(id)theArrivalLocation;

- (id)   airplane;
- (void) setAirplane:(id)theAirplane;  
- (id)   arrivalDate;
- (void) setArrivalDate:(id)theArrivalDate;
- (id)   arrivalLocation;
- (void) setArrivalLocation:(id)theArrivalLocation;
- (id)   departureDate;
- (void) setDepartureDate:(id)theDepartureDate;
- (id)   departureLocation;
- (void) setDepartureLocation:(id)theDepartureLocation;
- (id)   ident;
- (void) setIdent:(id)theIdent;
- (id)   pilot;
- (void) setPilot:(id)thePilot;


////////////////////////////////// Programmer methods ////////////////////////////////

- (void)dealloc;
- (NSString *)description;
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (id) initWithIdent:(id)theIdent pilot:(id)thePilot airplane:(id)theAirplane departureDate:(id)theDepartureDate arrivalDate:(id)theArrivalDate departureLocation:(id)theDepartureLocation arrivalLocation:(id)theArrivalLocation;


@end
