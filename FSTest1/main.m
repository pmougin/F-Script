#import <Cocoa/Cocoa.h>
#import "DOCustom.h"

int main(int argc, const char *argv[])
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSString *o1 = @"hello";
  DOCustom *o2 = [[DOCustom alloc] init];
  NSConnection *connection1 = [[NSConnection alloc] init];
  NSConnection *connection2 = [[NSConnection alloc] init];
  
  [connection1 setRootObject:o1];
  if ([connection1 registerName:@"FSTest1_o1"] == NO) 
  { 
    [connection1 release];
    NSLog(@"FSTest1 error: unable to register the object");
  }
   
  [connection2 setRootObject:o2];
  if ([connection2 registerName:@"FSTest1_o2"] == NO)
  {
    [connection2 release];
    NSLog(@"FSTest1 error: unable to register the object");
  }
  
  [pool release];

  return NSApplicationMain(argc, argv);
}
