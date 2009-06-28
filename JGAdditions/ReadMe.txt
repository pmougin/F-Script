JGAdditions for the FScript-Distribution
====================================
Added 
  servicesProvider=[[FSServicesProvider alloc] initWithFScriptInterpreterViewProvider:self];
  [servicesProvider registerExports];
to method in FScriptAppController (Application fs)
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
Added - (id)interpreterView; to FScriptAppController

FSServicesProvider is the main entrance point for services provided to other applications. 3 different Service-handlers are used by example:

DistributedObject connections are enabled by
- (void)registerServerConnection:(NSString *)connectionName;

Service-Menu services are enabled by
- (void)registerServicesProvider;
- (void)putCommand:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error;
- (void)execute:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error;
and by NSServices entry in Info.plist (Expert-Mode in Application Settings Tab in ProjectBuilder)

Apple-Script events are enabled by FSEvalCommand.m and the Entries in fs.scriptSuite,fs.scriptTerminology and the NSAppleScriptEnabled setting in Info.plist


Extensions that have few to do with FScript, but with my Projects:
========================================================================

FSTask is a wrapper for input-output based command line programs. Makes those programs easily available in FScript-Browser and through apple events for Programs, that run in the classic box. 

