/* FSPilot.h Copyright (c) 1998-2009 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import <Foundation/Foundation.h>

@interface FSPilot : NSObject <NSCoding>
{
  id name;
  id address;
  id salary;
  id age;
}

////////////////////////////////// User methods ////////////////////////////////

+ (id) pilotWithName:(id)theName address:(id)theAddress salary:(id)theSalary;
+ (id) pilotWithName:(id)theName address:(id)theAddress salary:(id)theSalary age:(id)theAge;

- (id)   address;
- (void) setAddress:(id)theAddress; 
- (id)   age;
- (void) setAge:(id)theAge;   
- (id)   name;
- (void) setName:(id)theName;
- (id)   salary;
- (void) setSalary:(id)theSalary;

- (void) sendMail:(NSString *)mailContent;

////////////////////////////////// Other methods ////////////////////////////////

- (void)dealloc;
- (NSString *)description;
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (id) initWithName:(id)theName address:(id)theAddress salary:(id)theSalary;
- (id) initWithName:(id)theName address:(id)theAddress salary:(id)theSalary age:(id)theAge;;


@end
