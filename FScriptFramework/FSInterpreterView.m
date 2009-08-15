/* FSInterpreterView.m Copyright (c) 1998-2009 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import "build_config.h"
#import "FSVoid.h"
#import "FSArray.h"
#import "FSInterpreterResult.h"
#import <objc/objc.h>
#import "FSObjectBrowser.h"
#import "FSMiscTools.h"
#import "CLIView.h"
#import "FSInterpreter.h"
#import "FSInterpreterView.h"

 
static BOOL isEmpty(NSString *str)
{
  NSInteger i = 0;
  NSInteger length = [str length];
  NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  
  while (i < length && [set characterIsMember:[str characterAtIndex:i]])
    i++;
  return (i == length);
}  

@interface FSInterpreterView(FSInterpreterViewPrivate)
- (CLIView *)cliView;
@end

@implementation FSInterpreterView

+ (void)initialize
{ 
  //NSLog(@"FSInterpreterView +initialize");
  NSMutableDictionary *registrationDict = [NSMutableDictionary dictionary];

  [registrationDict setObject:[NSNumber numberWithDouble:[[NSFont userFixedPitchFontOfSize:-1] pointSize]] forKey:@"FScriptFontSize"];
  [[NSUserDefaults standardUserDefaults] registerDefaults:registrationDict];
}

///////////////// First responder hack

- (BOOL)acceptsFirstResponder {return YES;}

- (BOOL)becomeFirstResponder {[[self window] performSelector:@selector(makeFirstResponder:) withObject:[[[[self cliView] subviews] objectAtIndex:0] documentView] afterDelay:0]; return YES;}

/////////////////

/*- (BOOL)acceptsFirstResponder {NSLog(@"FSInterpreterView acceptsFirstResponder"); return NO;}

- (BOOL)becomeFirstResponder {NSLog(@"FSInterpreterView becomeFirstResponder"); return YES;}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {NSLog(@"FSInterpreterView acceptsFirstMouse:"); return YES;}

  // Returns YES if view supports auto selection of its deepest elements
- (BOOL)ibSupportsInsideOutSelection {NSLog(@"FSInterpreterView ibSupportsInsideOutSelection"); return YES;}

  // Returns YES if view is a container
- (BOOL)ibIsContainer {NSLog(@"FSInterpreterView ibIsContainer"); return YES;}

- (id)views {NSLog(@"FSInterpreterView views"); return [self subviews];}

- (id)realSubviews {NSLog(@"FSInterpreterView realSubviews"); return [NSArray array];}

- (id)documentView {NSLog(@"FSInterpreterView documentView"); return [self cliView];}

- (id)textViews {NSLog(@"FSInterpreterView textViews"); return [self subviews];}
*/


- (void)command:(NSString *)aString from:sender
{
  FSInterpreterResult *execResult;

  if (isEmpty(aString)) return;

  execResult = [interpreter execute:aString];

  if ([execResult isOK])
  {
    id result = [execResult result]; 
    NSString *str = printStringLimited(result, 10000);

    [sender putText:str];

    if ([str length] == 0) [sender putText:@"\n"];  
    else [sender putText:@"\n\n"];
  }
  else if ([execResult isSyntaxError])
  {
    [sender showErrorRange:[execResult errorRange]]; 
    [sender putText:[NSString stringWithFormat:@"\n%@, character %lu\n\n",[execResult errorMessage],(unsigned long)([execResult errorRange].location)]];
  }
  else // [execresult isExecutionError]
  {    
    [sender showErrorRange:[execResult errorRange]];
    [sender putText:@"\n"];
    [sender putText:[execResult errorMessage]];
    [sender putText:@"\n\n"];
    [execResult inspectBlocksInCallStack];
  //  [[self window] makeKeyAndOrderFront:nil];
  }
}

- (void) dealloc
{
  //NSLog(@"FSInterpreterView dealloc");
  [interpreter release];
  [super dealloc];
}

- (NSString *)editorClassName
{
  return [NSString stringWithCString:"FSInterpreterViewEditor"];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
  //id sub;
  //(@"removing subview");
  //sub = [[[[self subviews] objectAtIndex:0] documentView] retain];
  //[[[self subviews] objectAtIndex:0] setDocumentView:nil];
  
  //sub = [[[self subviews] objectAtIndex:0] retain];
  //[sub removeFromSuperview];

  [super encodeWithCoder:coder];

  if ([coder allowsKeyedCoding]) 
  {
    [coder encodeObject:interpreter forKey:@"interpreter"];
  }
  else
  {
    [coder encodeObject:interpreter];
  }  

  //[[[self subviews] objectAtIndex:0] setDocumentView:sub]; 
  //[self addSubview:sub];
  //[sub release];
}

- (CGFloat)fontSize
{ return [[self cliView] fontSize]; }

/*- (id) _init
{
    //NSScrollView *scrollview = [[self subviews] objectAtIndex:0];
    NSScrollView *scrollview =[[[NSScrollView alloc] initWithFrame:[self bounds]] autorelease];
    NSSize contentSize = [scrollview contentSize];
    ShellView *shellView; 

    //NSLog(@"FSInterpreterView _init");

    //[self setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];

    [scrollview setBorderType:NSNoBorder];
    [scrollview setHasVerticalScroller:YES];
    [scrollview setHasHorizontalScroller:NO];
    [scrollview setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable]; 

    shellView = [[[ShellView alloc] initWithFrame:NSMakeRect(0, 0,[scrollview contentSize].width, [scrollview contentSize].height)] autorelease];
    [shellView setMinSize:(NSSize){0.0, contentSize.height}];
    [shellView setMaxSize:(NSSize){1e7, 1e7}];
    [shellView setVerticallyResizable:YES];
    [shellView setHorizontallyResizable:NO];
    [shellView setAutoresizingMask:NSViewWidthSizable ];//| NSViewHeightSizable];
    [[shellView textContainer] setWidthTracksTextView:YES];

    [shellView setCommandHandler:self];
    [shellView setShouldRetainCommandHandler:NO]; // to avoid a cycle

    [scrollview setDocumentView:shellView];
    [self addSubview:scrollview];
    [self setFontSize:[[NSUserDefaults standardUserDefaults] floatForKey:@"FScriptFontSize"]];
    
    return self;
} */

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  [self setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
  [[self cliView] setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
  [self setAutoresizesSubviews:YES];
  [self setFontSize:[[NSUserDefaults standardUserDefaults] floatForKey:@"FScriptFontSize"]];
  
  if ([coder allowsKeyedCoding]) 
  {
    interpreter = [[coder decodeObjectForKey:@"interpreter"] retain];  
  }
  else
  {
    interpreter = [[coder decodeObject] retain];  
  }  
  return self;
}

- (id)initWithFrame:(NSRect)frameRect
{
  self = [super initWithFrame:frameRect];
  if (self)
  {
    CLIView *cliView =[[[CLIView alloc] initWithFrame:[self bounds]] autorelease]; 
    
    [cliView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable]; 
    [cliView setCommandHandler:self];
    [cliView setShouldRetainCommandHandler:NO]; // to avoid a cycle
    [self addSubview:cliView];
    //[self setAutoresizesSubviews:YES];
    [self setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable]; 
    [self setFontSize:[[NSUserDefaults standardUserDefaults] floatForKey:@"FScriptFontSize"]];
    
    interpreter = [[FSInterpreter alloc] init];
  }
  return self;
}

- (FSInterpreter *)interpreter
{
  return interpreter;
}

- (void)newBigBrowser:sender // deprecated
{
  FSObjectBrowser *bb = [FSObjectBrowser objectBrowserWithRootObject:nil interpreter:interpreter];
  [bb browseWorkspace];
  [bb makeKeyAndOrderFront:nil];  
}

- (void) notifyUser:(NSString *)message
{
  [[self cliView] notifyUser:message];  
}

- (void)putCommand:(NSString *)command
{
  [[self cliView] putCommand:command];
}

- (void)setFontSize:(CGFloat)theSize
{
  [[self cliView] setFontSize:theSize];
}

-(void) setObject1:(id)obj
{
  //NSLog(@"FSInterpreterView, setObject1:");
  [interpreter setObject:obj forIdentifier:@"object1"];
}

-(void) setObject2:(id)obj {[interpreter setObject:obj forIdentifier:@"object2"];}

-(void) setObject3:(id)obj {[interpreter setObject:obj forIdentifier:@"object3"];}

-(void) setObject4:(id)obj {[interpreter setObject:obj forIdentifier:@"object4"];}

-(void) setObject5:(id)obj {[interpreter setObject:obj forIdentifier:@"object5"];} 

-(void) setObject6:(id)obj {[interpreter setObject:obj forIdentifier:@"object6"];}

-(void) setObject7:(id)obj {[interpreter setObject:obj forIdentifier:@"object7"];}

-(void) setObject8:(id)obj {[interpreter setObject:obj forIdentifier:@"object8"];}

-(void) setObject9:(id)obj {[interpreter setObject:obj forIdentifier:@"object9"];}

-(void) setInterpreter:(FSInterpreter *)theInterpreter
{
  [theInterpreter retain];
  [interpreter release];
  interpreter = theInterpreter; 
}

- (CLIView *)cliView
{
  return [[self subviews] objectAtIndex:0];
}

@end