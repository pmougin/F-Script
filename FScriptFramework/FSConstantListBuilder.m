/* FSConstantListBuilder.m Copyright (c) 2002-2009 Philippe Mougin.  */
/*   This software is open source. See the licence.  */  



/*
b := FSConstantListBuilder alloc init .

b analyseDirectoryAtPath:'/System/Library/Frameworks/AddressBook.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/AppKit.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/Automator.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/CalendarStore.framework/Versions/Current/Resources/BridgeSupport'.
"b analyseDirectoryAtPath:'/System/Library/Frameworks/Carbon.framework/Versions/Current/Frameworks/SpeechRecognition.framework/Versions/A/Resources/BridgeSupport'."
b analyseDirectoryAtPath:'/System/Library/Frameworks/Cocoa.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/Collaboration.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/CoreAudio.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/CoreAudioKit.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/CoreData.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/CoreFoundation.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/CoreVideo.framework/Versions/Current/Resources/BridgeSupport'.
"b analyseDirectoryAtPath:'/System/Library/Frameworks/DirectoryService.framework/Versions/Current/Resources/BridgeSupport'."
b analyseDirectoryAtPath:'/System/Library/Frameworks/DiscRecording.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/DiscRecordingUI.framework/Versions/Current/Resources/BridgeSupport'.
"b analyseDirectoryAtPath:'/System/Library/Frameworks/DVDPlayback.framework/Versions/Current/Resources/BridgeSupport'."
b analyseDirectoryAtPath:'/System/Library/Frameworks/ExceptionHandling.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/Foundation.framework/Versions/Current/Resources/BridgeSupport'.
"b analyseDirectoryAtPath:'/System/Library/Frameworks/ICADevices.framework/Versions/Current/Resources/BridgeSupport'."

b analyseDirectoryAtPath:'/System/Library/Frameworks/InputMethodKit.framework/Versions/Current/Resources/BridgeSupport'. 

"b analyseDirectoryAtPath:'/System/Library/Frameworks/InstallerPlugins.framework/Versions/A/Resources/BridgeSupport'." "Removed because no support for 64 bit in Leopard 10.5. TODO : check and add back"

b analyseDirectoryAtPath:'/System/Library/Frameworks/InstantMessage.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/IOBluetooth.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/IOBluetoothUI.framework/Versions/Current/Resources/BridgeSupport'.
"b analyseDirectoryAtPath:'/System/Library/Frameworks/JavaScriptCore.framework/Versions/Current/Resources/BridgeSupport'."
"b analyseDirectoryAtPath:'/System/Library/Frameworks/LatentSemanticMapping.framework/Versions/Current/Resources/BridgeSupport'."
"b analyseDirectoryAtPath:'/System/Library/Frameworks/OpenGL.framework/Versions/Current/Resources/BridgeSupport'."
b analyseDirectoryAtPath:'/System/Library/Frameworks/OSAKit.framework/Versions/Current/Resources/BridgeSupport'.

b analyseDirectoryAtPath:'/System/Library/Frameworks/PubSub.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/QTKit.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/Quartz.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/Quartz.framework/Versions/Current/Frameworks/ImageKit.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/Quartz.framework/Versions/Current/Frameworks/PDFKit.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/Quartz.framework/Versions/Current/Frameworks/QuartzComposer.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/QuartzCore.framework/Versions/Current/Resources/BridgeSupport'.

"b analyseDirectoryAtPath:'/System/Library/Frameworks/ScreenSaver.framework/Versions/Current/Resources/BridgeSupport'." "Removed because no support for 64 bit in Leopard 10.5. TODO : check and add back"

b analyseDirectoryAtPath:'/System/Library/Frameworks/ScriptingBridge.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/SecurityFoundation.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/SecurityInterface.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/SyncServices.framework/Versions/Current/Resources/BridgeSupport'.
"b analyseDirectoryAtPath:'/System/Library/Frameworks/SystemConfiguration.framework/Versions/Current/Resources/BridgeSupport'."
b analyseDirectoryAtPath:'/System/Library/Frameworks/WebKit.framework/Versions/Current/Resources/BridgeSupport'.
b analyseDirectoryAtPath:'/System/Library/Frameworks/XgridFoundation.framework/Versions/Current/Resources/BridgeSupport'.


b constantsInitializerString. 

*/

#import "FSConstantListBuilder.h"
#import "FScriptFunctions.h"


@implementation FSConstantListBuilder

- init
{
  if (self = [super init])
  {
    constantsInitializerString = [[NSMutableString alloc] init];
    return self;
  }
  return nil;  
}

-(void)analyseFileAtPath:(NSString *)path
{
  NSXMLDocument *xmlDoc;
  NSError *err=nil;
  NSURL *url = [NSURL fileURLWithPath:path];
  
  if (!url) FSExecError([NSString stringWithFormat:@"Can't create an URL from file %@.", path]);
  
  xmlDoc = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA) error:&err] autorelease];
    
  if (err) FSExecError([err localizedDescription]);
  
  NSXMLElement *signatures = [xmlDoc rootElement];
  
  ////////////////// Processing "constant" elements
    
  NSString *CFStringRefEncode = [NSString stringWithUTF8String:@encode(CFStringRef)];
  NSArray *constants = [signatures elementsForName:@"constant"];
  
  for (NSXMLElement *constant in constants) 
  {
    NSString *type         = [[constant attributeForName:@"type"] stringValue];
    NSString *type64       = [[constant attributeForName:@"type64"] stringValue];
    NSString *name         = [[constant attributeForName:@"name"] stringValue];
    NSString *magic_cookie = [[constant attributeForName:@"magic_cookie"] stringValue];
    
    if (type64 && type)
    {
      NSLog(@"Problem: type64 attribute found for constant %@", name);
    }
    else if ([magic_cookie isEqualToString:@"true"])
    {
      NSLog(@"Problem: magic_cookie found for constant %@", name);
    }
    else
    {
      if      ([type isEqualToString:@"@"])
      {
        [constantsInitializerString appendFormat:@"if ([%@ isKindOfClass:[NSString class]]) [d setObject:%@ forKey:@\"%@\"]; else NSLog([@\"Can't initialize %@ with object \" stringByAppendingString:[%@ description]]);\n", name, name, name, name, name];
      }
      else if ([type isEqualToString:@"i"] || [type isEqualToString:@"I"] || [type isEqualToString:@"s"] || [type isEqualToString:@"S"] ||
               [type isEqualToString:@"l"] || [type isEqualToString:@"L"] || [type isEqualToString:@"q"] || [type isEqualToString:@"Q"] ||              
               [type isEqualToString:@"f"] || [type isEqualToString:@"d"])
      {
        [constantsInitializerString appendFormat:@"[d setObject:[Number numberWithDouble:%@] forKey:@\"%@\"];\n", name, name];
      }
      else if ([type isEqualToString:CFStringRefEncode])
      {
        [constantsInitializerString appendFormat:@"[d setObject:(NSString *)%@ forKey:@\"%@\"];\n", name, name];
      }
      else NSLog(@"Can't generate initializer for %@ of type %@", name, type);
    }  
  }  
  
  ////////////////// Processing "string_constant" elements

  NSArray *string_constants = [signatures elementsForName:@"string_constant"];
  for (NSXMLElement *string_constant in string_constants) 
  {
    NSString *name     = [[string_constant attributeForName:@"name"] stringValue];
    NSString *nsstring = [[string_constant attributeForName:@"nsstring"] stringValue];
    
    if (nsstring == nil || [nsstring isEqualToString:@"true"])
      [constantsInitializerString appendFormat:@"[d setObject:%@ forKey:@\"%@\"];\n", name, name];
  }
  
  ////////////////// Processing "enum" elements

  NSArray *enums = [signatures elementsForName:@"enum"];
  
  for (NSXMLElement *e in enums) 
  {
    NSString *name     = [[e attributeForName:@"name"]     stringValue];
    NSNumber *value64  = [[e attributeForName:@"value64"]  objectValue];
    NSNumber *le_value = [[e attributeForName:@"le_value"] objectValue];
    NSNumber *be_value = [[e attributeForName:@"be_value"] objectValue];
    NSString *ignore   = [[e attributeForName:@"ignore"]   stringValue];

    if (ignore)
    {
      NSLog(@"ignore attribute found for enum %@", name);
    }
    else if (value64)
    {
      NSLog(@"Problem: value64 attribute found for enum %@", name);  
    }
    else if (le_value || be_value)
    {
      NSLog(@"Problem: le_value or be_value attribute found for enum %@", name);  
    }  
    else 
    {
      [constantsInitializerString appendFormat:@"[d setObject:[Number numberWithDouble:%@] forKey:@\"%@\"];\n", name, name];
    }
  } 
}

-(void)analyseDirectoryAtPath:(NSString *)directoryPath
{
  NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:directoryPath]; 
  NSString *fileName; 

  while ((fileName = [dirEnum nextObject])) 
  {
    if ([[fileName pathExtension] isEqualToString:@"bridgesupport"])
    {
      [self analyseFileAtPath:[directoryPath stringByAppendingPathComponent:fileName]];
    }
  }
}

-(NSString *)constantsInitializerString
{
  NSMutableString *result = [NSMutableString stringWithString:constantsInitializerString];

  //

  return result;
}

@end
