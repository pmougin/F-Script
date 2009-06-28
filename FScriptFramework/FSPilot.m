/* FSPilot.m Copyright (c) 1998-2006 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import "FSPilot.h"

@implementation FSPilot


////////////////////////////////// User methods ////////////////////////////////

+ (id) pilotWithName:(id)theName address:(id)theAddress salary:(id)theSalary
{
  return [[[self alloc] initWithName:theName address:theAddress salary:theSalary] autorelease];
}

+ (id) pilotWithName:(id)theName address:(id)theAddress salary:(id)theSalary age:(id)theAge
{
  return [[[self alloc] initWithName:theName address:theAddress salary:theSalary age:theAge] autorelease];
}

- (id)   address                   {return address;}
- (void) address:(id)theAddress    {[theAddress retain]; [address release]; address = theAddress;}   
- (void) setAddress:(id)theAddress {[theAddress retain]; [address release]; address = theAddress;}

- (id)   age               {return age;}
- (void) setAge:(id)theAge {[theAge retain]; [age release]; age = theAge;}
   
- (id)   salary                  {return salary;}
- (void) salary:(id)theSalary    {[theSalary retain]; [salary release]; salary = theSalary;}
- (void) setSalary:(id)theSalary {[theSalary retain]; [salary release]; salary = theSalary;}

- (id)   name                {return name;}
- (void) name:(id)theName    {id old = name; name = [theName retain]; [old release];}
- (void) setName:(id)theName {[theName retain]; [name release]; name = theName;}

- (void) sendMail:(NSString *)mailContent
{
  NSLog(@"The folowing mail has been sent to pilot %@: %@", [self name], mailContent);
}


////////////////////////////////// Other methods ////////////////////////////////

+ (void)initialize 
{
  static BOOL tooLate = NO;
  if ( !tooLate )
  {
    [self setVersion:1];
    tooLate = YES; 
  }
}  

- (id)copyWithZone:(NSZone *)zone
{
  return [[[self class] allocWithZone:zone] initWithName:name address:address salary:salary age:age];
}

- (void) dealloc
{
  [name release];
  [address release];
  [salary release];
  [age release];
  [super dealloc];
}

- (NSString *)description
{ return [NSString stringWithFormat:@"FSPilot(name = %@, address = %@, salary = %@, age= %@)", name, address, salary, age];}  

- (void)encodeWithCoder:(NSCoder *)coder
{
  if ([coder allowsKeyedCoding]) 
  {
    [coder encodeObject:name    forKey:@"name"];
    [coder encodeObject:address forKey:@"address"];
    [coder encodeObject:salary  forKey:@"salary"];
    [coder encodeObject:age     forKey:@"age"];
  }
  else
  {
    [coder encodeObject:name];
    [coder encodeObject:address];
    [coder encodeObject:salary];
    [coder encodeObject:age];
  }  
} 

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super init];
  if ([coder allowsKeyedCoding]) 
  {
    name     = [[coder decodeObjectForKey:@"name"]    retain];
    address  = [[coder decodeObjectForKey:@"address"] retain];
    salary   = [[coder decodeObjectForKey:@"salary"]  retain];
    age      = [[coder decodeObjectForKey:@"age"]     retain];  
  }
  else
  {
    name     = [[coder decodeObject] retain];
    address  = [[coder decodeObject] retain];
    salary   = [[coder decodeObject] retain];
    age      = [[coder decodeObject] retain];
  }  
  return self;
}  

- (id) initWithName:(id)theName address:(id)theAddress salary:(id)theSalary
{
  return [self initWithName:theName address:theAddress salary:theSalary age:nil];
}

- (id) initWithName:(id)theName address:(id)theAddress salary:(id)theSalary age:(id)theAge
{
  if ((self = [super init]))
  {
    [self setName:theName];
    [self setAddress:theAddress];
    [self setSalary:theSalary];
    [self setAge:theAge];
    return self;
  }
  return nil;
}

@end
