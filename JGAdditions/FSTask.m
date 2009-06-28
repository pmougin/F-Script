//  FSTask.m Copyright (c) 2002 Joerg Garbers.
//  This software is open source. See the license.

#import "FSTask.h"


@implementation FSRecursiveReplacer 
- (id)initWithFrom:(NSString *)f to:(NSString *)t next:(FSRecursiveReplacer *)n;
{
  [super init];
  from=[f copy];
  to=[t copy];
  next=[n retain];
  return self;
}
- (void)dealloc;
{
  [from release];
  [to release];
  [next release];
  [super dealloc];
}
+ (FSRecursiveReplacer *)replacerWithFrom:(NSString *)f to:(NSString *)t next:(FSRecursiveReplacer *)n;
{
  return [[[[self class] alloc] initWithFrom:f to:t next:n] autorelease];
}
+ (FSRecursiveReplacer *)replacerWithFrom:(NSString *)f to:(NSString *)t;
{
  return [[[[self class] alloc] initWithFrom:f to:t next:nil] autorelease];
}
+ (FSRecursiveReplacer *)returnReplacerFromRToN; // "\r" -> "\n"
{
  static FSRecursiveReplacer *myReplacer=nil;
  if (!myReplacer) {
    myReplacer=[[FSRecursiveReplacer alloc] initWithFrom:@"\r" to:@"\n" next:nil];
  }
  return myReplacer;
}
+ (FSRecursiveReplacer *)returnReplacerFromNToR; // "\n" -> "\r"
{
  static FSRecursiveReplacer *myReplacer=nil;
  if (!myReplacer) {
    myReplacer=[[FSRecursiveReplacer alloc] initWithFrom:@"\n" to:@"\r" next:nil];
  }
  return myReplacer;
}
- (NSString *)transform:(NSString *)str;
{
  NSString *result;
  NSArray *fromA=[str componentsSeparatedByString:from];
  if (next) {
    NSMutableArray *toA;
    NSEnumerator *e=[fromA objectEnumerator];
    NSString *fromComponent;
    toA=[[NSMutableArray alloc] initWithCapacity:[fromA count]];
    while (fromComponent=[e nextObject])
      [toA addObject:[next transform:fromComponent]];
    result=[toA componentsJoinedByString:to];
    [toA release];
  } else {
    result=[fromA componentsJoinedByString:to];
  }
  return result;
}
@end

@implementation FSTask
static NSStringEncoding defaultInputEncoding=NSISOLatin1StringEncoding;
static NSStringEncoding defaultOutputEncoding=NSISOLatin1StringEncoding;
static BOOL reportErrorOnNotZero=NO;
static NSTimeInterval maxInterval=10.0;

+ (void)setInputEncoding:(NSStringEncoding)enc;
{
  defaultInputEncoding=enc;
}
+ (void)setOutputEncoding:(NSStringEncoding)enc;
{
  defaultOutputEncoding=enc;
}
+ (void)setReportErrorOnNotZero:(BOOL)yn;
{
  reportErrorOnNotZero=yn;
}
+ (void)setMaxInterval:(NSTimeInterval)interv;
{
  maxInterval=interv;
}
+ (NSString *)outputOfProgram:(NSString *)program;
{
  return [self outputOfProgram:program withArguments:nil withInput:nil];
}
+ (NSString *)outputOfProgram:(NSString *)program withArguments:(NSArray *)args;
{
  return [self outputOfProgram:program withArguments:args withInput:nil];
}
+ (NSString *)outputOfProgram:(NSString *)program withInput:(NSString *)inputString;
{
  return [self outputOfProgram:program withArguments:nil withInput:inputString];
}
+ (NSString *)outputOfProgram:(NSString *)program withArguments:(NSArray *)args withInput:(NSString *)inputString;
{
  return [self outputOfProgram:program withArguments:args withInput:inputString inputEncoding:defaultInputEncoding outputEncoding:defaultOutputEncoding];
}
+ (NSString *)outputOfProgram:(NSString *)program withArguments:(NSArray *)args withInput:(NSString *)inputString inputEncoding:(NSStringEncoding)inputEncoding outputEncoding:(NSStringEncoding)outputEncoding;
  /*" calls setArraysFromOutput as a side effect "*/
{
  // to do?: on errors throw exception instead of error string?
  static BOOL doIt=YES; // set NO for debugging
  if (!inputString)
    inputString=@"";
  if (!args)
    args = [NSArray array];
  if (!program)
    return @"error: programName must be set";
  if (doIt) {
    NSTask *aTask = [[NSTask alloc] init];
    NSPipe *outPipe = [NSPipe pipe];
    NSPipe *inPipe = [NSPipe pipe];
    NSPipe *errPipe = [NSPipe pipe];
    NSFileHandle *writeHandle = [outPipe fileHandleForWriting];
    NSFileHandle *readHandle = [inPipe fileHandleForReading];
    //    NSFileHandle *errHandle = [errPipe fileHandleForReading];
    NSString *outStr=inputString;
    NSString *inStr=nil;
    NSMutableString *inCollectStr=[NSMutableString string];
    NSData *outData = [outStr dataUsingEncoding:inputEncoding];
    NSData *inData=nil;
    NSString *launchPath;
    NSInteger returnValue;
    NSTimeInterval startingDate;
    static BOOL readBeforeCheckTerminate=YES; // if programs crash, it might be better to set this to NO.
                                              // but there was a problem with programs, that wait with further output until
                                              // the end of the pipe has read the allready produced output. YES seems to solve it.
    static BOOL collectStepwise=NO; // YES is interesting, for seeing the updates. But the UI must have a chance to update.

    launchPath=[program stringByExpandingTildeInPath];

// there is an error in debug mode, if there is an exception.
    NS_DURING
      [aTask setLaunchPath:launchPath];
      [aTask setArguments:args];
      [aTask setStandardOutput:inPipe]; // write handle is closed to this process
      [aTask setStandardInput:outPipe]; // write handle is closed to this process
      [aTask setStandardError:errPipe]; // write handle is closed to this process
      [aTask launch];
      startingDate=[NSDate timeIntervalSinceReferenceDate];

      [writeHandle writeData:outData];
      [writeHandle closeFile];
      if (readBeforeCheckTerminate) {
        if (collectStepwise) {
          inData=[readHandle availableData]; // waits for output resp. data of lenght 0 if EOF
          while ([inData length]) {
            NSString *s=[[NSString alloc] initWithData:inData encoding:outputEncoding];
            [inCollectStr appendString:s];
            [s release];
            inData=[readHandle availableData];
          }
        } else { // in one step (wait until done)
          inData=[readHandle readDataToEndOfFile]; // error in debug mode, if task has terminated due to bus error
        }
      }
      while ([aTask isRunning] &&
             ([NSDate timeIntervalSinceReferenceDate]-startingDate<maxInterval)) {
        //    [aTask waitUntilExit];
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
      }

      if ([aTask isRunning]) {
        inStr=[[NSString alloc] initWithFormat:@"FSTask Error for %@: Time limit %f exceeded",launchPath,maxInterval];
      } else {
        returnValue = [aTask terminationStatus];
        if (returnValue) [aTask terminate]; // hmm?
        if (reportErrorOnNotZero && returnValue) {
          inStr=[[NSString alloc] initWithFormat:@"Error %ld for %@.",(long)returnValue,launchPath];
        } else {
          if (collectStepwise)
            inStr=[inCollectStr copy];
          else {
            if (!readBeforeCheckTerminate)
              inData=[readHandle readDataToEndOfFile];
            if (inData)
              inStr=[[NSString alloc] initWithData:inData encoding:outputEncoding];
          }
        }
      }
      NS_HANDLER
        inStr=[[NSString alloc] initWithFormat:@"FSTask Error Exception %@ during execution of %@",[localException description],launchPath];
      NS_ENDHANDLER
      [aTask release];
      return [inStr autorelease];
  } else return @"doIt=NO";
}

@end


@implementation FSTaskRunByLisp
+ (NSString *)outputOfProgram:(NSString *)program withArguments:(NSArray *)args withInput:(NSString *)inputString inputEncoding:(NSStringEncoding)inputEncoding outputEncoding:(NSStringEncoding)outputEncoding;
{
  NSString *convertedInput,*unConvertedOutput;
  convertedInput=[[FSRecursiveReplacer returnReplacerFromRToN] transform:inputString]; // "\r" -> "\n"
  unConvertedOutput=[super outputOfProgram:program withArguments:args withInput:convertedInput inputEncoding:inputEncoding outputEncoding:outputEncoding];
  return [[FSRecursiveReplacer returnReplacerFromNToR] transform:unConvertedOutput];
}
@end
