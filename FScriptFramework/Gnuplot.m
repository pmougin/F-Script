/* Gnuplot.m Copyright (c) 2003-2009 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import "Gnuplot.h"
#import "FSMiscTools.h"
#include <unistd.h>
#import "FScriptFunctions.h"

void plotFileAtPath(NSString *path, NSString *options)
{
  NSDictionary *errorInfo;
  NSAppleScript *as;
  NSMutableString *command;
  command = [NSMutableString stringWithString:@"tell application \"gnuplot-3.7.1d\"\n activate\n exec \"plot \\\""];
  [command appendString:path];  
  [command appendString:@"\\\" "];
  [command appendString:options];
  [command appendString:@"\"\n end tell"];
  as = [[[NSAppleScript alloc] initWithSource:command] autorelease];
  if ([as executeAndReturnError:&errorInfo] == nil)
  {
    FSExecError([errorInfo objectForKey:NSAppleScriptErrorMessage]);
  }
}


@implementation Gnuplot

+ (void)plotX:(NSArray *)x y:(NSArray *)y options:(NSString *)options
{
  NSUInteger i, count;
  FILE *file;
  char *path = malloc(30);
  [NSData dataWithBytesNoCopy:path length:30];
  // In order to ensure that it will be freed even if an exception is raised during the method, we give 
  // the ownership of the memory allocated for "path" to an autoreleased NSData object.
  strcpy(path,"/tmp/temp.XXXXXX");
  path = mktemp(path);
  file = fopen(path,"w");
  for (i = 0, count = [y count]; i < count; i++)
  {
    id xObject = [x objectAtIndex:i];
    id yObject = [y objectAtIndex:i];
    if ([yObject isKindOfClass:[NSNumber class]] && [xObject isKindOfClass:[NSNumber class]])
      fprintf(file,"%g %g\n",[xObject doubleValue], [yObject doubleValue]);
    else
      FSExecError(@"invalid data");  
  }  
  fflush(file);
  plotFileAtPath([NSString stringWithCString:path],options);
}

+ (void)plotX:(NSArray *)x y:(NSArray *)y
{
  [self plotX:x y:y options:@""];
} 

/*+ (void)plot:(NSArray *)y options:(NSString *)options
{

}*/

+ (void)plot:(NSArray *)y options:(NSString *)options
{
  NSUInteger i, count;
  FILE *file;
  char *path = malloc(30);
  [NSData dataWithBytesNoCopy:path length:30];
  // In order to ensure that it will be freed even if an exception is raised during the method, we give 
  // the ownership of the memory allocated for "path" to an autoreleased NSData object.
  strcpy(path,"/tmp/temp.XXXXXX");
  path = mktemp(path);
  file = fopen(path,"w");
  for (i = 0, count = [y count]; i < count; i++)
  {
    id object = [y objectAtIndex:i];
    if ([object isKindOfClass:[NSNumber class]])
      fprintf(file,"%g\n",[object doubleValue]);
    else
      FSExecError(@"invalid data");  
  }  
  fflush(file);
  plotFileAtPath([NSString stringWithCString:path],options);
}

+ (void)plot:(NSArray *)y
{
  [self plot:y options:@""];
}


+ (void)graphX:(NSArray *)x y:(NSArray *)y z:(NSArray *)z
{
  NSUInteger i, count;
  NSDictionary *errorInfo;
  NSAppleScript *as;
  FILE *file;
  NSMutableString *command;
  char *path = malloc(30);
  [NSData dataWithBytesNoCopy:path length:30];
  // In order to ensure that it will be freed even if an exception is raised during the method, we give 
  // the ownership of the memory allocated for "path" to an autoreleased NSData object.
  strcpy(path,"/tmp/temp.XXXXXX");
  path = mktemp(path);
  file = fopen(path,"w");
  for (i = 0, count = [y count]; i < count; i++)
  {
    id object = [y objectAtIndex:i];
    if ([object isKindOfClass:[NSNumber class]])
      fprintf(file,"%g %g %g\n",[[x objectAtIndex:i] doubleValue], [object doubleValue], [[z objectAtIndex:i] doubleValue]);
    else
      FSExecError(@"invalid data");  
  }  
  fflush(file);
 // [NSTimer scheduledTimerWithTimeInterval:20 target:[FSMiscTools class] selector:@selector(unlink:) userInfo:[NSString stringWithCString:path] repeats:NO];
  command = [NSMutableString stringWithString:@"tell application \"gnuplot-3.7.1d\"\n activate\n exec \"set surface; splot \\\""];
  [command appendString:[NSString stringWithCString:path]];  
  [command appendString:@"\\\"with linespoints\"\n end tell"];
  as = [[[NSAppleScript alloc] initWithSource:command] autorelease];
  if ([as executeAndReturnError:&errorInfo] == nil)
  {
    FSExecError([errorInfo objectForKey:NSAppleScriptErrorMessage]);
  }
}

+ (void)exec:(NSString *)gnuplotCommand
{
  NSDictionary *errorInfo;
  NSAppleScript *as;
  NSMutableString *command;
  command = [NSMutableString stringWithString:@"tell application \"gnuplot-3.7.1d\"\n activate\n exec \""];
  [command appendString:gnuplotCommand];  
  [command appendString:@"\"\n end tell"];
  as = [[[NSAppleScript alloc] initWithSource:command] autorelease];
  if ([as executeAndReturnError:&errorInfo] == nil)
  {
    FSExecError([errorInfo objectForKey:NSAppleScriptErrorMessage]);
  }
}


@end
