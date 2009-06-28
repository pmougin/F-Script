//  FSObjectBrowserCell.m Copyright (c) 2001-2009 Philippe Mougin.
//  This software is open source. See the license.

#import "FSObjectBrowserCell.h"
#import <ExceptionHandling/NSExceptionHandler.h>
#import "FSNSObject.h"

@implementation FSObjectBrowserCell 

+ (NSImage *)branchImage {return nil; /* No branch image */ } 

- (id) autorelease 
{
  //NSLog(@"autorelease called");
  return [super autorelease];
}

- (enum FSObjectBrowserCellType)objectBrowserCellType { return objectBrowserCellType; }

- (NSString *)classLabel { return classLabel; }

-(void) dealloc
{
  [label release];               
  [classLabel release];          
  [super dealloc];
}

- init
{
  if ((self = [super init]))
  {
    objectBrowserCellType = FSOBUNKNOWN;
    return self;
  }
  return nil;    
}

- (NSString *)label { return label; }

- (void) release
{
  //NSLog(@"release called");
  [super release];
}

- (id)representedObject
{
  if (objectBrowserCellType == FSOBCLASS)
  {
    NSUInteger exceptionHandlingMask = [[NSExceptionHandler defaultExceptionHandler] exceptionHandlingMask];
    Class class = NSClassFromString([[self stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    
    [[NSExceptionHandler defaultExceptionHandler] setExceptionHandlingMask:63];
    
    @try
    {
      if (![class conformsToProtocol:@protocol(FSNSObject)]) class = nil; // This can raise since class might not recognize the conformsToProtocol: message 
    }
    @catch (id exception)
    {
      class = nil; 
    }
    
    // Restore the original exception handling mask   
    [[NSExceptionHandler defaultExceptionHandler] setExceptionHandlingMask:exceptionHandlingMask];  

    return class;
  }
  else return [super representedObject];
}

- (void) setObjectBrowserCellType:(enum FSObjectBrowserCellType)theObjectBrowserCellType { objectBrowserCellType =  theObjectBrowserCellType;}

- (void) setClassLabel:(NSString *)theClassLabel
{ 
  [theClassLabel retain];
  [classLabel release];
  classLabel = theClassLabel;
}

- (void) setLabel:(NSString *)theLabel
{ 
  [theLabel retain];
  [label release];
  label = theLabel;
}

/*- (BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView
{

  NSLog(@"startTrackingAt:");

  return NO;
}*/

@end
