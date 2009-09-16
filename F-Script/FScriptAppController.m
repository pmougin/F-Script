/* FScriptAppController.m Copyright 1998-2009 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import "FScriptAppController.h"
#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h> 
#import "FSInterpreter.h"
#import "FSInterpreterView.h"
#import "FSSystem.h"
#import "FSBlock.h"
#import "FSArray.h" 
#import "FSNSString.h"
#import <ExceptionHandling/NSExceptionHandler.h>
#import "FSServicesProvider.h"
#import "FSMiscTools.h"
#import "FSDemoAssistant.h"
#import <spawn.h>
#import <crt_externs.h>

extern char **environ;

void RestartWithCorrectGarbageCollectionSettingIfNecessary()
{
  /* Inspired by code provided by Scotty of the Mac Developer Network. */
  /* See http://www.mac-developer-network.com/podcasts/lnc/lnc036/     */

  // NSLog(@"Entering in RestartWithCorrectGarbageCollectionSettingIfNecessary()");
  
  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
  
  NSDictionary* garbageCollectionUserDefaults = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"FScriptRunWithObjCAutomaticGarbageCollection", nil];
  [[NSUserDefaults standardUserDefaults] registerDefaults:garbageCollectionUserDefaults];

  BOOL requireRestart = NO;
  
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FScriptRunWithObjCAutomaticGarbageCollection"] == YES && [NSGarbageCollector defaultCollector] == nil)
  { 
    // NSLog(@"unsetenv OBJC_DISABLE_GC");
    unsetenv("OBJC_DISABLE_GC");
    requireRestart = YES;
  }
  else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FScriptRunWithObjCAutomaticGarbageCollection"] == NO && [NSGarbageCollector defaultCollector])
  {
    // NSLog(@"setenv OBJC_DISABLE_GC");
    setenv("OBJC_DISABLE_GC", "YES", 1);
    requireRestart = YES;
  } 

  if (requireRestart)
  { 
    // NSLog(@"Require restart");
          
    cpu_type_t cpuTypes[2];
    
#ifdef __ppc__
    // 32-bit PowerPC code
    cpuTypes[0] = CPU_TYPE_POWERPC;
#else
#ifdef __ppc64__
    cpuTypes[0] = CPU_TYPE_POWERPC64;
#else
#ifdef __i386__ 
// 32-bit Intel code
    cpuTypes[0] = CPU_TYPE_I386;
#else
#ifdef __x86_64__
// 64-bit Intel code
    cpuTypes[0] = CPU_TYPE_X86_64;
#else
#error UNKNOWN ARCHITECTURE
#endif
#endif
#endif
#endif
        
    cpuTypes[1] = CPU_TYPE_ANY;  // Things should work without this entry, but we use it just in case of an unforeseen problem

    size_t ocount;
    posix_spawnattr_t attribute;
    posix_spawnattr_init(&attribute);
    posix_spawnattr_setbinpref_np(&attribute, 2, cpuTypes, &ocount);
    
    const int spawnReturnValue = posix_spawn(NULL, (*_NSGetArgv())[0], NULL, &attribute, *_NSGetArgv(), environ);
    
    if(spawnReturnValue == 0)
    {
      exit(0);
    }
    else
    {
      perror("posix_spawn() failed, continuing...");
    }
  }

  [pool release];
}


NSString  *findPathToFileInLibraryWithinUserDomain(NSString *fileName)
/*" Retuns the path to the first occurrence of fileName in a Library
directory within the User domain. "*/
{
  NSString      *result = nil;		// the returned path
  NSString      *candidate;        	// candidate paths
  NSArray       *pathArray;        	// array of standard locations
  NSEnumerator  *pathEnumerator;	// used to enumerate pathArray

  pathArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  pathEnumerator = [pathArray objectEnumerator];

  while(nil == result && (nil != (candidate = [pathEnumerator nextObject])))
  {
    result = [candidate stringByAppendingPathComponent:fileName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:result])
    {
          result = nil;
    } 
  }
  return result;
}

NSString  *findPathToFileInLibraryWithinSystemDomain(NSString *fileName)
/*" Retuns the path to the first occurrence of fileName in a Library
directory within the System domain. "*/
{
  NSString      *result = nil;		// the returned path
  NSString      *candidate;        	// candidate paths
  NSArray       *pathArray;        	// array of standard locations
  NSEnumerator  *pathEnumerator;	// used to enumerate pathArray

  pathArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSSystemDomainMask, YES);
  pathEnumerator = [pathArray objectEnumerator];

  while(nil == result && (nil != (candidate = [pathEnumerator nextObject])))
  {
    result = [candidate stringByAppendingPathComponent:fileName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:result])
    {
          result = nil;
    } 
  }
  return result;
}

@interface NSUserDefaults(FSNSUserDefaults)
- (void)setObject:(id)value forKey:(NSString *)defaultName inDomain:(NSString *)domainName;
@end

@implementation FScriptAppController 

+ (void)initialize
{ 
  NSMutableDictionary *registrationDict = [NSMutableDictionary dictionary];

  [registrationDict setObject:[NSNumber numberWithDouble:[[NSFont userFixedPitchFontOfSize:-1] pointSize]] forKey:@"FScriptFontSize"];
  [registrationDict setObject:@"NO"  forKey:@"FScriptShouldJournal"];
  [registrationDict setObject:@"NO"  forKey:@"FScriptConfirmWhenQuitting"];
  [registrationDict setObject:@"YES" forKey:@"FScriptDisplayObjectBrowserAtLaunchTime"];
  [registrationDict setObject:@"YES" forKey:@"FScriptRunWithObjCAutomaticGarbageCollection"]; 
  [registrationDict setObject:@"YES" forKey:@"FScriptAutomaticallyIntrospectDeclaredProperties"];  
 
  [[NSUserDefaults standardUserDefaults] registerDefaults:registrationDict];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSFileManager *fileManager = [NSFileManager defaultManager];
  BOOL b = NO;
  NSString *latent;
  NSString *latentPath; 
  NSString *repositoryPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"FScriptRepositoryPath"];
  FSServicesProvider *servicesProvider;
    
  if (!repositoryPath || ![fileManager fileExistsAtPath:repositoryPath isDirectory:&b])
  {
    NSString *applicationSupportDirectoryPath = findPathToFileInLibraryWithinUserDomain(@"Application Support");
    
    if (!applicationSupportDirectoryPath)
    {
      NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
      
      if ([pathArray count] > 0) 
        [fileManager createDirectoryAtPath:[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"Application Support"] attributes:nil];
    }
    
    applicationSupportDirectoryPath = findPathToFileInLibraryWithinUserDomain(@"Application Support");
    
    if (applicationSupportDirectoryPath)
    {
      repositoryPath = [applicationSupportDirectoryPath stringByAppendingPathComponent:@"F-Script"];
      [fileManager createDirectoryAtPath:repositoryPath attributes:nil];
      [fileManager createDirectoryAtPath:[repositoryPath stringByAppendingPathComponent:@"classes"] attributes:nil];
      if ([[NSUserDefaults standardUserDefaults] respondsToSelector:@selector(setObject:forKey:inDomain:)])
        [[NSUserDefaults standardUserDefaults] setObject:repositoryPath forKey:@"FScriptRepositoryPath" inDomain:NSGlobalDomain]; // This is an undocumented Cocoa API in Mac OS X 10.1
      else
        [[NSUserDefaults standardUserDefaults] setObject:repositoryPath forKey:@"FScriptRepositoryPath"];
      [[NSUserDefaults standardUserDefaults] setObject:[repositoryPath stringByAppendingPathComponent:@"journal.txt"] forKey:@"FScriptJournalName"];
      [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
      NSLog(@"Failed to create the repository in the user's \"Application Support\" directory.");
      NSInteger choice = NSRunAlertPanel(@"Instalation" , @"F-Script is about to create a directory named \"FScriptRepository\" in your home directory. This directory will be used as a repository for things like extension bundles for F-Script and a journal file.", @"create the repository", @"don't create the repository", @"create the repository elsewhere...");
  
      if (choice == NSAlertOtherReturn || choice == NSAlertDefaultReturn)
      {
        if (choice == NSAlertOtherReturn)
        { 
          NSOpenPanel *openPanel = [NSOpenPanel openPanel];
          [openPanel setCanChooseFiles:NO];
          [openPanel setCanChooseDirectories:YES];
          [openPanel setTitle:@"Choose the directory that will become the F-Script repository"];
  
          if([openPanel runModal] == NSOKButton) repositoryPath = [openPanel filename];
          else                                   repositoryPath = nil; 
        }
        else repositoryPath = [NSHomeDirectory() stringByAppendingPathComponent:@"FScriptRepository"];
        
        if (repositoryPath)
        {
        
          if ([[NSUserDefaults standardUserDefaults] respondsToSelector:@selector(setObject:forKey:inDomain:)])
            [[NSUserDefaults standardUserDefaults] setObject:repositoryPath forKey:@"FScriptRepositoryPath" inDomain:NSGlobalDomain]; // This is an undocumented Cocoa API in Mac OS X 10.1
          else
            [[NSUserDefaults standardUserDefaults] setObject:repositoryPath forKey:@"FScriptRepositoryPath"];

          //[[NSUserDefaults standardUserDefaults] setObject:repositoryPath forKey:@"FScriptRepositoryPath"];
          [fileManager createDirectoryAtPath:repositoryPath attributes:nil];
          [fileManager createDirectoryAtPath:[repositoryPath stringByAppendingPathComponent:@"classes"] attributes:nil];
  
          [[NSUserDefaults standardUserDefaults] setObject:[repositoryPath stringByAppendingPathComponent:@"journal.txt"] forKey:@"FScriptJournalName"];
        }  
      }
    }       
  }
  else if (!(b && [fileManager isWritableFileAtPath:repositoryPath]))  // partial consistency check
  {
    NSLog(@"fatal problem: the repository file \"%@\" is not a directory or is not writable", repositoryPath);
    exit(1);
  }
  
  // Initialize the random number generator with random seeds
  srandomdev();
  srand48(random());
      
  // We will catch most unhandled run-time error with this.
  [[NSExceptionHandler defaultExceptionHandler] setExceptionHandlingMask:63];

  // We initialize the journaling system
  [[interpreterView interpreter] setShouldJournal:[[NSUserDefaults standardUserDefaults] boolForKey:@"FScriptShouldJournal"]];
  if (repositoryPath) [[NSUserDefaults standardUserDefaults] setObject:[repositoryPath stringByAppendingPathComponent:@"journal.txt"] forKey:@"FScriptJournalName"];
  [[interpreterView interpreter] setJournalName:[[NSUserDefaults standardUserDefaults] stringForKey:@"FScriptJournalName"]];

  // JG 
  servicesProvider = [[FSServicesProvider alloc] initWithFScriptInterpreterViewProvider:self];
  [servicesProvider registerExports];
  
  // Latent block processing 
  latentPath = [[[NSUserDefaults standardUserDefaults] stringForKey:@"FScriptRepositoryPath"] stringByAppendingPathComponent:@"fs_latent"];

  if (latentPath && [[NSFileManager defaultManager] fileExistsAtPath:latentPath] && (latent = [NSString stringWithContentsOfFile:latentPath]))
  {
    BOOL found;
    FSInterpreter *interpreter = [interpreterView interpreter];
    FSSystem *sys = [interpreter objectForIdentifier:@"sys" found:&found];
    FSBlock *bl;

    NSAssert(found,@"F-Script internal error: symbol \"sys\" not defined");
    
    @try
    {
      bl = [sys blockFromString:latent];
      [bl value];
    }
    @catch (id exception)
    {
      [interpreterView notifyUser:[NSString stringWithFormat:@"Error in the latent block (file %@): %@",latentPath, FSErrorMessageFromException(exception)]];
    }
  }
  //----------
    
  [[interpreterView window] makeKeyAndOrderFront:nil];
  
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FScriptDisplayObjectBrowserAtLaunchTime"])
    [[interpreterView interpreter] browse];
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
  [self performSelector:@selector(openFile:) withObject:filename afterDelay:0];
  return YES;
}

- (void)openFile:(NSString *)filename 
{ 
 { // generates a filename with a unix style path separator
    FSArray *elems  = [filename asArray];
    NSUInteger i, nb;
    for (i = 0, nb = [elems count]; i < nb; i++)
      if ([[elems objectAtIndex:i] isEqual:@"\\"]) [elems replaceObjectAtIndex:i withObject:@"/"];
    filename = [elems operator_backslash:[@"#++" asBlock]];
  }
  
  if ([[filename pathExtension] isEqualToString:@"space"])
    [interpreterView putCommand:[NSString stringWithFormat:@"sys loadSpace:%@\n",filename]];
  else
  {
    NSString *fname = [filename lastPathComponent];
    NSUInteger nb = [fname length];      
    
    while (nb != ([fname = [fname stringByDeletingPathExtension] length]))
      nb = [fname length]; // remove all the extentions
    [interpreterView putCommand:[NSString stringWithFormat:@"%@ := sys load:%@",fname,filename]];
  }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"FScriptConfirmWhenQuitting"] && !quitConfirmed)
  {
    NSInteger choice = NSRunAlertPanel(@"QUIT", @"Are you sure you want to quit F-Script?", @"Quit", @"Cancel", nil,nil);
  
    if (choice == NSAlertDefaultReturn) return NSTerminateNow;   
    else                                return NSTerminateCancel; // don't quit
  }
  else return NSTerminateNow;  
}

- (void)dealloc
{
  if ([[NSApplication sharedApplication] delegate] == self)
    [[NSApplication sharedApplication] setDelegate:nil];
  // since we don't retain outlets infoPanel and interpreterView, we don't have to release them here.
  [showConsoleMenuItem release];
  [super dealloc];
}

- (id) init 
{
  self = [super init];
  if (self != nil) 
  {
    showConsoleMenuItem = [[NSMenuItem alloc] initWithTitle:@"F-Script" action:@selector(showConsole:) keyEquivalent:@""];
    quitConfirmed = NO;
  }
  return self;
}


- (id)interpreterView // For use by JG FSServiceProvider
{
  return interpreterView;
}

- (void)newDemoAssistant:(id)sender
{
  [[[FSDemoAssistant alloc] initWithInterpreterView:interpreterView] activate];
}

- (void)newObjectBrowser:sender
{
  [[interpreterView interpreter] browse];
}

- (void)showConsole:(id)sender
{
  NSMenu *windowMenu = [[[NSApp mainMenu] itemWithTitle:@"Window"] submenu];

  [[interpreterView window] makeKeyAndOrderFront:nil];
  [windowMenu removeItem:showConsoleMenuItem];
}

- (void)showInfoPanel:(id)sender 
{
  /*if (!infoPanel) 
  {
    if (![NSBundle loadNibNamed:@"FScriptAppInfo" owner:self])  {
      NSLog(@"Failed to load FScriptAppInfo.nib");
      NSBeep();
      return; 
    }
    [infoPanel center];
  }
  [infoPanel makeKeyAndOrderFront:nil];
  */
  NSMutableAttributedString *s = [[[NSMutableAttributedString alloc] initWithString:@"http://www.fscript.org" attributes:[NSDictionary dictionaryWithObject:@"http://www.fscript.org" forKey:NSLinkAttributeName]] autorelease];
  [NSApp orderFrontStandardAboutPanelWithOptions:[NSDictionary dictionaryWithObject:s forKey:@"Credits"]];
}

- (void)showPreferencePanel:(id)sender
{
  if (!preferencePanel) 
  {
    if (![NSBundle loadNibNamed:@"FScriptAppPreference" owner:self])  
    {
      NSLog(@"Failed to load FScriptAppPreference.nib");
      NSBeep();
      return;
    }
    [preferencePanel center];
  }
  [fontSizeUI setDoubleValue:[interpreterView fontSize]];
  [shouldJournalUI setState:[[interpreterView interpreter] shouldJournal]];
  [confirmWhenQuittingUI setState:[[NSUserDefaults standardUserDefaults] boolForKey:@"FScriptConfirmWhenQuitting"]];
  [runWithObjCAutomaticGarbageCollectionUI setState:[[NSUserDefaults standardUserDefaults] boolForKey:@"FScriptRunWithObjCAutomaticGarbageCollection"]]; 
  [displayObjectBrowserAtLaunchTimeUI setState:[[NSUserDefaults standardUserDefaults] boolForKey:@"FScriptDisplayObjectBrowserAtLaunchTime"]];
  [automaticallyIntrospectDeclaredPropertiesUI setState:[[NSUserDefaults standardUserDefaults] boolForKey:@"FScriptAutomaticallyIntrospectDeclaredProperties"]];

  [preferencePanel makeKeyAndOrderFront:nil];
}

- (void)updatePreference:(id)sender // action
{
  //NSLog(@"** updatePreference");
  if (sender == fontSizeUI)
  {
    [[NSUserDefaults standardUserDefaults] setFloat:[fontSizeUI doubleValue] forKey:@"FScriptFontSize"];
    [interpreterView setFontSize:[fontSizeUI doubleValue]];
  }
  else if (sender == shouldJournalUI)
  {
    [[NSUserDefaults standardUserDefaults] setBool:[shouldJournalUI state] forKey:@"FScriptShouldJournal"];
    [[interpreterView interpreter] setShouldJournal:[shouldJournalUI state]];
  }
  else if (sender == confirmWhenQuittingUI)
  {
    [[NSUserDefaults standardUserDefaults] setBool:[confirmWhenQuittingUI state] forKey:@"FScriptConfirmWhenQuitting"];
  }
  else if (sender == displayObjectBrowserAtLaunchTimeUI)
  {
    [[NSUserDefaults standardUserDefaults] setBool:[displayObjectBrowserAtLaunchTimeUI state] forKey:@"FScriptDisplayObjectBrowserAtLaunchTime"];
  }
  else if (sender == automaticallyIntrospectDeclaredPropertiesUI)
  {
    [[NSUserDefaults standardUserDefaults] setBool:[automaticallyIntrospectDeclaredPropertiesUI state] forKey:@"FScriptAutomaticallyIntrospectDeclaredProperties"];
  }
  else if (sender == runWithObjCAutomaticGarbageCollectionUI)
  {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Restart"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Restart F-Script?"];
    [alert setInformativeText:@"F-Script needs to be restarted to change the memory management mode"];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    if ([alert runModal] == NSAlertFirstButtonReturn) 
    {
      // Restart clicked
      
      [[NSUserDefaults standardUserDefaults] setBool:[runWithObjCAutomaticGarbageCollectionUI state] forKey:@"FScriptRunWithObjCAutomaticGarbageCollection"];
      [[NSUserDefaults standardUserDefaults] synchronize];
            
      RestartWithCorrectGarbageCollectionSettingIfNecessary();
    }
    else
    {
      // Cancel clicked
      
      [runWithObjCAutomaticGarbageCollectionUI setState:[[NSUserDefaults standardUserDefaults] boolForKey:@"FScriptRunWithObjCAutomaticGarbageCollection"]]; 
    }
    
    [alert release];
  }
}

////////// Window delegate methods (I'm the delegate of the the console window)

- (void)windowWillClose:(NSNotification *)aNotification
{
  NSMenu *windowMenu = [[[NSApp mainMenu] itemWithTitle:@"Window"] submenu];
  [windowMenu insertItem:showConsoleMenuItem atIndex:[windowMenu numberOfItems]];
}

@end
