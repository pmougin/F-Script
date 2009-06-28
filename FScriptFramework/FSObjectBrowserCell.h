//  FSObjectBrowserCell.h Copyright (c) 2001-2009 Philippe Mougin.
//  This software is open source. See the license.

#import <AppKit/AppKit.h>

enum FSObjectBrowserCellType {FSOBOBJECT, FSOBCLASS, FSOBMETHOD, FSOBUNKNOWN};

// The BBCLASS type is used to store a class lazily (only the name of the class is stored) in order to not initialize it if not needed.
// The actual initialization will take place when the class object is needed, in the -representedObject method. 

@interface FSObjectBrowserCell : NSBrowserCell 
{
  enum FSObjectBrowserCellType objectBrowserCellType;
  NSString *classLabel;
  NSString *label;
}

+ (NSImage *)branchImage;

- (enum FSObjectBrowserCellType) objectBrowserCellType;
- (NSString *)classLabel;
- (NSString *)label;
- (id)representedObject;
- (void) setObjectBrowserCellType:(enum FSObjectBrowserCellType)theObjectBrowserCellType;
- (void) setClassLabel:(NSString *)theClassLabel;
- (void) setLabel:(NSString *)theLabel;

@end
