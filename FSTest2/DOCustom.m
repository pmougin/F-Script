
#import <Foundation/Foundation.h>
#import "DOCustom.h"

@implementation DOCustom : NSObject

-(NSInteger)echoInt:(NSInteger)arg
{
  return arg;
}

- (NSInteger) getValue
{
  return i;
}

- (byref NSArray*)getNSArrayByRef
{
  return [NSArray arrayWithObjects:[NSScanner scannerWithString:@"hello"], [NSProcessInfo processInfo], nil];
}

- (byref NSNumber*)getNSNumberByRef
{
  return [NSNumber numberWithDouble:30]; 
}

- (byref NSString*)getNSStringByRef
{
  return @"I am an NSString passed by ref";
}

- (void) incr
{
  i++;
}

-(BOOL)isEqual:(id)object
{
  return [object isKindOfClass:[DOCustom class]] && i == [object getValue];
}

-(id)perform:(SEL)selector on:(id)target with:(id)argument
{
  return [target performSelector:selector withObject:argument];
}

-(oneway void) quit
{
  exit(0);
}

-(void) setValue:(NSInteger)value
{
  i = value;
}

- testTimeout
{
  while(1);
}

- (id) testStr
{
  return @"toto";
}

-(SEL) test2
{
  return @selector(class);
}

@end

