//  FSEvalScriptCommand.m Copyright (c) 2002 Joerg Garbers.
//  This software is open source. See the license.
//  
//  Modification for F-Script 1.3.1, january 2006, contributed by A.J. 
//  Further modifications for F-Script 1.3.1 by Philippe Mougin

#import "FSEvalCommand.h"
#import "FSServicesProvider.h" 
#import "FSInterpreter.h"
#import "FSInterpreterResult.h"
#import "FSVoid.h"

@implementation FSEvalCommand

- (id)performDefaultImplementation
{
  NSString *commandsString=[self directParameter];
  NSString *result;
  FSInterpreter *interpreter;
  FSInterpreterResult *raw_result;
  
  //NSLog(@"evaluating: %@", commandsString);
  
  if ([FSServicesProvider globalServicesProvider])
  {
      interpreter = [[[[FSServicesProvider globalServicesProvider] interpreterViewProvider] interpreterView] interpreter];
  }
  else 
  {
      interpreter = [FSInterpreter interpreter];
  }
  
  raw_result = [interpreter execute:commandsString];
  
  if ([raw_result isOK]){
      if ([raw_result result]){
          id real_result = [raw_result result];
          
          if ([real_result isKindOfClass:[NSString class]] || [real_result isKindOfClass:[NSNumber class]] || [real_result isKindOfClass:[NSDate class]] || [real_result isKindOfClass:[NSDictionary class]] || [real_result isKindOfClass:[NSArray class]] || [real_result isKindOfClass:[NSAttributedString class]] || [real_result isKindOfClass:[NSData class]]){
              result = real_result;
          }
          else if ([real_result isKindOfClass:[FSVoid class]]) {
              result = nil;				  
          }
          else {
              result = [[raw_result result] description];		
          }
      }
      else
          result = [raw_result description];
  }
  else
      result = [NSString stringWithFormat:@"FScript error: %@ with command: %@", [raw_result errorMessage], commandsString];
  
  //NSLog(@"result: %@",[result description]);
  return result;
}
@end

