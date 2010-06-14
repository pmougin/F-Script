//  FSServicesProvider.m Copyright (c) 2002 Joerg Garbers.
//  This software is open source. See the license.

#import <AppKit/AppKit.h>
#import "FSServicesProvider.h"
#import "FScriptAppController.h"
#import "FSInterpreterView.h"
#import "FSInterpreter.h"
#import "FSInterpreterResult.h"
#import "ShellView.h"
#import "CLIView.h"

@interface FSInterpreterView(FSInterpreterViewPrivate)
- (CLIView *)cliView;
@end 

@interface CLIView(CLIViewPrivate)
- (ShellView *)shellView;
@end

@interface ShellView (FSServicesProvider)
- (T_parser_mode)parserMode;
- (void)setParserMode:(T_parser_mode)mode;
@end

@implementation ShellView (FSServicesProvider)
- (T_parser_mode)parserMode;
{
  return parserMode;
}
- (void)setParserMode:(T_parser_mode)mode;
{
  parserMode=mode;
}
@end

@implementation FSServicesProvider

static id globalServicesProvider;

+ (id)globalServicesProvider
{
  return globalServicesProvider;
}

+ (void)updateDynamicServices
/* handy for playing with Services Menu.
   Note: having different F-Script applications installed results in Services confusion.
         The install directory seems to be irrelevant. */
{
  NSUpdateDynamicServices();
}


- (id)initWithFScriptInterpreterViewProvider:(id)controller
{
  [super init];
  interpreterViewProvider=[controller retain];
  if (!globalServicesProvider)
    globalServicesProvider=[self retain];
  return self;
}

- (id)interpreterViewProvider
{
  return interpreterViewProvider;
}

- (void)registerExports
{
  [self registerServicesProvider];
  [self registerServerConnection:@"F-Script"]; 
}
- (void)registerServerConnection:(NSString *)connectionName
{
  NSConnection *theConnection = [NSConnection defaultConnection]; // in current Thread
  [theConnection setRootObject:self];
  if ([theConnection registerName:connectionName] == NO) {
    NSLog(@"Handle error.");
  }
}
- (void)doLog
{
  NSLog(@"doLog");
}

// services section
- (void)putCommand:(NSString *)command parserMode:(T_parser_mode)mode useCurrent:(BOOL)useCurrent
{
  id interpreterView=[interpreterViewProvider interpreterView];
  ShellView *shellView=[[interpreterView cliView] shellView];
  T_parser_mode oldMode=[shellView parserMode];
  if (!useCurrent) [shellView setParserMode:mode];
  [interpreterView putCommand:command];
  if (!useCurrent) [shellView setParserMode:oldMode];
}

- (NSString *)execute:(NSString *)command
{
  FSInterpreterView *interpreterView=[interpreterViewProvider interpreterView];
  FSInterpreter *interpreter=[interpreterView interpreter];
  FSInterpreterResult *result=[interpreter execute:command];
  if ([result isOK]) {
    id res=[result result];
    if (res)
      return [res description];
    else 
      return @"nil";
  } else 
    return nil; // indicate error
}



- (void)registerServicesProvider
{
  NSApplication *app=[NSApplication sharedApplication];
  [app setServicesProvider:self];
  // NSUpdateDynamicServices(); // just for debugging ?
}

- (void)putCommand:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error
/* check userData for parserMode */
{
//  NSArray *types=[pboard types];
  NSString *pboardString=[pboard stringForType:NSStringPboardType];
  BOOL useCurrent=YES;
  T_parser_mode mode;
  if ([userData isEqualToString:@"DECOMPOSE"]) {
    useCurrent=NO;
    mode=DECOMPOSE;
  } else if ([userData isEqualToString:@"NO_DECOMPOSE"]) {
    useCurrent=NO;
    mode=NO_DECOMPOSE;
  }
  else {
    useCurrent=NO;
    mode=NO_DECOMPOSE;
  }
  [self putCommand:pboardString parserMode:mode useCurrent:useCurrent];
}

- (void)execute:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error
/* check userData for parserMode */
{
//    NSArray *types=[pboard types];
  NSString *command=[pboard stringForType:NSStringPboardType];
  NSString *ret=[self execute:command];
  if (ret) {
    NSArray *newTypes=[NSArray arrayWithObject:NSStringPboardType];
    [pboard declareTypes:newTypes owner:nil];
    [pboard setString:ret forType:NSStringPboardType];
  } else {
    *error=[@"FScript error with command: " stringByAppendingString:command];
  }
}

- (NSString *)executeText:(NSString *)commandsString
{
  NSString *lineSeparator=[commandsString substringToIndex:1];
  NSArray *commands;
  NSString *command;
  NSString *result=@"no result";
  NSInteger count,i;
  BOOL doExit=NO;
  BOOL multiLineMode;

  if ([lineSeparator isEqualToString:@"\n"] ||
      [lineSeparator isEqualToString:@"\r"]) {// Lisp sends returns as \r
    multiLineMode=YES;
    commands=[commandsString componentsSeparatedByString:lineSeparator];
  } else {
    multiLineMode=NO;
    commands=[NSArray arrayWithObject:commandsString];
  }
  count=[commands count];
  for (i=0;(i<count) && !doExit;i++) {
    command=[commands objectAtIndex:i];
    if (![command isEqualToString:@""]) {
      result=[self execute:command];
      if (!result) {
        doExit=YES;
        if (multiLineMode)
          result=[NSString stringWithFormat:@"FScript error with command at line %ld: %@",(long)(i+1),command];
        else
          result=[NSString stringWithFormat:@"FScript error with command: %@",command];
      }
    }
  }
  return result;
}

@end
