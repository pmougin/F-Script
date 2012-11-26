/*   String.m Copyright 1998,1999 Philippe Mougin.  */
/*   This software is Open Source. See the license.  */  

#import <Foundation/Foundation.h>
#import "FSNSString.h"
#import "FSNSMutableString.h"
#import "FSString.h"
#import "StringPrivate.h"
#import "FScriptFunctions.h"
#import "FSBooleanPrivate.h"
#import "Array.h"
#import "Number.h"
#import "miscTools.h"

@implementation String

///////////////  PRIVATE METHODS

- testaa
{return @"toto";}
 
- didChange
{
  //[inspector objDidChange];
  return self;
}  

- sync
{
/*  if ([inspector edited])
  {
    char *c_string = [inspector getCString];
    [self setCString:c_string];
    free(c_string);
    [inspector setEdited:NO];
  }        */
  return self;
}   
    
- inspectorWillClose
{ 
  [self sync];
 // inspector = nil;
  return self;
}  


//////////////////////////////////// USER METHODS

- (Array *)asArray
{
  return [super asArray];
}

- (Array *) asArrayOfCharacters
{
  return [super asArrayOfCharacters];
}

- (Block *) asBlock
{
  return [super asBlock];
}

- (Block *) asBlockOnError:(Block *)errorBlock
{
  return [super asBlockOnError:errorBlock];
}  

- (id)asClass
{
  return [super asClass];
}

- (NSDate *) asDate
{
  return [super asDate];
}

- (NSString *) capitalizedString
{
  return [[self class] stringWithString:[super capitalizedString]];
}

- (id) connect
{
  return [super connect];
}

- (id) connectOnHost:(String *)operand2
{
  VERIF_OP2_STRING(@"connectOnHost:")
  return [NSConnection rootProxyForConnectionWithRegisteredName:self host:operand2];
}

- (String*) dup
{
  return [[self copy] autorelease];
}  

- (void)insert:(String *)str at:(Number*)index
{
  double ind;
  
  FSVerifClassArgsNoNil(@"insert:at:",2,str,[String class],index,[Number class]);
         
  ind = [index doubleValue];

  if (ind != (NSInteger)ind)
    FSExecError(@"argument 2 of method \"insert:at:\" must be an integer");
                 
  if (ind < 1)
    FSExecError(@"argument 2 of method \"insert:at:\" must be a number "
                  @"greater or equal to 1");
                  
  if (ind > [self length]+1)
    FSExecError(@"argument 2 of method \"insert:at:\" must be a number "
                  @"lesser or equal to the size of the string plus 1");
       
  [self insertString:str atIndex:(NSUInteger)ind-1];
}    

- (NSString *) lowercaseString
{
  return [[self class] stringWithString:[self lowercaseString]];
}   

- (String *)max:(String *)operand2
{
  VERIF_OP2_STRING(@"max:")
  return [self compare:operand2] == NSOrderedDescending ? self : operand2; 
}  

- (String *)min:(String *)operand2
{
  VERIF_OP2_STRING(@"min:")
  return [self compare:operand2] == NSOrderedDescending ? operand2 : self; 
}  

- (String *)operator_plus_plus:(String *)operand2
{
  VERIF_OP2_STRING(@"++")
  return [String stringWithString:[self stringByAppendingString:operand2]];
}  

- (void)operator_less_bar:(id)operand2;
{
  VERIF_OP2_STRING(@"<|")
  [self setValue:operand2];
}  

- (FSBoolean *)operator_greater:(String *)operand2
{ 
  VERIF_OP2_STRING(@">")
return [self compare:operand2] == NSOrderedDescending ? (id)[FSBoolean fsTrue] : (id)[FSBoolean fsFalse];
}

- (FSBoolean *)operator_greater_equal:(String *)operand2 {  
  VERIF_OP2_STRING(@">=")
return [self compare:operand2] != NSOrderedAscending ? (id)[FSBoolean fsTrue] : (id)[FSBoolean fsFalse];  
}    

- (FSBoolean *)operator_less:(String *)operand2 
{
  VERIF_OP2_STRING(@"<")
return [self compare:operand2] == NSOrderedAscending ? (id)[FSBoolean fsTrue] : (id)[FSBoolean fsFalse];  
}    
    
- (FSBoolean *)operator_less_equal:(String *)operand2 
{
  VERIF_OP2_STRING(@"<=")
return [self compare:operand2] != NSOrderedDescending ? (id)[FSBoolean fsTrue] : (id)[FSBoolean fsFalse];  
}   
 
- (String *)operator_period:(Number *)operand2
{
  double ind;
  NSRange range;
  id index = operand2; 
      
  if (index == nil)
    FSExecError(@"index of a string must not be nil"); 
  
  if (! ([index isKindOfClass:[Number class]] || [index isKindOfClass:[Array class]]) )
#warning 64BIT: Check formatting arguments
    FSExecError([NSString stringWithFormat:@"string indexing by %@, instance of Number or Array expected", descriptionForFSMessage(operand2)]);
                                                   
  if ([index isKindOfClass:[Number class]])
  {
    unichar carac;    

    ind = [index doubleValue];

    if (ind != (NSInteger)ind)
      FSExecError(@"index of a string must be an integer");    
                                               
    if (ind < 1)
      FSExecError(@"index of a string must be a number greater or equal "
                    @"to 1");              
    if (ind > [self length])
      FSExecError(@"index of a a string must be a number lesser or equal "
                    @"to the size of the string");
                      
    //range.location = ind-1; range.length =1;
    //return [[[String alloc] initWithString:[self substringWithRange:range]] autorelease];
    carac = [self characterAtIndex:ind-1];  
    return [[[String alloc] initWithCharacters:&carac length:1] autorelease]; 
  }
  else     // [index isKindOfClass:[Array class]]
  {
    String *r;
    NSUInteger i,nb;
    id elem_index;
    
    i = 0;
    nb = [index count];
    
    while (i < nb && [index objectAtIndex:i] == nil) i++; // ignore the nil value
    
    if (i == nb) return (id)[String string];
    
    elem_index = [index objectAtIndex:i];

    if ([elem_index isKindOfClass:[FSBoolean class]])
    {
      FSBoolean *myfsTrue  = [FSBoolean fsTrue];
      FSBoolean *myfsFalse = [FSBoolean fsFalse];
      if (nb != [self length]) FSExecError(@"indexing with an array of boolean of bad size");
      r = (id)[String string];
      
      while (i < nb)
      {
        elem_index = [index objectAtIndex:i];          
        range.location = i; range.length =1;
                
        if (elem_index == myfsTrue)       [r appendString:[self substringWithRange:range]];
        else if (elem_index != myfsFalse) FSExecError(@"indexing with a mixed array");
          
        i++;
        while (i < nb && [index objectAtIndex:i] == nil) i++; // ignore the nil value
      }
    }  
    else if ([elem_index isKindOfClass:[Number class]])
    {
      r = [String stringWithCapacity:nb];
      while (i < nb)
      {        
        elem_index = [index objectAtIndex:i];
        if (![elem_index isKindOfClass:[Number class]])
          FSExecError(@"indexing with a mixed array");
        
        ind = [elem_index doubleValue];

        if (ind != (NSInteger)ind)
          FSExecError(@"index of a string must be an integer");    
                                               
        if (ind < 1)
          FSExecError(@"index of a string must be a number greater or equal "
                      @"to 1");              
        
        if (ind > [self length])
          FSExecError(@"index of a a string must be a number lesser or equal "
                      @"to the size of the string");         
        
        range.location = ind-1; range.length =1;
        [r appendString:[self substringWithRange:range]];
        
        i++;
        while (i < nb && [index objectAtIndex:i] == nil) i++; // ignore the nil value
      }
    }  
    else // elem_index is neither a Number nor a FSBoolean
    {
#warning 64BIT: Check formatting arguments
      FSExecError([NSString stringWithFormat:@"string indexing by an array containing %@"
                                            ,descriptionForFSMessage(elem_index)]);
      return nil; // W
    }
    return r;   
  }         
} 

- (NSString *) description
{
#warning 64BIT: Check formatting arguments
  return [NSString stringWithFormat:@"\'%@\'",[NSString stringWithString:self]];
}   
 
- (String *)reverse
{
  NSUInteger self_length = [self length];
  unichar self_buf[self_length];
  unichar r_buf[self_length];
  NSUInteger i;
  
  [self getCharacters:self_buf];
  
  for (i=0; i < self_length; i++)
    r_buf[i] = self_buf[(self_length-i)-1]; 
  
  return [String stringWithCharacters:r_buf length:self_length];
}

-(Number *)size
{
  return [[[Number alloc] initWithDouble:[self length]] autorelease];
}  

- (String *) uppercase
{
  return [[self class] stringWithString:[self uppercaseString]];
}

///////////////////////////////////// OTHER METHODS

+ (String *)stringWithCapacity:(NSUInteger)capacity
{return [[[String alloc] initWithCapacity:capacity] autorelease]; }

+ (String *)stringWithCharacters:(const unichar *)characters length:(NSUInteger)length
{ return [[[String alloc] initWithCharacters:characters length:length] autorelease]; }

+ (String *)stringWithContentsOfFile:(NSString *)filename
{ return [[[String alloc] initWithContentsOfFile:filename] autorelease]; }

+ (String *)stringWithCString:(const char *)bytes length:(NSUInteger)length
{ return [[[String alloc] initWithCString:bytes length:length] autorelease]; }

+ (String *)stringWithCString:(const char *)bytes
{ return [[[String alloc] initWithCString:bytes] autorelease]; }

#warning 64BIT: Check formatting arguments
+ (String *)stringWithFormat:(NSString *)format, ...
{
  String *r;
  va_list argList;
  
  va_start(argList,format);
#warning 64BIT: Check formatting arguments
  r = [[[String alloc] initWithFormat:format arguments:argList] autorelease];
  va_end(argList);
  return r;
}

+ (String *)stringWithString:(NSString *)string
{
  return [[[[self class] alloc] initWithString:string] autorelease];
}

- (unichar)characterAtIndex:(NSUInteger)anIndex;
{ [self sync]; return [rep characterAtIndex:anIndex]; }

- (Class)classForCoder
{ return [self class]; }

- copy
{ return [[String alloc] initWithString:self]; } 

- (void)dealloc
{
  //printf("\n string : \"%s\" dealloc\n",[self cString]);
  [rep release];
  [super dealloc];
}  

- (void)encodeWithCoder:(NSCoder *)coder
{
  [self sync];
  [super encodeWithCoder:coder];
}

- (void)getCharacters:(unichar *)buffer range:(NSRange)aRange
{
  [self sync];
  [rep getCharacters:buffer range:aRange];
}  

- init
{
  if ((self = [super init]))
  {
    rep = [[NSMutableString allocWithZone:[self zone]] init];
    retainCount = 1;
    return self;
  }
  return nil;    
}

- initWithCapacity:(NSUInteger)capacity
{
  if ((self = [super init]))
  {
    rep = [[NSMutableString allocWithZone:[self zone]] initWithCapacity:capacity];
    retainCount = 1;
    return self;
  }
  return nil;    
}

- initWithCharactersNoCopy:(unichar *)characters length:(NSUInteger)length freeWhenDone:(BOOL)freeBuffer
{
  if ((self = [super init]))
  {
    rep = [[NSMutableString allocWithZone:[self zone]] initWithCharactersNoCopy:characters length:length freeWhenDone:freeBuffer];
    retainCount = 1;
    return self;
  }
  return nil;    
}

- initWithCharacters:(const unichar *)characters length:(NSUInteger)length
{
  if ((self = [super init]))
  {
    rep = [[NSMutableString allocWithZone:[self zone]] initWithCharacters:characters length:length];
    retainCount = 1;
    return self;
  }
  return nil;    
}

- initWithCStringNoCopy:(char *)bytes length:(NSUInteger)length freeWhenDone:(BOOL)freeBuffer
{
  if ((self = [super init]))
  {
    rep = [[NSMutableString allocWithZone:[self zone]] initWithCStringNoCopy:bytes length:length freeWhenDone:freeBuffer];
    retainCount = 1;
    return self;
  }
  return nil;    
}

- initWithCString:(const char *)bytes length:(NSUInteger)length
{
  if ((self = [super init]))
  {
    rep = [[NSMutableString allocWithZone:[self zone]] initWithCString:bytes length:length];
    retainCount = 1;
    return self;
  }
  return nil;    
}

- initWithCString:(const char *)bytes; /* Zero terminated */
{
  if ((self = [super init]))
  {
    rep = [[NSMutableString allocWithZone:[self zone]] initWithCString:bytes];
    retainCount = 1;
    return self;
  }
  return nil;    
}


- initWithString:(NSString *)aString
{
  if ((self = [super init]))
  {
    rep = [[NSMutableString allocWithZone:[self zone]] initWithString:aString];
    retainCount = 1;
    return self;
  }
  return nil;    
}

#warning 64BIT: Check formatting arguments
- initWithFormat:(NSString *)format, ...
{
  if ((self = [super init]))
  {
    va_list argList;
    
    va_start(argList,format);
    retainCount = 1;
#warning 64BIT: Check formatting arguments
    rep = [[NSMutableString allocWithZone:[self zone]] initWithFormat:format arguments:argList];
    va_end(argList);
    return self;
  }
  return nil;    
}

#warning 64BIT: Check formatting arguments
- initWithFormat:(NSString *)format arguments:(va_list)argList
{
  if ((self = [super init]))
  {
    retainCount = 1;
#warning 64BIT: Check formatting arguments
    rep = [[NSMutableString allocWithZone:[self zone]] initWithFormat:format arguments:argList];
    return self;
  }
  return nil;    
}

- initWithData:(NSData *)data encoding:(NSStringEncoding)encoding
{
  if ((self = [super init]))
  {
    retainCount = 1;
    rep = [[NSMutableString allocWithZone:[self zone]] initWithData:data encoding:encoding];
    return self;
  }
  return nil;    
}

- initWithContentsOfFile:(NSString *)path
{
  if ((self = [super init]))
  {
    retainCount = 1;
    rep = [[NSMutableString allocWithZone:[self zone]] initWithContentsOfFile:path];
    return self;
  }
  return nil;    
}


- (id)initWithCoder:(NSCoder *)coder
{
  retainCount = 1;
  self = [super initWithCoder:coder];
  //rep  = [[coder decodeObject] retain];
  return self;
}

// Whitout this method, archiving doesn't work. But this method is undocumented (in PR2 4.2).
- (id)initWithBytes:(void *)bytes length:(NSUInteger)length encoding:(NSStringEncoding)encoding
{
  if ((self = [super init]))
  {
    retainCount = 1;
    rep = [[NSMutableString allocWithZone:[self zone]] initWithBytes:bytes length:length encoding:encoding];
    return self;
  }
  return nil;
}

- (NSUInteger)length
{[self sync] ; return [rep length];} 

- (String *)printString
{
  return [String stringWithString:[self description]];
}

- (void)replaceCharactersInRange:(NSRange)aRange
withString:(NSString *)otherString
{ 
  [self sync]; 
  [rep replaceCharactersInRange:aRange withString:otherString];
  [self didChange];
}

- (id)retain  { retainCount++; return self;}

- (NSUInteger)retainCount  { return retainCount;}

- (void)release  { if (--retainCount == 0) [self dealloc];}  

- setCString:(const char*)cstr
{
  //[inspector setEdited:NO];
  [self setString:[NSString stringWithCString:cstr]];
  return self;
}   

- (void)setValue:(String*)val
{
  //[inspector setEdited:NO];
  [self setString:val];
}   

/*- (StringInspector *)inspector
{return inspector;}*/

@end
