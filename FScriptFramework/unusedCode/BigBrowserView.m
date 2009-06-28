//  BigBrowserView.m Copyright 2000 Philippe Mougin.
//  This software is Open Source. See the license.

#import "build_config.h"

#ifdef BUILD_WITH_APPKIT
//-----------------------------------------------------------------------
// BigBowserView is compiled only if we are using AppKit

#import "BigBrowserView.h"
#import <objc/objc-class.h>
#import "Compiler.h"
#import "ExecEngine.h"
#import "NSBrowserBugFix.h"
#import "FSInterpreter.h"

@implementation BigBrowserView

- (void) dealloc
{
  //NSLog(@"BigBrowserView dealloc");
  [rootObject release];
  [interpreter release];
  [argumentsWindow release];
  [b1 release];
  [b2 release];
  [super dealloc];
}

- (void)disable { isDisabled = YES; [[[self subviews] objectAtIndex:0] replacementForBuggySetEnabled:NO]; }

- (void)enable  { isDisabled = NO;  [[[self subviews] objectAtIndex:0] replacementForBuggySetEnabled:YES];}

- (id)initWithFrame:(NSRect)frameRect
{
  if ([super initWithFrame:frameRect])
  { 
    CGFloat baseWidth  = NSWidth([self bounds]);
    CGFloat baseHeight = NSHeight([self bounds]);
    
    twoLevelsEnabled = YES;
    
    b1 = [[NSBrowser alloc] initWithFrame:NSMakeRect(0,baseHeight/2,baseWidth,baseHeight/2)];
    b2 = [[NSBrowser alloc] initWithFrame:NSMakeRect(0,0,baseWidth,baseHeight/2)];
    
    [b1 setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable | NSViewMinYMargin];
    [b2 setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable | NSViewMaxYMargin];
    [self addSubview:b1];
    [self addSubview:b2];
  
    [b1 setHasHorizontalScroller:YES];
    [b1 setMinColumnWidth:130];
    // [b setAcceptsArrowKeys:YES];
    [b1 setDelegate:self];
    
    [b2 setHasHorizontalScroller:YES];
    [b2 setMinColumnWidth:130];
    // [b setAcceptsArrowKeys:YES];
    [b2 setDelegate:self];

    isDisabled = NO;

    return self;
  }
  return nil;
}

- (void)fillMatrix:(NSMatrix *)matrix withMethodsForObject:(id)object
{
  Class cls = [object class];
  
  while (cls)
  {      
    void *iterator = 0;
    struct objc_method_list *mlist;
    NSInteger i;
    NSBrowserCell *cell;
    NSColor *txtColor = [NSColor blueColor];
    NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:txtColor, NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *attrStr = [[[NSMutableAttributedString alloc] initWithString:[cls description] attributes:txtDict] autorelease];
    
    [attrStr setAlignment:NSCenterTextAlignment range:NSMakeRange(0,[attrStr length])];

    [matrix addRow];
    cell = [matrix cellAtRow:[matrix numberOfRows]-1 column:0];
    [cell setLeaf:YES];
    [cell setEnabled:NO];
    [cell setAttributedStringValue:attrStr];
                
    while ( mlist = class_nextMethodList( cls, &iterator ) )
    {
      for (i = 0; i < mlist->method_count; i++)
      {
        [matrix addRow];
        cell = [matrix cellAtRow:[matrix numberOfRows]-1 column:0];
        [cell setStringValue:[Compiler stringFromSelector:mlist->method_list[i].method_name]];
      }
    }
    
    // add a blank line
    [matrix addRow];
    cell = [matrix cellAtRow:[matrix numberOfRows]-1 column:0];
    [cell setLeaf:YES];
    [cell setEnabled:NO];
    
    cls = [cls superclass];
  }    
}


- (void)fillMatrix:(NSMatrix *)matrix withObject:(id)object
{
  NSBrowserCell *cell;
   
  [matrix addRow];
  cell = [matrix cellAtRow:[matrix numberOfRows]-1 column:0];
  [cell setRepresentedObject:object];
  if (object == nil)
  {
    [cell setStringValue:@"nil"];  
    [cell setLeaf:YES];
  }
  else 
  { 
    NSString *description = [object description];
    if ([description length] > 410) description = [description substringWithRange:NSMakeRange(0,400)];
    [cell setStringValue:description];
  }
  if ([object respondsToSelector:@selector(objectEnumerator)])
  {
    NSEnumerator *enumerator = [object objectEnumerator];
    id elem;
    
    // add a blank line
    [matrix addRow];
    cell = [matrix cellAtRow:[matrix numberOfRows]-1 column:0];
    [cell setLeaf:YES];
    [cell setEnabled:NO];
	
    while ((elem = [enumerator nextObject])) 
    {
      [matrix addRow];
      cell = [matrix cellAtRow:[matrix numberOfRows]-1 column:0];
      [cell setRepresentedObject:elem];
      if (elem == nil)
      {
        [cell setStringValue:@"nil"];  
        [cell setLeaf:YES];
      }
      else 
      { 
        NSString *description = [elem description];
        if ([description length] > 410) description = [description substringWithRange:NSMakeRange(0,400)];
        [cell setStringValue:description];
      }
    }
  }
}


- (void) sendMessageTo:(id)receiver selectorString:(NSString *)selectorStr arguments:(NSArray *)arguments fillThisMatrixWithResult:(NSMatrix *)matrix
{ 
  NSInteger nbarg = [arguments count];
  id args[nbarg+2]; 
  SEL selector = [Compiler selectorFromString:selectorStr];
  NSInteger i;
  id result;
  NSString *errorString = nil;
    
  args[0] = receiver;
  args[1] = (id)selector;
  for (i = 0; i < nbarg; i++) args[i+2] = [arguments objectAtIndex:i];
  
  NS_DURING
  
    result = sendMsgNoPattern(receiver, selector, selectorStr, nbarg+2, args,[MsgContext msgContext]);
  
  NS_HANDLER
  
    // errorString = [NSString stringWithFormat:@"%@ : %@",[localException name], [localException reason]];
    errorString =  [localException reason];
    
  NS_ENDHANDLER
  
  if (errorString) NSRunAlertPanel(@"ERROR", errorString, @"Ok", nil, nil,nil);
  else             [self fillMatrix:matrix withObject:result];
}

- (void)browser:(NSBrowser *)sender createRowsForColumn:(NSInteger)column inMatrix:(NSMatrix *)matrix // We are our own delegate !
{
  if (twoLevelsEnabled)
  {    
    NSInteger i, nb;
    NSMatrix *m;
    
    if (sender == b1)
    {    
      if (column == 0) 
      {
#warning 64BIT: Check formatting arguments
        NSLog(@"b1 column 0");
        [self fillMatrix:matrix withObject:rootObject];
      }  
      else 
      {
        [b2 setLastColumn:column-1];
        for (i = 0, m = [b2 matrixInColumn:column-1], nb = [m numberOfRows]; i < nb; i++) 
          [m removeRow:0];
        [self fillMatrix:m withMethodsForObject:[[b1 selectedCell] representedObject]];
        [b2 tile];
      }
    }
    else // sender == b2
    {
      if (column != 0) 
      {
        NSString *selectedString    = [[b2 selectedCell] stringValue];
        SEL selector                = [Compiler selectorFromString:selectedString];
        NSArray *selectorComponents = [NSStringFromSelector(selector) componentsSeparatedByString:@":"];
        NSInteger nbarg                   = [selectorComponents count]-1;
        id selectedObject           = [[b1 selectedCellInColumn:column-1] representedObject];
        
        [b1 setLastColumn:column];
        for (i = 0, m = [b1 matrixInColumn:column], nb = [m numberOfRows]; i < nb; i++) 
          [m removeRow:0];
        if (nbarg == 0)
        {
          [self sendMessageTo:selectedObject selectorString:selectedString arguments:[NSArray array] fillThisMatrixWithResult:[b1 matrixInColumn:column]];
          [b1 tile];
        }  
        else
        {
          NSInteger i;
          NSInteger baseWidth  = 300;
          NSInteger baseHeight = nbarg*30+55;
          NSButton *button;
          NSForm *f;
          
          argumentsWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(100,100,baseWidth,baseHeight)   styleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask backing:NSBackingStoreBuffered defer:false];
          
          [argumentsWindow setDelegate:self];
          [argumentsWindow setTitle:@"Arguments"];
          [argumentsWindow setMinSize:NSMakeSize(130,80)];
          [argumentsWindow setLevel:NSFloatingWindowLevel];
          
          f = [[[NSForm alloc] initWithFrame:NSMakeRect(10,55,baseWidth-20,baseHeight-65)] autorelease];
          [f setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
          [[argumentsWindow contentView] addSubview:f]; // The form must be the first subview 
                                          // (this is used by method sendMessageButton:)
          
          button = [[[NSButton alloc] initWithFrame:NSMakeRect(baseWidth/2-40,5,110,30)] autorelease];
          [button setBezelStyle:1];
          [button setTitle:@"Send message"];   
          [button setAction:@selector(sendMessageButton:)];
          [button setTarget:self];
          [[argumentsWindow contentView] addSubview:button];
          
          if (nbarg == 1 && [[selectorComponents objectAtIndex:0] hasPrefix:@"operator_"]) [f addEntry:selectedString];
          else for (i = 0; i < nbarg; i++) [f addEntry:[[selectorComponents objectAtIndex:i] stringByAppendingString:@":"]];
          
          [f setAutosizesCells:YES];  
          
          [argumentsWindow makeKeyAndOrderFront:nil];
          
          [self disable];
        }          
      }    
    }

  }
  else
  {
    if (column == 0)
    {    
      [self fillMatrix:matrix withObject:rootObject];
    }
    else if ( ((CGFloat)column)/2 != (NSInteger)(column/2) )
    {
      id selectedObject = [[[[self subviews] objectAtIndex:0] selectedCell] representedObject];
      Class cls = [selectedObject class];
      
      while (cls)
      {      
        void *iterator = 0;
        struct objc_method_list *mlist;
        NSInteger i;
        NSBrowserCell *cell;
        NSColor *txtColor = [NSColor blueColor];
        NSDictionary *txtDict = [NSDictionary dictionaryWithObjectsAndKeys:txtColor, NSForegroundColorAttributeName, nil];
        NSMutableAttributedString *attrStr = [[[NSMutableAttributedString alloc] initWithString:[cls description] attributes:txtDict] autorelease];
        
        [attrStr setAlignment:NSCenterTextAlignment range:NSMakeRange(0,[attrStr length])];
  
        [matrix addRow];
        cell = [matrix cellAtRow:[matrix numberOfRows]-1 column:0];
        [cell setLeaf:YES];
        [cell setEnabled:NO];
        [cell setAttributedStringValue:attrStr];
                    
        while ( mlist = class_nextMethodList( cls, &iterator ) )
        {
          for (i = 0; i < mlist->method_count; i++)
          {
            [matrix addRow];
            cell = [matrix cellAtRow:[matrix numberOfRows]-1 column:0];
            [cell setStringValue:[Compiler stringFromSelector:mlist->method_list[i].method_name]];
          }
        }
        
        // add a blank line
        [matrix addRow];
        cell = [matrix cellAtRow:[matrix numberOfRows]-1 column:0];
        [cell setLeaf:YES];
        [cell setEnabled:NO];
        
        cls = [cls superclass];
      }    
    }
    else
    {    
      NSString *selectedString    = [[[[self subviews] objectAtIndex:0] selectedCell] stringValue];
      SEL selector                = [Compiler selectorFromString:selectedString];
      NSArray *selectorComponents = [NSStringFromSelector(selector) componentsSeparatedByString:@":"];
      NSInteger nbarg                   = [selectorComponents count]-1;
      id selectedObject           = [[[[self subviews] objectAtIndex:0] selectedCellInColumn:column-2] representedObject];
      
      if (nbarg == 0)
        [self sendMessageTo:selectedObject selectorString:selectedString arguments:[NSArray array] fillThisMatrixWithResult:matrix];
      else
      {
        NSInteger i;
        NSInteger baseWidth  = 300;
        NSInteger baseHeight = nbarg*30+55;
        NSButton *button;
        NSForm *f;
        
        argumentsWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(100,100,baseWidth,baseHeight)   styleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask backing:NSBackingStoreBuffered defer:false];
        
        [argumentsWindow setDelegate:self];
        [argumentsWindow setTitle:@"Arguments"];
        [argumentsWindow setMinSize:NSMakeSize(130,80)];
        [argumentsWindow setLevel:NSFloatingWindowLevel];
        
        f = [[[NSForm alloc] initWithFrame:NSMakeRect(10,55,baseWidth-20,baseHeight-65)] autorelease];
        [f setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [[argumentsWindow contentView] addSubview:f]; // The form must be the first subview 
                                        // (this is used by method sendMessageButton:)
        
        button = [[[NSButton alloc] initWithFrame:NSMakeRect(baseWidth/2-40,5,110,30)] autorelease];
        [button setBezelStyle:1];
        [button setTitle:@"Send message"];   
        [button setAction:@selector(sendMessageButton:)];
        [button setTarget:self];
        [[argumentsWindow contentView] addSubview:button];
        
        if (nbarg == 1 && [[selectorComponents objectAtIndex:0] hasPrefix:@"operator_"]) [f addEntry:selectedString];
        else for (i = 0; i < nbarg; i++) [f addEntry:[[selectorComponents objectAtIndex:i] stringByAppendingString:@":"]];
        
        [f setAutosizesCells:YES];  
        
        [argumentsWindow makeKeyAndOrderFront:nil];
        
        [self disable];
      }
    } 
  }  
}

- (void)sendMessageButton:(NSButton *)button
{ 
  if (twoLevelsEnabled)
  {
    NSString *selectedString = [[b2 selectedCell] stringValue];
    id selectedObject = [[b1 selectedCellInColumn:[b1 lastColumn]-1] representedObject];
    NSForm *f = [[[[button window] contentView] subviews] objectAtIndex:0];
    NSInteger nbarg = [f numberOfRows];
    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:nbarg];
    NSInteger i;
    
    for (i = 0; i < nbarg; i++) 
    { 
      NSFormCell *cell = [f cellAtIndex:i];
      NSString *argumentString = [cell stringValue]; 
      FSInterpreterResult *result = [interpreter execute:argumentString];
      
      if ([result isOk])
        [arguments addObject:[result result]];
      else  
      {
#warning 64BIT: Check formatting arguments
        NSMutableString *errorArgumentString = [NSString stringWithFormat:@"Argument %d %@", i+1, [result errorMessage]];
      [f selectTextAtIndex:i];
      
      NSRunAlertPanel(@"ERROR", errorArgumentString, @"Ok", nil, nil,nil);
      
      // An alternative for displaying the error message. Not yet functionnal.
      /* 
        NSMutableString *errorArgumentString = [NSMutableString stringWithString:argumentString];
        NSBeep();
        [errorArgumentString insertString:[result errorMessage] atIndex:[result errorRange].location];
        [cell setStringValue:errorArgumentString];
        [cell selectWithFrame:NSMakeRect(0,0,[cell cellSize].width,[cell cellSize].height) inView:[cell controlView] editor:[f currentEditor] delegate:self start:[result errorRange].location length:[result errorRange].length]; */
        
        break;
      }
    }
    
    if (i == nbarg) // There were no error evaluating the arguments
    {
      [self sendMessageTo:selectedObject selectorString:selectedString arguments:arguments fillThisMatrixWithResult:[b1 matrixInColumn:[b1 lastColumn]]];
      [b1 tile];  
      [[button window] close];
    } 
  }
  else
  {
  
    NSBrowser *browser = [[self subviews] objectAtIndex:0];
    NSString *selectedString = [[browser selectedCell] stringValue];
    id selectedObject = [[browser selectedCellInColumn:[browser selectedColumn]-1] representedObject];
    NSForm *f = [[[[button window] contentView] subviews] objectAtIndex:0];
    NSInteger nbarg = [f numberOfRows];
    NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:nbarg];
    NSInteger i;
    
    for (i = 0; i < nbarg; i++) 
    { 
      NSFormCell *cell = [f cellAtIndex:i];
      NSString *argumentString = [cell stringValue]; 
      FSInterpreterResult *result = [interpreter execute:argumentString];
      
      if ([result isOk])
        [arguments addObject:[result result]];
      else  
      {
#warning 64BIT: Check formatting arguments
        NSMutableString *errorArgumentString = [NSString stringWithFormat:@"Argument %d %@", i+1, [result errorMessage]];
      [f selectTextAtIndex:i];
      
      NSRunAlertPanel(@"ERROR", errorArgumentString, @"Ok", nil, nil,nil);
      
      // An alternative for displaying the error message. Not yet functionnal.
      /* 
        NSMutableString *errorArgumentString = [NSMutableString stringWithString:argumentString];
        NSBeep();
        [errorArgumentString insertString:[result errorMessage] atIndex:[result errorRange].location];
        [cell setStringValue:errorArgumentString];
        [cell selectWithFrame:NSMakeRect(0,0,[cell cellSize].width,[cell cellSize].height) inView:[cell controlView] editor:[f currentEditor] delegate:self start:[result errorRange].location length:[result errorRange].length]; */
        
        break;
      }
    }
    
    if (i == nbarg) // There were no error evaluating the arguments
    {
      [self sendMessageTo:selectedObject selectorString:selectedString arguments:arguments fillThisMatrixWithResult:[browser matrixInColumn:[browser lastColumn]]];
      [browser tile];  
      [[button window] close];
    }  
  }
}

-(void) setInterpreter:(FSInterpreter *)theInterpreter
{
  interpreter = [theInterpreter retain];
}

-(void) setRootObject:(NSArray *)theRootObject
{
  rootObject = [theRootObject retain];
}

- (void)windowWillClose:(NSNotification *)aNotification
// Invoked when argumentsWindow is about to close
{
  argumentsWindow = nil; 
  // Note: We don't send "release" because the window will automatically release itself (TODO: test this)
  [self enable];
} 

@end

#endif