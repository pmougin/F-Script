#import <AppKit/AppKit.h>
#import "FScriptAppController.h"

int main(int argc, const char **argv) 
{      
  RestartWithCorrectGarbageCollectionSettingIfNecessary();
  
  return NSApplicationMain(argc, argv);
}
   