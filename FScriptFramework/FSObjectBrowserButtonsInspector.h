//  FSObjectBrowserButtonsInspector.h Copyright (c) 2002-2009 Philippe Mougin.
//  This software is open source. See the license.

#import <Cocoa/Cocoa.h>

@interface FSObjectBrowserButtonsInspector : NSObject 
{
  IBOutlet NSWindow *window;
   
  IBOutlet NSTextField *t1;
  IBOutlet NSTextField *t2;
  IBOutlet NSTextField *t3; 
  IBOutlet NSTextField *t4;
  IBOutlet NSTextField *t5;
  IBOutlet NSTextField *t6;
  IBOutlet NSTextField *t7;
  IBOutlet NSTextField *t8;
  IBOutlet NSTextField *t9;
  IBOutlet NSTextField *t10;
  
  IBOutlet NSButton *b1;
  IBOutlet NSButton *b2;
  IBOutlet NSButton *b3;
  IBOutlet NSButton *b4;
  IBOutlet NSButton *b5;
  IBOutlet NSButton *b6;
  IBOutlet NSButton *b7;
  IBOutlet NSButton *b8;
  IBOutlet NSButton *b9;
  IBOutlet NSButton *b10;
}

-(void) activate;

@end
