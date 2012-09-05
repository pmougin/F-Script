/*   FSConstantsDictionaryGenerator.m Copyright (c) 2003-2009 Philippe Mougin.  */
/*   This software is open source. See the license.     */   
 
#import "FSConstantsDictionaryGenerator.h"
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABGlobalsC.h>
#import <AddressBook/ABPeoplePickerView.h>
#import <AddressBook/ABPeoplePickerC.h>
#import <AddressBook/ABGlobals.h>
#import <AppKit/AppKit.h> 
#import <AppKit/NSAccessibility.h>
#import <AppKit/NSTypesetter.h>
#import <AppKit/NSMovieView.h> 
#import <Automator/Automator.h>
#import <CalendarStore/CalendarStore.h>
#import <CoreAudioKit/CoreAudioKit.h>
//#import <CoreLocation/CoreLocation.h>
//#import <CoreWLAN/CoreWLAN.h>
#import <DiscRecording/DiscRecording.h>
#import <DirectoryService/DirectoryService.h>
#import <DiscRecording/DiscRecording.h>
#import <DiscRecordingUI/DiscRecordingUI.h>
#import <DVDPlayback/DVDPlayback.h>
#import <ExceptionHandling/NSExceptionHandler.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSDebug.h>
#import <ICADevices/ICADevices.h>
//#import <ImageCaptureCore/ImageCaptureCore.h>
#import <InputMethodKit/InputMethodKit.h>
#import <InstallerPlugins/InstallerPlugins.h>
#import <InstantMessage/IMService.h>
#import <InstantMessage/IMAVManager.h>
#import <IOBluetooth/IOBluetooth.h>
#import <IOBluetooth/objc/IOBluetoothHandsFreeGateway.h>
#import <IOBluetooth/objc/IOBluetoothRFCOMMAudioController.h>
#import <IOBluetoothUI/IOBluetoothUI.h>
#import <JavaScriptCore/JavaScriptCore.h>
//#import <JavaVM/JavaVM.h>
#import <LatentSemanticMapping/LatentSemanticMapping.h>
#import <Message/NSMailDelivery.h>
//#import <OpenDirectory/OpenDirectory.h>
#import <OpenGL/OpenGL.h>
#import <OpenGL/glu.h>
#import <OpenGL/CGLProfilerFunctionEnum.h>
#import <OpenGL/CGLProfiler.h>
#import <OpenGL/CGLRenderers.h>
#import <OSAKit/OSAKit.h>
#import <PreferencePanes/PreferencePanes.h>
#import <PubSub/PubSub.h>
#import <Quartz/Quartz.h>
#import <QuartzCore/QuartzCore.h>
#import <QTKit/QTKit.h>
#import <QTKit/QTMovie.h>
#import <ScreenSaver/ScreenSaver.h>
#import <SecurityFoundation/SFAuthorization.h>
#import <SecurityInterface/SFAuthorizationView.h>
#import <SecurityInterface/SFAuthorizationPluginView.h>
//#import <ServerNotification/NSServerNotificationCenter.h>
#import <SyncServices/SyncServices.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <WebKit/WebKit.h>
#import <WebKit/WebJavaPlugIn.h>
//#import <XgridFoundation/XgridFoundation.h>

#import "Number_fscript.h"
#import "FSBoolean.h"

@implementation FSConstantsDictionaryGenerator

// FSConstantsDictionaryGenerator generateConstantsDictionaryFileSnowLeopard

+ (BOOL)generateConstantsDictionaryFileSnowLeopard 
{ 
  NSMutableDictionary *d = [NSMutableDictionary dictionary];  

/*
if ([ABPeoplePickerDisplayedPropertyDidChangeNotification isKindOfClass:[NSString class]]) [d setObject:ABPeoplePickerDisplayedPropertyDidChangeNotification forKey:@"ABPeoplePickerDisplayedPropertyDidChangeNotification"]; else NSLog(@"Can't initialize ABPeoplePickerDisplayedPropertyDidChangeNotification with object %@", ABPeoplePickerDisplayedPropertyDidChangeNotification);
if ([ABPeoplePickerGroupSelectionDidChangeNotification isKindOfClass:[NSString class]]) [d setObject:ABPeoplePickerGroupSelectionDidChangeNotification forKey:@"ABPeoplePickerGroupSelectionDidChangeNotification"]; else NSLog(@"Can't initialize ABPeoplePickerGroupSelectionDidChangeNotification with object %@", ABPeoplePickerGroupSelectionDidChangeNotification);
if ([ABPeoplePickerNameSelectionDidChangeNotification isKindOfClass:[NSString class]]) [d setObject:ABPeoplePickerNameSelectionDidChangeNotification forKey:@"ABPeoplePickerNameSelectionDidChangeNotification"]; else NSLog(@"Can't initialize ABPeoplePickerNameSelectionDidChangeNotification with object %@", ABPeoplePickerNameSelectionDidChangeNotification);
if ([ABPeoplePickerValueSelectionDidChangeNotification isKindOfClass:[NSString class]]) [d setObject:ABPeoplePickerValueSelectionDidChangeNotification forKey:@"ABPeoplePickerValueSelectionDidChangeNotification"]; else NSLog(@"Can't initialize ABPeoplePickerValueSelectionDidChangeNotification with object %@", ABPeoplePickerValueSelectionDidChangeNotification);
if ([kABAIMHomeLabel isKindOfClass:[NSString class]]) [d setObject:kABAIMHomeLabel forKey:@"kABAIMHomeLabel"]; else NSLog(@"Can't initialize kABAIMHomeLabel with object %@", kABAIMHomeLabel);
if ([kABAIMInstantProperty isKindOfClass:[NSString class]]) [d setObject:kABAIMInstantProperty forKey:@"kABAIMInstantProperty"]; else NSLog(@"Can't initialize kABAIMInstantProperty with object %@", kABAIMInstantProperty);
if ([kABAIMWorkLabel isKindOfClass:[NSString class]]) [d setObject:kABAIMWorkLabel forKey:@"kABAIMWorkLabel"]; else NSLog(@"Can't initialize kABAIMWorkLabel with object %@", kABAIMWorkLabel);
if ([kABAddressCityKey isKindOfClass:[NSString class]]) [d setObject:kABAddressCityKey forKey:@"kABAddressCityKey"]; else NSLog(@"Can't initialize kABAddressCityKey with object %@", kABAddressCityKey);
if ([kABAddressCountryCodeKey isKindOfClass:[NSString class]]) [d setObject:kABAddressCountryCodeKey forKey:@"kABAddressCountryCodeKey"]; else NSLog(@"Can't initialize kABAddressCountryCodeKey with object %@", kABAddressCountryCodeKey);
if ([kABAddressCountryKey isKindOfClass:[NSString class]]) [d setObject:kABAddressCountryKey forKey:@"kABAddressCountryKey"]; else NSLog(@"Can't initialize kABAddressCountryKey with object %@", kABAddressCountryKey);

...

[d setObject:[Number numberWithDouble:XGResourceStatePending] forKey:@"XGResourceStatePending"];
[d setObject:[Number numberWithDouble:XGResourceStateRunning] forKey:@"XGResourceStateRunning"];
[d setObject:[Number numberWithDouble:XGResourceStateStagingIn] forKey:@"XGResourceStateStagingIn"];
[d setObject:[Number numberWithDouble:XGResourceStateStagingOut] forKey:@"XGResourceStateStagingOut"];
[d setObject:[Number numberWithDouble:XGResourceStateStarting] forKey:@"XGResourceStateStarting"];
[d setObject:[Number numberWithDouble:XGResourceStateSuspended] forKey:@"XGResourceStateSuspended"];
[d setObject:[Number numberWithDouble:XGResourceStateUnavailable] forKey:@"XGResourceStateUnavailable"];
[d setObject:[Number numberWithDouble:XGResourceStateUninitialized] forKey:@"XGResourceStateUninitialized"];
[d setObject:[Number numberWithDouble:XGResourceStateWorking] forKey:@"XGResourceStateWorking"];

*/
  return [NSKeyedArchiver archiveRootObject:d toFile:@"/Users/pmougin/constantsDictionary"]; 
}
 

@end
