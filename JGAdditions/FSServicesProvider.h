//  FSServicesProvider.h Copyright (c) 2002 Joerg Garbers.
//  This software is open source. See the license.

#import <Foundation/Foundation.h>
@class NSPasteboard;

@protocol InterpreterViewProvider
-(id)interpreterView;
@end

@interface FSServicesProvider : NSObject 
{
  id interpreterViewProvider; // must respond to -(id)interpreterView;
}
+ (id)globalServicesProvider;
+ (void)updateDynamicServices;
- (id)initWithFScriptInterpreterViewProvider:(id)controller;
// convenience for registering distributed objects and Services
- (id)interpreterViewProvider;
- (void)registerExports;
// distributed objects
- (void)registerServerConnection:(NSString *)connectionName;
// helpers
- (void)doLog;
//- (void)putCommand:(NSString *)command parserMode:(T_parser_mode)mode useCurrent:(BOOL)useCurrent;
- (NSString *)execute:(NSString *)command; // also used by FSEvalCommand
// services
- (void)registerServicesProvider;
- (void)putCommand:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error;
- (void)execute:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error;

- (NSString *)executeText:(NSString *)commandsString; // jg moved from FSEvalCommand
@end
