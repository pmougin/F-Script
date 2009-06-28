/*   SymbolTable.m Copyright (c) 1998-2005 Philippe Mougin.  */
/*   This software is open source. See the license.  */  


#import "SymbolTable.h"
#import "Number.h"
#import "Array.h"
#import "FSBoolean.h"
#import "Space.h"
#import <Foundation/Foundation.h>
#import "FSUnarchiver.h"
#import "FSKeyedUnarchiver.h"
 

@implementation SymbolTableValueWrapper

- (id)copy
{ return [self copyWithZone:NULL]; }
 
- (id)copyWithZone:(NSZone *)zone
{
  return [[SymbolTableValueWrapper allocWithZone:zone]
               initWrapperWithValue:value 
                               type:type
                             symbol:symbol
                             status:status];
}                             

- (void)dealloc
{ 
  [symbol release];
  [value release];
  [super dealloc]; 
}  

- (void)encodeWithCoder:(NSCoder *)coder
{
  if ([coder allowsKeyedCoding]) 
  {
    [coder encodeInteger:type forKey:@"type"];
    [coder encodeInteger:status forKey:@"status"];
    [coder encodeObject:value  forKey:@"value"];
    [coder encodeObject:symbol forKey:@"symbol"];
  }
  else
  {
#warning 64BIT: Inspect use of @encode
    [coder encodeValueOfObjCType:@encode(typeof(type)) at:&type];
#warning 64BIT: Inspect use of @encode
    [coder encodeValueOfObjCType:@encode(typeof(status)) at:&status];
    [coder encodeObject:value];
    [coder encodeObject:symbol];
  }  
}

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super init];
  retainCount = 1;

  if ([coder allowsKeyedCoding]) 
  {
    type =   [coder decodeIntegerForKey:@"type"];
    status = [coder decodeIntegerForKey:@"status"];
    value  = [[coder decodeObjectForKey:@"value" ] retain];
    symbol = [[coder decodeObjectForKey:@"symbol"] retain];
  }
  else
  {
#warning 64BIT: Inspect use of @encode
    [coder decodeValueOfObjCType:@encode(typeof(type)) at:&type];
#warning 64BIT: Inspect use of @encode
    [coder decodeValueOfObjCType:@encode(typeof(status)) at:&status];
    value  = [[coder decodeObject] retain];
    symbol = [[coder decodeObject] retain];
  }  
  return self;
}

- initWrapperWithValue:(id)theValue type:(enum SymbolTable_value_type)theType
                 symbol:(NSString *)theSymbol;
{
  return [self initWrapperWithValue:theValue type:theType symbol:theSymbol  status:DEFINED];
}  

- initWrapperWithValue:(id)theValue type:(enum SymbolTable_value_type)theType
               symbol:(NSString *)theSymbol 
               status:(enum SymbolTable_symbol_status)theStatus;
{
  if ((self = [super init]))
  {
    retainCount = 1;
    type   = theType;
    status = theStatus; 
    value = [theValue retain];
    symbol = [theSymbol retain];
    return self;
  }
  return nil;
}

- (id)retain  { retainCount ++; return self;}

- (NSUInteger)retainCount  { return retainCount;}

- (void)release  { if (--retainCount == 0) [self dealloc];}  

- (void)setValue:(id)theValue
{
  id oldValue = value;
  value = [theValue retain];
  [oldValue release];
}  

- (enum SymbolTable_symbol_status)status
{ return status;}

- (NSString *)symbol
{ return symbol;}

- (enum SymbolTable_value_type)type
{ return type;}

- (id)value
{ return value;}

@end

/////////////////////////////////////////// SymbolTable ///////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

@implementation SymbolTable
  
+ (void)initialize 
{
  static BOOL tooLate = NO;
  if ( !tooLate )
  {
    [self setVersion:1];
    tooLate = YES; 
  }
}  
  
+ symbolTable
{
  return [[[self alloc] init] autorelease];
}  
  
//------------------- public methods ---------------

- (Array *)allDefinedSymbols
{
  NSInteger i;
  SymbolTableValueWrapper *vw;
  NSInteger nb = [valueWrappers count];
  Array *r = [Array arrayWithCapacity:30];
  for (i = 0; i < nb; i++)
  {
    vw = [valueWrappers objectAtIndex:i];
    if ([vw status] == DEFINED)
    {
      [r addObject:[NSMutableString stringWithString:[vw symbol]]];
    }
  }  
  return r;
}  

- (BOOL) containsSymbolAtFirstLevel:(NSString *)theKey 
// Does the receiver contains the symbol (without searching parents)
{
  return [symbTable objectForKey:theKey] != nil;
} 

- (id)copy
{ return [self copyWithZone:NULL]; }

- (id)copyWithZone:(NSZone *)zone
{
  NSInteger i;
  NSInteger valueWrappers_count = [valueWrappers count];
  SymbolTableValueWrapper *vwcou;
  
  SymbolTable *r = [[SymbolTable allocWithZone:zone] initWithParent:parent tryToAttachWhenDecoding: tryToAttachWhenDecoding];
  
  for (i = 0; i<valueWrappers_count;i++)
  {
    vwcou = [valueWrappers objectAtIndex:i];
    [r insertSymbol:vwcou->symbol value:vwcou->value 
                           type:vwcou->type status:vwcou->status];
  }    
        
  return r;
}  

- (void)dealloc
{
  //NSLog(@"SymbolTable dealloc"); //, %d , %d",[symbTable retainCount],[valueWrappers retainCount]);
  [symbTable release];
  [valueWrappers release];
  [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
  [super encodeWithCoder:coder];

  if ([coder allowsKeyedCoding]) 
  {
    [coder encodeObject:symbTable forKey:@"symbTable"];
    [coder encodeObject:valueWrappers forKey:@"valueWrappers"];
    [coder encodeBool:tryToAttachWhenDecoding forKey:@"tryToAttachWhenDecoding"];
  }
  else
  {
    [coder encodeObject:symbTable];
    [coder encodeObject:valueWrappers];
#warning 64BIT: Inspect use of @encode
    [coder encodeValueOfObjCType:@encode(typeof(tryToAttachWhenDecoding)) at:&tryToAttachWhenDecoding];
  }  
} 

- (struct FSContextIndex) findOrInsertSymbol:(NSString*)theKey
{
  struct FSContextIndex r;
  NSNumber *index = [symbTable objectForKey:theKey]; 
  if (index == nil)
  {
    if (parent)
    {
      r = [parent findOrInsertSymbol:theKey];
      r.level++;
      return r;
    }
    else
    {
      return [self insertSymbol:theKey value:nil type:VARIABLE status:UNDEFINED];
    }  
  }    
  else
  {
    r.level = 0; r.index = [index integerValue];
    return r;
  }    
}

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  
  if ([coder allowsKeyedCoding]) 
  {
    symbTable = [[coder decodeObjectForKey:@"symbTable"] retain];
    valueWrappers = [[coder decodeObjectForKey:@"valueWrappers"] retain];
    tryToAttachWhenDecoding = [coder decodeBoolForKey:@"tryToAttachWhenDecoding"];
    if (tryToAttachWhenDecoding && !parent && [coder isKindOfClass:[FSKeyedUnarchiver class]])
      parent = [[(FSKeyedUnarchiver *)coder loaderEnvironmentSymbolTable] retain];  
  }
  else
  {
    if ([coder versionForClassName:@"SymbolTable"] == 0)
    {
      id *locals;
      NSUInteger localCount;
      //NSLog(@"version == 0");
#warning 64BIT: Inspect use of @encode
      [coder decodeValueOfObjCType:@encode(typeof(localCount)) at:&localCount];
      locals = malloc(localCount*sizeof(id));
#warning 64BIT: Make sure values being decoded correspond to the types
      [coder decodeArrayOfObjCType:@encode(id) count:localCount at:locals];
      free(locals);
    }  
  
    symbTable = [[coder decodeObject] retain];
    valueWrappers = [[coder decodeObject] retain];
#warning 64BIT: Inspect use of @encode
    [coder decodeValueOfObjCType:@encode(typeof(tryToAttachWhenDecoding)) at:&tryToAttachWhenDecoding];
    if (tryToAttachWhenDecoding && !parent && [coder isKindOfClass:[FSUnarchiver class]])
      parent = [[(FSUnarchiver *)coder loaderEnvironmentSymbolTable] retain];
  }  
  return self;
}

- (struct FSContextIndex)indexOfSymbol:(NSString*)theKey
{
  struct FSContextIndex r;
  NSNumber *index = [symbTable objectForKey:theKey]; 
  if (index == nil)
  {
    if (parent)
    {
      r = [parent indexOfSymbol:theKey];
      if (r.index != -1)
        r.level++;
      return r;
    }
    else
    {
      r.index = -1;
      return r;
    } 
  }    
  else
  {
    r.level =0; r.index = [index integerValue];
    return r;
  }    
}      

- init
{
  return [self initWithParent:nil];
}

- initWithParent:(SymbolTable *)theParent
{
  return [self initWithParent:theParent tryToAttachWhenDecoding:YES];
}

- initWithParent:(SymbolTable *)theParent tryToAttachWhenDecoding:(BOOL)shouldTry
{
  if ((self = [super initWithLocalCount:0 parent:theParent]))
  {
    symbTable  = [[NSMutableDictionary alloc] init];
    valueWrappers = [[Array alloc] init]; 
    tryToAttachWhenDecoding = shouldTry;
    return self;
  }
  return nil;
}

- (struct FSContextIndex)insertSymbol:(NSString*)theKey value:(id)theValue
{
  return [self insertSymbol:theKey value:theValue type:VARIABLE status:DEFINED];
}

-(struct FSContextIndex) insertSymbol:(NSString*)theKey value:(id)theValue 
                                   type:(enum SymbolTable_value_type)theType
{
  return [self insertSymbol:theKey value:theValue type:theType status:DEFINED];
}                                     
                                   
                                   
-(struct FSContextIndex) insertSymbol:(NSString*)theKey value:(id)theValue 
                           type:(enum SymbolTable_value_type)theType
                           status:(enum SymbolTable_symbol_status)theStatus                                   
{
  struct FSContextIndex r;
  SymbolTableValueWrapper *vw;
  NSNumber *ind = [symbTable objectForKey:theKey];
    
  if (ind == nil)
  {
    vw = [[[SymbolTableValueWrapper alloc] initWrapperWithValue:theValue type:theType symbol:theKey status:theStatus] autorelease];
    ind = [NSNumber numberWithUnsignedInteger:[valueWrappers count]];
    [symbTable setObject:ind forKey:theKey];
    [valueWrappers addObject:vw];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"changed" object:self]; 
  }
  r.index = [ind integerValue]; r.level = 0;
  return r;      
}      

- (BOOL) isEmpty  { return ([valueWrappers count] == 0);}

- (id)objectForSymbol:(NSString *)symbol found:(BOOL *)found // foud may be passed as NULL
{
  struct FSContextIndex ind = [self indexOfSymbol:symbol];
  if (ind.index == -1) 
  {
    if (found) *found = NO; 
    return nil;
  }
  else
  {
    BOOL isDefined;
    id r = [self valueForIndex:ind isDefined:&isDefined];
    if (isDefined)
    {
      if (found) *found = YES;
      return r;
    }
    else 
    {
      if (found) *found = NO;
      return nil;
    } 
  } 
}

- (SymbolTable*) parent  { return parent;}  

- (id)retain  { retainCount ++; return self;}

- (NSUInteger)retainCount  { return retainCount;}

- (void)release  { if (--retainCount == 0) [self dealloc];}  

- (void) removeAllObjects
{
  NSUInteger valueWrappers_count = [valueWrappers count];
  NSUInteger i;

  for (i=0; i < valueWrappers_count; i++)
  {
    SymbolTableValueWrapper *vw = [valueWrappers objectAtIndex:i];
    vw->status = UNDEFINED;
    [vw setValue:nil];
  }    
}

-(void)setObject:(id)object forSymbol:(NSString *)symbol
{
  struct FSContextIndex ind = [self indexOfSymbol:symbol];

  if (ind.index == -1) [self insertSymbol:symbol value:object];
  else                 [self setValue:object forIndex:ind];
}

- (void) setParent:(SymbolTable *)theParent
{
  if (theParent == parent) return;
  
  [parent autorelease];
  parent = [theParent retain];
}  

- (void)setToNilSymbolsFrom:(NSUInteger)ind
{
  NSUInteger valueWrappers_count = [valueWrappers count];
  while (ind < valueWrappers_count)
  {
    SymbolTableValueWrapper *vw = [valueWrappers objectAtIndex:ind];
    vw->status = DEFINED;
    if (vw->value)
    {
      [vw->value release];
      vw->value = nil;
    }    
    ind++;
  }    
}

-(void)setValue:(id)theValue atFirstLevelForIndex:(struct FSContextIndex)theIndex
{
  SymbolTableValueWrapper *vw = [valueWrappers objectAtIndex:theIndex.index];
  [vw setValue:theValue];
  vw->status = DEFINED;
}

- valueAtFirstLevelForIndex:(struct FSContextIndex)index isDefined:(BOOL *)isDefined
{
  SymbolTableValueWrapper *valueWrapper;
  
  valueWrapper = [valueWrappers objectAtIndex:index.index];
  
  if (valueWrapper && valueWrapper->status == DEFINED)
  {
    *isDefined = YES;
    return valueWrapper->value;
  }
  else 
  {
    *isDefined = NO;
    return nil;
  }  
}

- valueWrapperForIndex:(struct FSContextIndex)index
{
  NSInteger i;
  SymbolTable *s = self;
  
  for (i = 0; i < index.level && s; i++) s = s->parent;
  
  if (s) return [s->valueWrappers objectAtIndex:index.index];
  else   return nil;
}

- (NSString *) symbolForIndex:(struct FSContextIndex)index
{
  return [[self valueWrapperForIndex:index] symbol];
}
                                                                                
@end
