//  FSMovieInspector.h Copyright (c) 2003-2006 Philippe Mougin.
//  This software is open source. See the license.

#import <AppKit/AppKit.h>
#import <QTKit/QTKit.h>

@interface FSMovieInspector : NSObject
{
  QTMovie *inspectedObject;
  IBOutlet NSWindow   *window;
  IBOutlet QTMovieView *movieView;
}

+ (FSMovieInspector *)movieInspectorWithMovie:(QTMovie *)movie;

- (FSMovieInspector *)initWithMovie:(QTMovie *)movie;

- (void)windowWillClose:(NSNotification *)aNotification;

@end
