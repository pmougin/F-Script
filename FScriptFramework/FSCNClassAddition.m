/*   FSCNClassAddition.m Copyright (c) 2008 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import "FSCNClassAddition.h"
#import "FSCNMethod.h"

@implementation FSCNClassAddition

- (NSString *)className 
{ 
  return className; 
}

-(void)dealloc
{
  [className release];
  [methods release];
  [super dealloc];
}

- (NSString *)description
{
  return @"Class addition"; 
}


- (void)encodeWithCoder:(NSCoder *)coder
{  
  [super encodeWithCoder:coder];
  [coder encodeObject:className forKey:@"className"];
  [coder encodeObject:methods   forKey:@"methods"];
}     

- (id) initWithClassName:(NSString *)theClassName methods:(NSArray *)theMethods
{
  self = [super init];
  if (self != nil) 
  {
    nodeType  = CLASS_ADDITION;
    className = [theClassName retain];
    methods   = [theMethods retain];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  className = [[coder decodeObjectForKey:@"className"] retain];
  methods   = [[coder decodeObjectForKey:@"methods"]   retain];  
  return self;
}

- (void)translateCharRange:(long)translation
{
  [super translateCharRange:translation];
  
  for (FSCNMethod *method in methods) 
  {
    [method translateCharRange:translation];
  }
}

@end
