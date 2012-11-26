/* ShellView.m Copyright (c) 1998-2009 Philippe Mougin.     */
/* This software is open source. See the license.           */  
/* This file includes contributions from Stephen C. Gilardi */

#import "ShellView.h"
#import "FSCommandHistory.h"
#import "FSInterpreterView.h"
#import "FSInterpreter.h"
#import "FSMiscTools.h"

#define RETURN    0x0D
#define BACKSPACE 0x7F  // Note SHIFT + BACKSPACE gives 0x08
  
static NSDictionary *errorAttributes; // a dictionary of attributes that defines how an error in a command is shown. 
static BOOL useMaxSize;

@implementation ShellView 

/////////////////////////////// PRIVATE ////////////////////////////

+ (void) setUseMaxSize:(BOOL)shouldUseMaxSize
{
  useMaxSize = shouldUseMaxSize;
}

- (void) replaceCurrentCommandWith:(NSString *)newCommand   // This method is used when the user browse into the command history
{
  [self setSelectedRange:NSMakeRange(start,[[self string] length])];
  [self insertText:newCommand];
  [self moveToEndOfDocument:self];
  [self scrollRangeToVisible:[self selectedRange]];
  lineEdited = NO; 
}

/////////////////////////////// PUBLIC ////////////////////////////

+ (void)initialize  
{
  static BOOL tooLate = NO;
  if (!tooLate) 
  {
    tooLate = YES;
    errorAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: [NSColor whiteColor],NSForegroundColorAttributeName, [NSColor blackColor], NSBackgroundColorAttributeName, nil];    
    useMaxSize = YES;
  }
}

//- (BOOL)acceptsFirstResponder {/*NSLog(@"ShellView acceptsFirstResponder");*/ return YES;}

//- (BOOL)becomeFirstResponder {/*NSLog(@"ShellView becomeFirstResponder");*/  return YES;}

//- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {/*NSLog(@"ShellView acceptsFirstMouse:");*/ return YES;}

- (id)commandHandler { return commandHandler;}

- (NSArray *)completionsForPartialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index
{
  NSString *stringToComplete;
  NSMutableArray *result;
  NSArray *superResult;
  NSUInteger i, count;
  
  superResult = [super completionsForPartialWordRange:charRange indexOfSelectedItem:index];
  
  result = [NSMutableArray arrayWithCapacity:[superResult count]];
  
  if ([commandHandler isKindOfClass:[FSInterpreterView class]])
  {
    NSArray *identifiers = [[[(FSInterpreterView *)commandHandler interpreter] identifiers] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
      
    stringToComplete = [[self string] substringWithRange:charRange];
    //NSLog(stringToComplete); 

    for (i = 0, count = [identifiers count]; i < count; i++)
    {
      NSString *completionCandidate = [identifiers objectAtIndex:i];
      if ([completionCandidate hasPrefix:stringToComplete])
        [result addObject:completionCandidate];
    }
  }
  
  for (i = 0, count = [superResult count]; i < count; i++)
  {
    [result addObject:[superResult objectAtIndex:i]];
  }

  if ([[self delegate] respondsToSelector:@selector(textView:completions:forPartialWordRange:indexOfSelectedItem:)])
    return [[self delegate] textView:self completions:result forPartialWordRange:charRange indexOfSelectedItem:index];
  else
    return result;  
}

- (void) dealloc
{
  //NSLog(@"ShellView dealloc");
  [prompt release];
  [history release];
  if (shouldRetainCommandHandler) [commandHandler release];
  [super dealloc];
}

- (id)initWithFrame:(NSRect)frameRect
{
  return [self initWithFrame:frameRect prompt:@"> " historySize:20000 commandHandler:nil];
} 

- (id)initWithFrame:(NSRect)frameRect prompt:(NSString *)thePrompt historySize:(NSInteger)theHistorySize commandHandler:(id)theCommandHandler
{
  if (self = [super initWithFrame:frameRect])
  {
    prompt             = [thePrompt retain];
    history            = [[FSCommandHistory alloc] initWithUIntSize:theHistorySize];
    parserMode         = NO_DECOMPOSE;
    commandHandler     = [theCommandHandler retain];
    lineEdited         = NO;
    last_command_start = 0;
    shouldRetainCommandHandler = YES;

    [self setUsesFindPanel:YES];
    [self setFont:[NSFont userFixedPitchFontOfSize:-1]]; // -1 to get the default font size
    [self setSelectedRange:NSMakeRange([[self string] length],0)];
    [super insertText:prompt];
    start = [[self string] length];
    [self setDelegate:self];   // A ShellView is its own delegate! (see the section implementing delegate methods)
    maxSize = 900000;
    [self setAllowsUndo:YES];
    return self;
  }
  return nil;
}

- (void)insertText:(id)aString
{
   [super insertText:aString];
}

- (void) notifyUser:(NSString *)notification
{
  NSString *command = [[self string] substringFromIndex:start];
  NSRange selectedRange = [self selectedRange];
  NSInteger delta = [prompt length] + [notification length] + 2;
  
  [self setSelectedRange:NSMakeRange(start,[[self string] length])];
  [self insertText:[NSString stringWithFormat:@"\n%@\n%@%@", notification, prompt, command]];
  [self setFont:[NSFont boldSystemFontOfSize:systemFontSize()] range:NSMakeRange(start, [notification length]+1)];
  start += delta;
  [self setSelectedRange:NSMakeRange(selectedRange.location+delta, selectedRange.length)]; 
} 

- (void)keyDown:(NSEvent *)theEvent  // Called by the AppKit when the user press a key.
{
  //NSLog(@"key = %@",[theEvent characters]);
  //NSLog(@"char0 = %d", (int)[[theEvent characters] characterAtIndex:0]);
  //NSLog(@"modifierFlags = %x",[theEvent modifierFlags]);
  
  if ([theEvent type] != NSKeyDown) 
  {
    [super keyDown:theEvent];
    return;
  }
  
  if ([[theEvent characters] length] == 0) // this is the case in Jaguar for accents 
  {
    [super keyDown:theEvent];
    return;
  }
  
  //unichar theCharacter = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
  unichar theCharacter = [[theEvent characters] characterAtIndex:0];

  NSUInteger theModifierFlags = [theEvent modifierFlags];
  
  // Is the current insertion point valid ?
  if ([self selectedRange].location < start 
      && !(theModifierFlags & NSShiftKeyMask
           && (   theCharacter == NSLeftArrowFunctionKey 
               || theCharacter == NSRightArrowFunctionKey
               || theCharacter == NSUpArrowFunctionKey
               || theCharacter == NSDownArrowFunctionKey)))
  {
    /*    if ([self selectedRange].location < (start - [prompt length]))
    [self moveToEndOfDocument:self];
    else
    [self setSelectedRange:NSMakeRange(start,0)];*/
    
    if ([self selectedRange].location < start)
      [self setSelectedRange:NSMakeRange(start,0)];      
    
    [self scrollRangeToVisible:[self selectedRange]];  
  }
  
  if (theModifierFlags & NSControlKeyMask)
  {
    switch (theCharacter)
    {
      case RETURN:
        [self insertNewlineIgnoringFieldEditor:self];
        break;
      case BACKSPACE:
        [self setSelectedRange:NSMakeRange(start,[[self string] length])];
        [self delete:self];
        break;
      case NSUpArrowFunctionKey:
        [self replaceCurrentCommandWith:[[history goToPrevious] getStr]];
        break;
      case NSDownArrowFunctionKey:
        [self replaceCurrentCommandWith:[[history goToNext] getStr]];
        break;
      default:
        [super keyDown:theEvent];
        break;
    }
  }
  else
  {
    switch (theCharacter)
    {
      case RETURN:
        [self executeCurrentCommand:self];
        break;
      case NSF7FunctionKey:
        [self switchParserMode:self];
        break;
      case NSF8FunctionKey:
        [self parenthesizeCommand:self];
        break;      
      default:
        [super keyDown:theEvent];
        break;
    }
  }
}

- (void)moveToBeginningOfLine:(id)sender
{
  [self setSelectedRange:NSMakeRange(start,0)];
}

- (void)moveToEndOfLine:(id)sender
{
  [self moveToEndOfDocument:sender];
}

- (void)moveToBeginningOfParagraph:(id)sender
{
  [self setSelectedRange:NSMakeRange(start,0)];
}

- (void)moveToEndOfParagraph:(id)sender
{
  [self moveToEndOfDocument:sender];
}

- (void)moveLeft:(id)sender
{
  if ([self selectedRange].location > start)
    [super moveLeft:sender];
}

- (void)moveUp:(id)sender
{  
  // if we are on the first line of current command ==> replace current command by the previous one (history)
  //                                           else ==> apply the normal text editing behaviour.

  NSUInteger loc = [self selectedRange].location;
  [super moveUp:sender];
  
  if ([self selectedRange].location < start || [self selectedRange].location == loc) // moved before start of command || not moved because we are on the first line of the text view
  {
    if ([self selectedRange].location >= start-[prompt length] && [self selectedRange].location < start)
      // we are on the prompt, so we move to the start of the current command (the insertion point should not be on the prompt)
      [self setSelectedRange:NSMakeRange(start,0)];
    else
    {
      [self saveEditedCommand:self];
      [self replaceCurrentCommandWith:[[history goToPrevious] getStr]]; 
    } 
  }
}

- (void)moveDown:(id)sender
{
  // if we are on the last line of current command ==> replace current command by the next one (history)
  //                                          else ==> apply the normal text editing behaviour.
  NSUInteger loc = [self selectedRange].location;
  
  [super moveDown:sender];

  if ([self selectedRange].location == loc || [self selectedRange].location == [[self string] length]) // no movement || move to end of document because we are on the last line
  {
    [self saveEditedCommand:self];
    [self replaceCurrentCommandWith:[[history goToNext] getStr]];
  }
}

- (void)saveEditedCommand:(id)sender
{
  if (lineEdited) // if the current command has been edited by the user, save it in the history.
  {
    NSString *command = [[self string] substringFromIndex:start];
    if ([command length] > 0 && ![command isEqualToString:[history getMostRecentlyInsertedStr]])
    {
      [history addStr:command];
      [history goToPrevious];
    }
  }
}

- (void)parenthesizeCommand:(id)sender
{
  if ([self shouldChangeTextInRange:NSMakeRange(start,0) replacementString:@"("])
  {
    [self replaceCharactersInRange:NSMakeRange(start,0) withString:@"("];
    [self didChangeText];
  }
  if ([self shouldChangeTextInRange:NSMakeRange([self selectedRange].location,0) replacementString:@")"])
  {
    [self replaceCharactersInRange:NSMakeRange([self selectedRange].location,0) withString:@")"];
    [self didChangeText];
  }
  lineEdited = YES;
}

- (void)switchParserMode:(id)sender
{
  if (parserMode == NO_DECOMPOSE)
  {
    [self notifyUser:@"When pasting text in this console, newline and carriage return characters are now interpreted as command separators"];
    parserMode = DECOMPOSE;
    [[self undoManager] removeAllActions];
  }
  else
  {
    [self notifyUser:@"When pasting text in this console, newline and carriage return characters are now NOT interpreted as command separators"];
    parserMode = NO_DECOMPOSE;
    [[self undoManager] removeAllActions];
  }
}

- (void)executeCurrentCommand:(id)sender
{
  NSString *command = [[self string] substringFromIndex:start];
  long overflow;
  
  if (useMaxSize && (overflow = [[self string] length] - maxSize) > 0)
  {
    overflow = overflow + maxSize / 3;
    [self replaceCharactersInRange:NSMakeRange(0,overflow) withString:@""];
    start = start - overflow;
  }    
  
  last_command_start = start;
  if ([command length] > 0 && ![command isEqualToString:[history getMostRecentlyInsertedStr]])
    [history addStr:command];
  [history goToLast];
  [self moveToEndOfDocument:self];
  [self insertText:@"\n"];
  [commandHandler command:command from:self]; // The command handler is notified
  [self insertText:prompt];
  [self scrollRangeToVisible:[self selectedRange]];
  start = [[self string] length];
  lineEdited = NO;
  [[self undoManager] removeAllActions];
}

- (void)paste:(id)sender
{
  NSPasteboard *pb = [NSPasteboard pasteboardByFilteringTypesInPasteboard:[NSPasteboard  generalPasteboard]];
  
  if ([pb availableTypeFromArray:[NSArray arrayWithObject:NSStringPboardType]] == NSStringPboardType)
  {
    NSMutableString *command = [[[pb stringForType:NSStringPboardType] mutableCopy] autorelease];
    
    switch (parserMode)
    {
      case DECOMPOSE: [command replaceOccurrencesOfString:@"\n" withString:@"\r" options:NSLiteralSearch range:NSMakeRange(0, [command length])]; 
                      break;
      case NO_DECOMPOSE: [command replaceOccurrencesOfString:@"\r" withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0, [command length])]; 
                      break;                
    }
    
    [self putCommand:command];
  }  
}

- (void)putCommand:(NSString *)command
{   
    NSCharacterSet *separatorSet;
    NSScanner      *scanner = [NSScanner scannerWithString:command];
    NSString       *subCommand;

    separatorSet = [NSCharacterSet characterSetWithCharactersInString:@"\r"];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@""]]; // because Scanners skip whitespace and newline characters by default
            
    if ([self selectedRange].location < start)
      [self moveToEndOfDocument:self];
              
    if ([scanner scanUpToCharactersFromSet:separatorSet intoString:&subCommand])
      [self insertText:subCommand];
            
    while (![scanner isAtEnd])
    { 
      [scanner scanString:@"\r" intoString:NULL];
      subCommand = [[self string] substringFromIndex:start];
      last_command_start = start;
      if ([subCommand length] > 0)  [history addStr:subCommand];
      [self moveToEndOfDocument:self];
      [self insertText:@"\n"];
      [self scrollRangeToVisible:[self selectedRange]];
      [commandHandler command:subCommand from:self]; // notify the command handler
      // NSLog(@"puting command : %@",subCommand);
      [self insertText:prompt];
      start = [[self string] length];
      lineEdited = NO;
      subCommand = @"";  
      [scanner scanUpToCharactersFromSet:separatorSet intoString:&subCommand];
      if ([subCommand length] > 0)  [self insertText:subCommand];
      [self scrollRangeToVisible:[self selectedRange]];    
    } 
} 

- (void)putText:(NSString *)text
{
  [self moveToEndOfDocument:self];
  [self insertText:text];
  start = [[self string] length];
  [self scrollRangeToVisible:[self selectedRange]];
}

- (void)setCommandHandler:handler
{  
  if (shouldRetainCommandHandler)
  {
    [handler retain];
    [commandHandler release];
  }
  commandHandler = handler;
}

- (void)setShouldRetainCommandHandler:(BOOL)shouldRetain
{
  if (shouldRetainCommandHandler == YES && shouldRetain == NO)
    [commandHandler release];
  else if (shouldRetainCommandHandler == NO && shouldRetain == YES) 
    [commandHandler retain];
  shouldRetainCommandHandler = shouldRetain;
}

- (BOOL)shouldRetainCommandHandler { return shouldRetainCommandHandler;}

- (void)showErrorRange:(NSRange)range
{
  NSTextStorage *theTextStore = [self textStorage];
 
  range.location += last_command_start;
  
  // The folowing instruction gives an better visual result.
  // Note that for it to work, showError:, the current method, must be called before outputing any error message
  // due to the use of the text's length in the test. 
  if (range.location + range.length >= [[self string] length] && range.length > 1) range.length--;

  if ([self shouldChangeTextInRange:range replacementString:nil]) 
  { 
    [theTextStore beginEditing];
    [theTextStore addAttributes:errorAttributes range:range];
    [theTextStore endEditing]; 
    [self didChangeText]; 
  }
}

// I implement this method, inherited from NSTextView,in order to prevent 
// the "smart delete" to delete parts of the prompt (in practice, this 
// was seen when the prompt ends with whithespace) 
- (NSRange)smartDeleteRangeForProposedRange:(NSRange)proposedCharRange 
{
  NSRange r = [super smartDeleteRangeForProposedRange:proposedCharRange]; 
  
  if (proposedCharRange.location >= start && r.location < start) 
  {
    r.length   = r.length - (start - r.location) ;
    r.location = start;
  }
  
  return r;   
}

///////////////////////// Delegate methods /////////////////

// Since a CLIView is his own delegate, it receives the NSTextView(its super class) delegate calls.

- (BOOL)textView:(NSTextView *)aTextView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString
{
  // policy: do not accept a modification outside the current command.
    
  if (replacementString && affectedCharRange.location < start)
  {
      NSBeep();
      return NO;
  }
  else
  {
    lineEdited = YES;
    return YES;
  }
}

@end
