/* ArrayRepBoolean.m Copyright (c) 1998-2006 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import "build_config.h" 

#import "ArrayRepBooleanAltivec.h" 
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
          args[0] = sendMsg(args[0], selector, 3, args, nil, msgContext, nil); // May raise
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


- (NSNumber *)operator_exclam:(id)anObject
{
  NSUInteger i;
  char val;
  
  if (anObject != fsTrue && anObject != fsFalse && ![anObject isKindOfClass:[FSBoolean class]])
    return (id)[Number numberWithDouble:count];
  
  val = ([anObject isTrue] ? 1:0);

  for (i=0; i < count; i++)  if (t[i] == val) break;
    
  return (id)[Number numberWithDouble:i];    
}  

- (NSNumber *)operator_exclam_exclam:(id)anObject
{
  return [self operator_exclam:anObject]; 
}


///////////////////////////// OPTIM ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////


/*-------------------------------------- double loop ----------------------------------*/

// note: for all the doubleLoop... methods, precondition contains: [[operand arrayRep] isKindOfClass:[ArrayRepBoolean class]] && ![operand isProxy]

/*- (Array *)doubleLoop_operator_ampersand:(Array *)operand
{
  char *opData = [[operand arrayRep] booleansPtr];
  char *resTab;
  unsigned i;
  unsigned nb = MIN(count, [operand count]);

  //NSLog(@"doubleLoop_operator_ampersand:");
 
  resTab = malloc(nb*sizeof(char));
  
  for(i=0; i < nb; i++) resTab[i] = t[i] && opData[i];

  return [[[Array alloc] initWithRepNoRetain:[[ArrayRepBoolean alloc] initWithBooleansNoCopy:resTab count:nb]] autorelease];
}
*/ 

- (Array *)doubleLoop_operator_bar:(Array *)operand
{
  /*char *resTab;
  unsigned i;
  char *opData = [[operand arrayRep] booleansPtr];
  unsigned vecCount ;*/

  char *resTab;
  NSUInteger i = 0;
  char *opData;
  NSUInteger vecCount;
  
 // vec_dst(((vector bool char *)t)+i, 0x10010100, 0);
  
  opData = [[operand arrayRep] booleansPtr];
   
 // vec_dst(((vector bool char *)opData)+i, 0x10010100, 1);

  //NSLog(@"doubleLoop_operator_bar:");
 
  resTab = malloc((capacity + (16 - (capacity % 16))) * sizeof(char));
  
  for(i = 0, vecCount = count/16 + 1; i < vecCount; i++) 
  { 
    vec_dstt(((vector bool char *)t)+i, 0x10010100, 0);
    vec_dstt(((vector bool char *)opData)+i, 0x10010100, 1);
    ((vector bool char *)resTab)[i] = vec_or(((vector bool char *)t)[i], ((vector bool char *)opData)[i]);
  }
  vec_dss(0);
  vec_dss(1);
  return [[[Array alloc] initWithRepNoRetain:[[ArrayRepBoolean alloc] initWithBooleansNoCopy:resTab count:count]] autorelease];
} 

- (Array *)doubleLoop_operator_bar_bar:(Array *)operand
{
  char *resTab;
  NSUInteger i;
  NSUInteger nb = MIN(count, [operand count]);
  char *opData = [[operand arrayRep] booleansPtr];

  //NSLog(@"doubleLoop_operator_bar:");
 
  resTab = malloc(nb*sizeof(char));
  
  for(i=0; i < nb; i++) 
  {
    resTab[i] = t[i] || opData[i]; 
  } 
  
  return [[[Array alloc] initWithRepNoRetain:[[ArrayRepBoolean alloc] initWithBooleansNoCopy:resTab count:nb]] autorelease];
} 

- (Array *)doubleLoop_operator_bar_bar_bar:(Array *)operand
{
  char *resTab;
  NSUInteger i;
  NSUInteger nb = count/4 + 1;
  char *opData = [[operand arrayRep] booleansPtr];

  //NSLog(@"doubleLoop_operator_bar:");
 
#warning 64BIT: Inspect use of sizeof
  resTab = malloc(nb*sizeof(NSUInteger));
  
  for(i=0; i < nb; i++) 
  {
    ((NSUInteger *)resTab)[i] = ((NSUInteger *)t)[i] | ((NSUInteger *)opData)[i];
  }
 
  return [[[Array alloc] initWithRepNoRetain:[[ArrayRepBoolean alloc] initWithBooleansNoCopy:resTab count:nb]] autorelease];
} 



/*-------------------------------------- simple loop ----------------------------------*/

- (Array *)simpleLoop_not 
{
  char *resTab;
  NSUInteger i;
  NSUInteger vecCount;

  //NSLog(@"simpleLoop_operator_not");

  resTab = malloc((capacity + (16 - (capacity % 16))) * sizeof(char));
  for(i = 0, vecCount = count/16 + 1; i < vecCount; i++)
  { 
    ((vector bool char *)resTab)[i] = vec_nor(((vector bool char *)t)[i], ((vector bool char *)t)[i]);
#warning 64BIT: Check formatting arguments
    printf("%vd\n", ((vector bool char *)t)[i]);
#warning 64BIT: Check formatting arguments
    printf("%vd\n", ((vector bool char *)resTab)[i]);
  }
  return [[[Array alloc] initWithRepNoRetain:[[ArrayRepBoolean alloc] initWithBooleansNoCopy:resTab count:count]] autorelease];
}




/////////////////////////////// OTHER METHODS //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


+ (void)initialize
{
    static BOOL tooLate = NO;
    if ( !tooLate ) {
        tooLate = YES;
    }
}

- (void)addBoolean:(char)aBoolean
{
  count++;
  if (count > capacity)
  {
    capacity = (capacity+1)*2;
    t = (char *)realloc(t,(capacity + (16 - (capacity % 16))) * sizeof(char));
  }
  t[count-1] = aBoolean;
}


- (ArrayRepId *) asArrayRepId
{
  NSUInteger i;
  id *tab = (id *) malloc(count * sizeof(id));
  ArrayRepId *r = [[[ArrayRepId alloc] initWithObjectsNoCopy:tab count:count] autorelease];

  for (i = 0; i < count; i++) tab[i] = t[i] ? (id)fsTrue : (id)fsFalse;
  return r;
}

- (char *)booleansPtr {return t;}

- copyWithZone:(NSZone *)zone
{
  return [[ArrayRepBoolean allocWithZone:zone] initWithBooleans:t count:count];  
}

- (NSUInteger)count {return count;}

- (void)dealloc
{
  free(t);
  [super dealloc];
} 

- init { return [self initWithCapacity:0]; }

- initFilledWithBoolean:(char)elem count:(NSUInteger)nb // contract: a return value of nil means not enough memory
{
  if (self = [self initWithCapacity:nb])
  {    
    for (count = 0; count < nb; count++) t[count] = elem; 
    return self;
  }
  return nil;
}

- initWithCapacity:(NSUInteger)aNumItems // contract: a return value of nil means not enough memory  
{
  if ((self = [super init]))
  {
    t = malloc((aNumItems + (16 - (aNumItems % 16))) * sizeof(char));
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

- initWithBooleans:(char *)elems count:(NSUInteger)nb
{  
  if (self = [self initWithCapacity:nb])
  {
    memcpy(t,elems,nb*sizeof(char)); 
    count = nb;
    return self;
  }
  return nil;
}

/*- initWithBooleansNoCopy:(char *)tab count:(unsigned)nb  
{
  return [self initWithBooleans:tab count:nb];
  free(tab);
}*/

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
    t = (char *)realloc(t, (capacity + (16 - (capacity % 16))) * sizeof(char));
  }    
}

- (void)removeElemAtIndex:(NSUInteger)index
{      
  count--;
  
  memmove( &(t[index]), &(t[index+1]), (count-index) * sizeof(char));
 
  if (capacity/2 >= count+100)
  {
    capacity = capacity/2;
    t = (char *)realloc(t, (capacity + (16 - (capacity % 16))) * sizeof(char));
  }
}

- (void)replaceBooleanAtIndex:(NSUInteger)index withBoolean:(char)aBoolean
{
  t[index] = aBoolean;   
} 

- (id)retain                 { retainCount++; return self;}

- (NSUInteger)retainCount  { return retainCount;}

- (void)release              { if (--retainCount == 0) [self dealloc];}  

- (NSArray *)subarrayWithRange:(NSRange)range
{  
  ArrayRepBoolean *resRep; 
  Array *r;
  
  resRep = [[ArrayRepBoolean alloc] initWithBooleans:t+range.location count:range.length];
  r = [Array arrayWithRep:resRep];
  [resRep release];
  return r;   
}

- (enum ArrayRepType)repType {return BOOLEAN;}

@end
