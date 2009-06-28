/* ArrayRepBoolean.m Copyright (c) 1998-2006 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import "build_config.h" 

#import "ArrayRepBooleanPacked.h" 

#import "BlockPrivate.h" 
#import "BlockRep.h"
#import "BlockInspector.h"
#import "string.h"          // memcpy() 
#import "ArrayPrivate.h"
#import "Number.h" 
#import "FScriptFunctions.h"
#import "FSBooleanPrivate.h"
#import "ArrayRepId.h"
#import "FSCompiler.h"
#import "FSExecEngine.h"

#ifndef MAX
#define MAX(a, b) \
    ({typeof(a) _a = (a); typeof(b) _b = (b);     \
	_a > _b ? _a : _b; })
#endif

#ifndef MIN
#define MIN(a, b) \
    ({typeof(a) _a = (a); typeof(b) _b = (b);	\
	_a < _b ? _a : _b; })
#endif

// Number of bit in an element of the internal array
#warning 64BIT: Inspect use of sizeof
#define ARRAY_WORD_BIT (CHAR_BIT * sizeof(NSUInteger)) 

#define AT(t,i) (((t)[(i)/ARRAY_WORD_BIT] & 1 << ((i)%ARRAY_WORD_BIT)) != 0)

#define PUT_TRUE_AT(t, i) ((t)[(i)/ARRAY_WORD_BIT] |=  (1 << ((i)%ARRAY_WORD_BIT)))
#define PUT_FALSE_AT(t, i) ((t)[(i)/ARRAY_WORD_BIT] &= ~(1 << ((i)%ARRAY_WORD_BIT)))

//#define AT_PUT(t, i, value) {if ((t)[(i)/ARRAY_WORD_BIT] &= ~(1 << ((i)%ARRAY_WORD_BIT)))

/*static unsigned mask[UNSIGNED_BIT] = {
                                      1,
                                      1<< 1,
                                      1<< 2,
                                      1<< 3,
                                      1<< 4,
                                      1<< 5,
                                      1<< 6,
                                      1<< 7,
                                      1<< 8,
                                      1<< 9,
                                      1<<10,
                                      1<<11,
                                      1<<12,
                                      1<<13,
                                      1<<14,
                                      1<<15,
                                      1<<16,
                                      1<<17,
                                      1<<18,
                                      1<<19,
                                      1<<20,
                                      1<<21,
                                      1<<22,
                                      1<<23,
                                      1<<24,
                                      1<<25,
                                      1<<26,
                                      1<<27,
                                      1<<28,
                                      1<<29,
                                      1<<30,
                                      1<<32};*/
                                      


@implementation ArrayRepBoolean

////////////////////////////// USER METHODS SUPPORT /////////////////////////////
/////////////////////////////////////////////////////////////////////////////////


- (id)operator_backslash:(Block*)bl  // May raise
{
    NSUInteger i;
    id args[3];
    
    if ([bl isCompact]) 
    {
      SEL selector = [bl selector];
      NSString *selectorStr  = [bl selectorStr];
      MsgContext *msgContext = [bl msgContext];
#warning 64BIT: Inspect use of long
      long acu = t[0];

      args[1] = (id)(selector ? selector : [FSCompiler selectorFromString:selectorStr]);

      if (selector == @selector(operator_ampersand:)) 
      {
        for (i = 0; i < count && t[i]; i++);
        return (i == count ? (id)fsTrue : (id)fsFalse);
      }
      else if (selector == @selector(operator_bar:)) 
      {
        for (i = 0; i < count && !t[i]; i++);
        return (i == count ? (id)fsFalse : (id)fsTrue);
      }
      else if (selector == @selector(operator_plus:))      
      {
        for (i = 1; i < count; i++) acu += (t[i] ? 1 : 0);
        return [Number numberWithDouble:acu];
      }
      else
      {
        args[0] = (t[0] ? (id)fsTrue : (id)fsFalse);
        for (i = 1; i < count; i++)
        {
          args[2] = (t[i] ? (id)fsTrue : (id)fsFalse);
          args[0] = sendMsg(args[0], selectorStr, 3, args, nil, msgContext, nil); // May raise
        }
      } // end if
    }
    else
    {
      BlockRep *blRep = [bl blockRep];
      
      args[0] = (t[0] ? (id)fsTrue : (id)fsFalse);
      for (i = 1; i < count; i++)
      {
        args[2] = (t[i] ? (id)fsTrue : (id)fsFalse);
        args[0] = [blRep body_notCompact_valueArgs:args count:3 block:bl];
      }
    }
    return args[0];
}


- (Number *)operator_exclam:(id)anObject
{
  NSUInteger i;
  char val;
  
  if (anObject != fsTrue && anObject != fsFalse && ![anObject isKindOfClass:[FSBoolean class]])
    return (id)[Number numberWithDouble:count];
  
  val = ([anObject isTrue] ? 1:0);

  for (i=0; i < count; i++)  if (t[i] == val) break;
    
  return (id)[Number numberWithDouble:i];    
}  

- (Number *)operator_exclam_exclam:(id)anObject
{
  return [self operator_exclam:anObject]; 
}


///////////////////////////// OPTIM ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////


/*-------------------------------------- double loop ----------------------------------*/

// note: for all the doubleLoop... methods, precondition contains: [[operand arrayRep] isKindOfClass:[ArrayRepBoolean class]] && ![operand isProxy]

- (Array *)doubleLoop_operator_ampersand:(Array *)operand
{
  char *opData = [[operand arrayRep] booleansPtr];
  char *resTab;
  NSUInteger i;
  NSUInteger nb = MIN(count, [operand count]);

  //NSLog(@"doubleLoop_operator_ampersand:");
 
  resTab = malloc(nb*sizeof(char));
  
  for(i=0; i < nb; i++) resTab[i] = t[i] && opData[i];

  return [[[Array alloc] initWithRepNoRetain:[[ArrayRepBoolean alloc] initWithBooleansNoCopy:resTab count:nb]] autorelease];
}

- (Array *)doubleLoop_operator_bar:(Array *)operand
{
  char *resTab;
  NSUInteger i;
  NSUInteger nb = MIN(count, [operand count]);
  char *opData = [[operand arrayRep] booleansPtr];

  //NSLog(@"doubleLoop_operator_bar:");
 
  resTab = malloc(nb*sizeof(char));
  
  for(i=0; i < nb; i++) resTab[i] = t[i] | opData[i];

  return [[[Array alloc] initWithRepNoRetain:[[ArrayRepBoolean alloc] initWithBooleansNoCopy:resTab count:nb]] autorelease];
}

/*-------------------------------------- simple loop ----------------------------------*/

- (Array *)simpleLoop_not
{
  char *resTab;
  NSUInteger i;

  //NSLog(@"simpleLoop_operator_not");

  resTab = malloc(count*sizeof(char));
  for(i=0;i<count;i++) resTab[i] = !t[i];
  return [[[Array alloc] initWithRepNoRetain:[[ArrayRepBoolean alloc] initWithBooleansNoCopy:resTab count:count]] autorelease];
}


/////////////////////////////// OTHER METHODS //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


+ (void)initialize //opt
{
  static BOOL tooLate = NO;
  if ( !tooLate ) 
  {
    tooLate = YES;
  } 
}

- (void)addBoolean:(char)aBoolean  //opt
{
  //unsigned index  = count / ARRAY_WORD_BIT;
  //unsigned offset = count % ARRAY_WORD_BIT;
  if (count == capacity)
  {
    capacity = (capacity+1)*2;
#warning 64BIT: Inspect use of sizeof
#warning 64BIT: Inspect use of sizeof
    t = (NSUInteger *)realloc(t, (capacity/ARRAY_WORD_BIT) * sizeof(NSUInteger) + sizeof(NSUInteger));    
  }
  if (aBoolean) PUT_TRUE_AT(t, count);
  else          PUT_FALSE_AT(t, count);
  count++;
  
  /*if (aBoolean)
    t [index] = t[index] | 1 << offset;
  else
    t [index] = t[index] & ~(1 << offset);*/
}

- (BOOL)booleanAtIndex:(NSUInteger)i
{
  NSUInteger index  = i / ARRAY_WORD_BIT;
  NSUInteger offset = i % ARRAY_WORD_BIT;

  return (t[index] & 1 << offset) != 0;
}

-(NSString *)printString
{
  NSMutableString *str;
  NSString *elemStr = @""; // W
  NSUInteger i;
  NSUInteger lim = [self count]; 

  str = [NSMutableString stringWithString:@"{"];
  
  if (lim > 0)
  {
    elemStr = [self booleanAtIndex:0] ? @"true" : @"false";
    [str appendString:elemStr];  
  }          
    
  for (i = 1; i < lim; i++)
  {
    [str appendString:@", "];
   
    elemStr = [self booleanAtIndex:i] ? @"true" : @"false";
    [str appendString:elemStr];      
  }
  
  [str appendString:@"}"];
  return str; 
}

- (ArrayRepId *) asArrayRepId // opt
{
  NSUInteger i;
  id *tab = (id *) malloc(count * sizeof(id));
  ArrayRepId *r = [[[ArrayRepId alloc] initWithObjectsNoCopy:tab count:count] autorelease];

  for (i = 0; i < count; i++) tab[i] = AT(t,i) ? (id)fsTrue : (id)fsFalse;
  return r;
}

- awakeAfterUsingCoder:(NSCoder *)aDecoder //opt
{
  return self;
}   

- (char *)booleansPtr {return t;}

- copyWithZone:(NSZone *)zone // opt
{
  return [[ArrayRepBoolean allocWithZone:zone] initWithBooleans:t count:count];  
}

- (NSUInteger)count {return count;}

- (void)dealloc // opt
{
  free(t);
  [super dealloc];
} 

- init { return [self initWithCapacity:0]; } // opt

- initFilledWithBoolean:(char)elem count:(NSUInteger)nb // opt // contract: a return value of nil means not enough memory
{
  if (self = [self initWithCapacity:nb])
  { 
    count = nb;
    if (elem)
#warning 64BIT: Inspect use of sizeof
#warning 64BIT: Inspect use of sizeof
      memset(t, ~0, (nb/ARRAY_WORD_BIT) * sizeof(NSUInteger) + sizeof(NSUInteger));
    else   
#warning 64BIT: Inspect use of sizeof
#warning 64BIT: Inspect use of sizeof
      bzero(t, (nb/ARRAY_WORD_BIT) * sizeof(NSUInteger) + sizeof(NSUInteger)); 
    return self;
  }
  return nil;
}


- initWithCapacity:(NSUInteger)aNumItems // opt // contract: a return value of nil means not enough memory  
{
  if ((self = [super init]))
  {
#warning 64BIT: Inspect use of sizeof
#warning 64BIT: Inspect use of sizeof
    t = malloc((aNumItems/ARRAY_WORD_BIT) * sizeof(NSUInteger) + sizeof(NSUInteger));
    if (!t)
    {
      [super dealloc];
      return nil;
    }    
    retainCount = 1;
    capacity = aNumItems;
    count = 0;
    return self;
  }
  return nil;    
}

- initWithBooleans:(NSUInteger *)elems count:(NSUInteger)nb //opt
{  
  if (self = [self initWithCapacity:nb])
  {
#warning 64BIT: Inspect use of sizeof
#warning 64BIT: Inspect use of sizeof
    memcpy(t, elems, (nb/ARRAY_WORD_BIT) * sizeof(NSUInteger) + sizeof(NSUInteger));
    count = nb;
    return self;
  }
  return nil;
}

- initWithBooleansNoCopy:(char *)tab count:(NSUInteger)nb
{
  if ((self = [super init]))
  {
    retainCount = 1;
    t = tab;
    capacity = nb;
    count = nb;
    return self;
  }
  return nil;    
}

- (void)removeLastElem
{
  count--;
  if (capacity/2 >= count+100)
  {
    capacity = capacity/2;
    t = (char *)realloc(t, capacity * sizeof(char));
  }    
}

- (void)removeElemAtIndex:(NSUInteger)index
{      
  count--;
  
  memmove( &(t[index]), &(t[index+1]), (count-index) * sizeof(char));

  if (capacity/2 >= count+100)
  {
    capacity = capacity/2;
    t = (char *)realloc(t, capacity * sizeof(char));
  }
}

- (void)replaceBooleanAtIndex:(NSUInteger)index withBoolean:(char)aBoolean
{
  t[index] = aBoolean;   
}  

- (id)retain                 { retainCount++; return self;}

- (NSUInteger)retainCount  { return retainCount;}

- (void)release              { if (--retainCount == 0) [self dealloc];}  

- (NSArray *)subarrayWithRange:(NSRange)range //opt
{  
  ArrayRepBoolean *resRep; 
  Array *r;
  NSUInteger i;
  
  resRep = [[ArrayRepBoolean alloc] initWithCapacity:range.length];
  for (i = 0; i < range.length; i++) [resRep addBoolean:AT(t,i)];
  r = [Array arrayWithRep:resRep];
  [resRep release];
  return r;   
}

- (enum ArrayRepType)repType {return BOOLEAN;}

@end
