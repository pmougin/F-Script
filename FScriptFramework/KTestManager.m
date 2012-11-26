/*   KTestManager.m Copyright (c) 2001-2009 Philippe Mougin.     */
/*   This software is open source. See the license.  */  

#import "KTestManager.h"
#import <Foundation/Foundation.h>
#import "FSBoolean.h"
#import "FSNumber.h"
#import "FScriptFunctions.h"
#import "FSBlock.h"
#import <objc/objc-class.h>
#import "FSNSString.h"

@class FSTestClass10;

@protocol MethodMappingTestHelper

- (id)                   giveBackId:                     (id)                   arg; 
- (id *)                 giveBackIdPtr:                  (id *)                 arg; 
- (id)                   dereferenceIdPtr:               (id *)                 arg; 

- (Class)                giveBackClass:                  (Class)                arg; 
- (Class *)              giveBackClassPtr:               (Class *)              arg; 
- (Class)                dereferenceClassPtr:            (Class *)              arg; 

- (SEL)                  giveBackSEL:                    (SEL)                  arg; 
- (SEL *)                giveBackSELPtr:                 (SEL *)                arg; 
- (SEL)                  dereferenceSELPtr:              (SEL *)                arg; 

- (BOOL)                 giveBackBOOL:                   (BOOL)                 arg;
- (BOOL *)               giveBackBOOLPtr:                (BOOL *)               arg;
- (BOOL)                 dereferenceBOOLPtr:             (BOOL *)               arg;

- (_Bool)                giveBack_Bool:                  (_Bool)                arg;
- (_Bool *)              giveBack_BoolPtr:               (_Bool *)              arg;
- (_Bool)                dereference_BoolPtr:            (_Bool *)              arg;

- (char)                 giveBackChar:                   (char)                 arg;
- (char *)               giveBackCharPtr:                (char *)               arg;
- (char)                 dereferenceCharPtr:             (char *)               arg;

- (unsigned char)        giveBackUnsignedChar:           (unsigned char)        arg;
- (unsigned char *)      giveBackUnsignedCharPtr:        (unsigned char *)      arg;
- (unsigned char)        dereferenceUnsignedCharPtr:     (unsigned char *)      arg;

- (short)                giveBackShort:                  (short)                arg;
- (short *)              giveBackShortPtr:               (short *)              arg;
- (short)                dereferenceShortPtr:            (short *)              arg;

- (unsigned short)       giveBackUnsignedShort:          (unsigned short)       arg;
- (unsigned short *)     giveBackUnsignedShortPtr:       (unsigned short *)     arg;
- (unsigned short)       dereferenceUnsignedShortPtr:    (unsigned short *)     arg;

- (int)                  giveBackInt:                    (int)                  arg;
- (int *)                giveBackIntPtr:                 (int *)                arg;
- (int)                  dereferenceIntPtr:              (int *)                arg;

- (unsigned int)         giveBackUnsignedInt:            (unsigned int)         arg;
- (unsigned int *)       giveBackUnsignedIntPtr:         (unsigned int *)       arg;
- (unsigned int)         dereferenceUnsignedIntPtr:      (unsigned int *)       arg;

- (long)                 giveBackLong:                   (long)                 arg;
- (long *)               giveBackLongPtr:                (long *)               arg;
- (long)                 dereferenceLongPtr:             (long *)               arg;

- (unsigned long)        giveBackUnsignedLong:           (unsigned long)        arg;
- (unsigned long *)      giveBackUnsignedLongPtr:        (unsigned long *)      arg;
- (unsigned long)        dereferenceUnsignedLongPtr:     (unsigned long *)      arg;

- (long long)            giveBackLongLong:               (long long)            arg;
- (long long *)          giveBackLongLongPtr:            (long long *)          arg;
- (long long)            dereferenceLongLongPtr:         (long long *)          arg;

- (unsigned long long)   giveBackUnsignedLongLong:       (unsigned long long)   arg;
- (unsigned long long *) giveBackUnsignedLongLongPtr:    (unsigned long long *) arg;
- (unsigned long long)   dereferenceUnsignedLongLongPtr: (unsigned long long *) arg;

- (NSInteger)            giveBackNSInteger:              (NSInteger)            arg;
- (NSInteger *)          giveBackNSIntegerPtr:           (NSInteger *)          arg;
- (NSInteger)            dereferenceNSIntegerPtr:        (NSInteger *)          arg;

- (NSUInteger)           giveBackNSUInteger:             (NSUInteger)           arg;
- (NSUInteger *)         giveBackNSUIntegerPtr:          (NSUInteger *)         arg;
- (NSUInteger)           dereferenceNSUIntegerPtr:       (NSUInteger *)         arg;

- (float)                giveBackFloat:                  (float)                arg;
- (float *)              giveBackFloatPtr:               (float *)              arg;
- (float)                dereferenceFloatPtr:            (float *)              arg;

- (double)               giveBackDouble:                 (double)               arg;
- (double *)             giveBackDoublePtr:              (double *)             arg;
- (double)               dereferenceDoublePtr:           (double *)             arg;

- (CGFloat)              giveBackCGFloat:                (CGFloat)              arg;
- (CGFloat *)            giveBackCGFloatPtr:             (CGFloat *)            arg;
- (CGFloat)              dereferenceCGFloatPtr:          (CGFloat *)            arg;

- (NSRange)              giveBackNSRange:                (NSRange)              arg;
- (NSRange *)            giveBackNSRangePtr:             (NSRange *)            arg;
- (NSRange)              dereferenceNSRangePtr:          (NSRange *)            arg;

- (NSPoint)              giveBackNSPoint:                (NSPoint)              arg;
- (NSPoint *)            giveBackNSPointPtr:             (NSPoint *)            arg;
- (NSPoint)              dereferenceNSPointPtr:          (NSPoint *)            arg;

- (CGPoint)              giveBackCGPoint:                (CGPoint)              arg;
- (CGPoint *)            giveBackCGPointPtr:             (CGPoint *)            arg;
- (CGPoint)              dereferenceCGPointPtr:          (CGPoint *)            arg;

- (NSRect)               giveBackNSRect :                (NSRect)               arg;
- (NSRect *)             giveBackNSRectPtr:              (NSRect *)             arg;
- (NSRect)               dereferenceNSRectPtr:           (NSRect *)             arg;

- (CGRect)               giveBackCGRect :                (CGRect)               arg;
- (CGRect *)             giveBackCGRectPtr:              (CGRect *)             arg;
- (CGRect)               dereferenceCGRectPtr:           (CGRect *)             arg;

- (NSSize)               giveBackNSSize :                (NSSize)               arg;
- (NSSize *)             giveBackNSSizePtr:              (NSSize *)             arg;
- (NSSize)               dereferenceNSSizePtr:           (NSSize *)             arg;

- (CGSize)               giveBackCGSize :                (CGSize)               arg;
- (CGSize *)             giveBackCGSizePtr:              (CGSize *)             arg;
- (CGSize)               dereferenceCGSizePtr:           (CGSize *)             arg;

- (CGAffineTransform)    giveBackCGAffineTransform :     (CGAffineTransform)    arg;
- (CGAffineTransform *)  giveBackCGAffineTransformPtr:   (CGAffineTransform *)  arg;
- (CGAffineTransform)    dereferenceCGAffineTransformPtr:(CGAffineTransform *)  arg;

- (void *)               giveBackVoidPtr:                (void *)               arg;
- (float)                dereferenceVoidPtrAsFloat:      (void *)               arg;

- (unsigned long long **) giveBackUnsignedLongLongPtrPtr:   (unsigned long long **) arg; 
- (unsigned long long *)  dereferenceUnsignedLongLongPtrPtr:(unsigned long long **) arg; 

- (NSString *)           giveBackNSString:               (NSString *)           arg;
- (FSTestClass10 *)      giveBackFSTestClass10:          (FSTestClass10 *)      arg; 

- (NSArray *) giveBackArrayWithId:(id)a1 Class:(Class)a2 SEL:(SEL)a3 BOOL:(BOOL)a4 _Bool:(_Bool)a5 char:(char)a6 unsignedChar:(unsigned char)a7 
              short:(short)a8 unsignedShort:(unsigned short)a9 int:(int)a10 unsignedInt:(unsigned int)a11 long:(long)a12 unsignedLong:(unsigned long)a13
              longLong:(long long)a14 unsignedLongLong:(unsigned long long)a15 NSInteger:(NSInteger)a16 NSUInteger:(NSUInteger)a17 float:(float)a18
              double:(double)a19 CGFloat:(CGFloat)a20 NSRange:(NSRange)a21 NSPoint:(NSPoint)a22 CGPoint:(CGPoint)a23 NSRect:(NSRect)a24 CGRect:(CGRect)a25
              NSSize:(NSSize)a26 CGSize:(CGSize)a27 CGAffineTransform:(CGAffineTransform)a28 NSString:(NSString *)a29;
@end


@implementation KTestManager

-(void) addComment:(NSString *)comment
{
  [[comments lastObject] appendString:comment];
}

-(void)assert:(BOOL)b
{
  if (!b)
  {
    [results replaceObjectAtIndex:[results count]-1 withObject:[FSBoolean fsFalse]];
    [self addComment:[NSString stringWithFormat:@" assertCount = %ld (note: counting starts at zero)", (long)assertCount]];
  }
  assertCount++;
}

-(void) assertError:(FSBlock *)b
{
  BOOL isException = NO;
  
  FSVerifClassArgsNoNil(@"assertError:",1,b,[FSBlock class]);
  
  @try
  {
    [b value];
  }
  @catch (id exception)
  {
    isException = YES;
  }
  
  if (!isException)
  {
   [results replaceObjectAtIndex:[results count]-1 withObject:[FSBoolean fsFalse]];
   [self addComment:[NSString stringWithFormat:@" assertCount = %ld (note: counting starts at zero)", (long)assertCount]];
  }
  
  assertCount++;
}

-(void) dealloc
{
  [names           release];
  [times           release];
  [results         release];
  [comments        release];
  [currentCategory release];
  [startDate       release];
  [super dealloc];
}

-(void) finish
{
  if (startDate) [times addObject:[FSNumber numberWithDouble:-[startDate timeIntervalSinceNow]]];
}

- (id)init
{
  if ((self = [super init]))
  {
    names    = [[NSMutableArray alloc] init];
    times    = [[NSMutableArray alloc] init];
    results  = [[NSMutableArray alloc] init];
    comments = [[NSMutableArray alloc] init];
    currentCategory = @"";
    shouldLog = NO;
    return self;
  }
  return nil;
}

-(NSString *) report
{
  NSUInteger i;
  NSString *commentReport = [NSMutableString string];
  NSString *errorReport = [NSMutableString string];
  
  for (i = 0; i < [comments count]; i++)
  { 
    if (![[comments objectAtIndex:i] isEqual:@""]) [(NSMutableString *)commentReport appendFormat:@"\n    %@ -> %@",[names objectAtIndex:i],[comments objectAtIndex:i]];
  }
  if (![commentReport isEqual:@""]) commentReport = [@"Comments:" stringByAppendingString:commentReport];
  
  for (i = 0; i < [results count]; i++)
  { 
    if ([[results objectAtIndex:i] isEqual:[FSBoolean fsFalse]]) [(NSMutableString *)errorReport appendFormat:@"%@ failed\n",[names objectAtIndex:i]];
  }
  //if (![errorReport isEqual:@""]) errorReport = [@"Comments:" stringByAppendingString:commentReport];  
          
  if (![errorReport isEqual:@""])
  {
    return [NSString stringWithFormat:@"KTest error !\n%@\n%@", errorReport, commentReport];
  }
  else
  {
    double testTime = 0;
    for (i = 0; i < [times count]; i++)
    {
      testTime += [[times objectAtIndex:i] doubleValue];
    }  
    return [NSString stringWithFormat:@"KTest OK !\nTestTime = %g\n%@", testTime, commentReport];
  }
}

-(void) setShouldLog:(BOOL)should
{
  shouldLog = should;
}

-(void) startCategory:(NSString *)categoryName
{
  if (shouldLog) NSLog(@"Start category %@", categoryName);
  [categoryName retain];
  [currentCategory release];
  currentCategory = categoryName;
}

-(void) startTest:(NSString *)testName
{
  if (startDate) [times addObject:[FSNumber numberWithDouble:-[startDate timeIntervalSinceNow]]];
   
  [names addObject:[currentCategory stringByAppendingFormat:@" : %@",testName]];
  [results addObject:[FSBoolean fsTrue]];
  [comments addObject:[NSMutableString string]];
  assertCount = 0;
  [startDate release];
  startDate = [[NSDate alloc] init];
  
  if (shouldLog) NSLog(@"    Start test %@", testName);
}

@end

@implementation KTestManager(KTestSpecificTests) // Support for some specific tests

///////////////// Forwarding test

- (void)forwardInvocation:(NSInvocation *)invocation
{
  if ([invocation selector] == @selector(testForward1:))
  {
    [invocation setSelector:@selector(testForward1Imp:)];
    [invocation invokeWithTarget:self];
  }
  else if ([invocation selector] == @selector(testForward2:))
  {
    [invocation setSelector:@selector(testForward2Imp:)];
    [invocation invokeWithTarget:self];
  }
  else if ([invocation selector] == @selector(testForward3:::::::::))
  {
    [invocation setSelector:@selector(testForward3Imp:::::::::)];
    [invocation invokeWithTarget:self];
  }
  else [self doesNotRecognizeSelector:[invocation selector]];
}


- (NSInteger)testForward1Imp:(double)d
{
  return d*2;
}

- (id)testForward2Imp:(id)arg
{
  return arg;
}

- (id)testForward3Imp:(id)arg1 :(id)arg2 :(id)arg3 :(id)arg4 :(id)arg5 :(id)arg6 :(id)arg7 :(id)arg8 :(id)arg9
{
  return arg1;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
  if      (aSelector == @selector(testForward1:)) return [self methodSignatureForSelector:@selector(testForward1Imp:)];
  else if (aSelector == @selector(testForward2:)) return [self methodSignatureForSelector:@selector(testForward2Imp:)];
  else if (aSelector == @selector(testForward3:::::::::)) return [self methodSignatureForSelector:@selector(testForward3Imp:::::::::)];
  //else if (aSelector == @selector(retain) || aSelector == @selector(release) || aSelector == @selector(autorelease) || aSelector == @selector(dealloc) || aSelector == @selector(retainCount)) return nil;
  else return [super methodSignatureForSelector:aSelector];
}
///////////////////////////

- (id *)                 idPointer                { id                 *r = malloc(2*sizeof(id));                 r[0] = self;                                     r[1] = [self class];                          return r; }
- (Class *)              ClassPointer             { Class              *r = malloc(2*sizeof(Class));              r[0] = [FSNumber class];                         r[1] = [self class];                          return r; } 
- (char *)               charPointer              { char               *r = malloc(2*sizeof(char));               r[0] = -50;                                      r[1] = 120;                                   return r; } 
- (signed char *)        signedCharPointer        { signed char        *r = malloc(2*sizeof(signed char));        r[0] = -50;                                      r[1] = 120;                                   return r; }
- (_Bool *)              _BoolPointer             { _Bool              *r = malloc(2*sizeof(_Bool));              r[0] =   0;                                      r[1] = 1;                                     return r; }
- (int *)                intPointer               { int                *r = malloc(2*sizeof(int));                r[0] = -50;                                      r[1] = 120;                                   return r; } 
- (short *)              shortPointer             { short              *r = malloc(2*sizeof(short));              r[0] = -50;                                      r[1] = 120;                                   return r; } 
- (long *)               longPointer              { long               *r = malloc(2*sizeof(long));               r[0] = -50;                                      r[1] = 120;                                   return r; } 
- (unsigned char *)      unsignedCharPointer      { unsigned char      *r = malloc(2*sizeof(unsigned char));      r[0] =   0;                                      r[1] = 200;                                   return r; } 
- (unsigned int *)       unsignedIntPointer       { unsigned int       *r = malloc(2*sizeof(unsigned int));       r[0] =   0;                                      r[1] = 200;                                   return r; } 
- (unsigned short *)     unsignedShortPointer     { unsigned short     *r = malloc(2*sizeof(unsigned short));     r[0] =   0;                                      r[1] = 200;                                   return r; } 
- (unsigned long *)      unsignedLongPointer      { unsigned long      *r = malloc(2*sizeof(unsigned long));      r[0] =   0;                                      r[1] = 200;                                   return r; } 
- (float *)              floatPointer             { float              *r = malloc(2*sizeof(float));              r[0] = -1000.89;                                 r[1] = 200.1;                                 return r; } 
- (double *)             doublePointer            { double             *r = malloc(2*sizeof(double));             r[0] = -1000.89;                                 r[1] = 200.1;                                 return r; } 
- (long long *)          longLongPointer          { long long          *r = malloc(2*sizeof(long long));          r[0] = -50;                                      r[1] = 120;                                   return r; } 
- (unsigned long long *) unsignedLongLongPointer  { unsigned long long *r = malloc(2*sizeof(unsigned long long)); r[0] =   0;                                      r[1] = 120;                                   return r; } 
- (char **)              charPointerPointer       { char *             *r = malloc(2*sizeof(char *));             r[0] = "hello";                                  r[1] = "world";                               return r; }
- (SEL *)                SELPointer               { SEL                *r = malloc(2*sizeof(SEL));                r[0] = @selector(init);                          r[1] = @selector(self);                       return r; }
- (NSRange *)            rangePointer             { NSRange            *r = malloc(2*sizeof(NSRange));            r[0] = NSMakeRange(0,10);                        r[1] = NSMakeRange(5,1);                      return r; }   
- (NSPoint *)            pointPointer             { NSPoint            *r = malloc(2*sizeof(NSPoint));            r[0] = NSMakePoint(0,10);                        r[1] = NSMakePoint(5,1);                      return r; }   
- (NSSize *)             sizePointer              { NSSize             *r = malloc(2*sizeof(NSSize));             r[0] = NSMakeSize(0,10);                         r[1] = NSMakeSize(5,1);                       return r; }   
- (NSRect *)             rectPointer              { NSRect             *r = malloc(2*sizeof(NSRect));             r[0] = NSMakeRect(0,10,100,200);                 r[1] = NSMakeRect(20,1,10,10);                return r; }   
- (CGPoint *)            CGPointPointer           { CGPoint            *r = malloc(2*sizeof(CGPoint));            r[0] = CGPointMake(0,10);                        r[1] = CGPointMake(5,1);                      return r; }   
- (CGSize *)             CGSizePointer            { CGSize             *r = malloc(2*sizeof(CGSize));             r[0] = CGSizeMake(0,10);                         r[1] = CGSizeMake(5,1);                       return r; }   
- (CGRect *)             CGRectPointer            { CGRect             *r = malloc(2*sizeof(CGRect));             r[0] = CGRectMake(0,10,100,200);                 r[1] = CGRectMake(20,1,10,10);                return r; }   
- (CGAffineTransform *)  CGAffineTransformPointer { CGAffineTransform  *r = malloc(2*sizeof(CGAffineTransform));  r[0] = CGAffineTransformMake(0,10,100,200,5,6);  r[1] = CGAffineTransformMake(20,1,10,10,7,8); return r; }
- (int **)               intPointerPointer        { int *              *r = malloc(2*sizeof(int *));              r[0] = malloc(sizeof(int)); *(r[0]) = -50;       r[1] = malloc(sizeof(int)); *(r[1]) = 120;    return r; }
- (void *)               voidPointer              { return [self intPointer]; }                                                                                

- (int *) staticIntPointer
{
  static int staticInt;
  return &staticInt;
}

- (CGPoint) CGPointMapping:(CGPoint) a
{
  if (a.x != 7 || a.y != 0) return CGPointMake(0,0);
  else return a;
}

- (CGSize) CGSizeMapping:(CGSize) a
{
  if (a.width != (CGFloat)10.2 || a.height != (CGFloat)33.3) return CGSizeMake(0,0);
  else return a;
}

- (CGRect) CGRectMapping:(CGRect) a
{
  if (a.origin.x != 7 || a.origin.y != 0 || a.size.width != (CGFloat)10.2 || a.size.height != (CGFloat)33.3) return CGRectMake(0,0,0,0);
  else return a;
}

- (FSArray *) duplicateUsingFastEnemeration:(NSArray *)array
{
  FSArray *result = [FSArray array];
  
  for (id elem in array) [result addObject:elem];
  
  return result;
}

-(unsigned int) getUINT_MAX {return UINT_MAX;}

-(int) sizeofId {return sizeof(id);}


-(BOOL) runsIn64BitsMode
{
#if __LP64__
  return YES;
#else
  return NO;
#endif
}

- (BOOL) testFSNSDistantObjectClassOrMetaclass:(id)p
{
  return ([p classOrMetaclass] == [NSDistantObject class] && [[p class] classOrMetaclass] == ((Class)[p class])->isa);
}

-(void) testMethodMappingWithFScriptObject:(id)o
{
  [self assert:[o giveBackId:self] == self];
  [self assert:[o giveBackIdPtr:&self] == &self];
  [self assert:[o dereferenceIdPtr:&self] == self];
  
  Class cl = [self class];
  [self assert:[o giveBackClass:cl] == cl];
  [self assert:[o giveBackClassPtr:&cl] == &cl];
  [self assert:[o dereferenceClassPtr:&cl] == [self class]];
  
  SEL selector = @selector(between:and:);
  [self assert:[o giveBackSEL:selector] == selector];
  [self assert:[o giveBackSELPtr:&selector] == &selector];
  [self assert:[o dereferenceSELPtr:&selector] == @selector(between:and:)];
  
  BOOL y = YES;
  BOOL n = NO;
  [self assert:[o giveBackBOOL:NO]  == NO];
  [self assert:[o giveBackBOOL:YES] == YES];
  [self assert:[o giveBackBOOLPtr:&y] == &y];
  [self assert:[o dereferenceBOOLPtr:&y] == YES];
  [self assert:[o dereferenceBOOLPtr:&n] == NO];

  _Bool tt = 1;
  _Bool ff = 0;
  [self assert:[o giveBack_Bool:0]  == 0];
  [self assert:[o giveBack_Bool:1]  == 1];
  [self assert:[o giveBack_BoolPtr:&tt] == &tt];
  [self assert:[o dereference_BoolPtr:&tt] == 1];
  [self assert:[o dereference_BoolPtr:&ff] == 0];

  char c1 = -122;
  char c2 =  107;
  [self assert:[o giveBackChar:c1] == YES];  // F-script maps char to FSBoolean : c1 will be mapped to an FSBoolean
  [self assert:[o giveBackChar:0] == NO];    // F-script maps char to FSBoolean : 0 will be mapped to an FSBoolean 
  [self assert:[o giveBackCharPtr:&c1] == &c1];
  [self assert:[o dereferenceCharPtr:&c1] == -122];
  [self assert:[o dereferenceCharPtr:&c2] ==  107];
  
  unsigned char uc = 246;
  [self assert:[o giveBackUnsignedChar:uc] == uc];
  [self assert:[o giveBackUnsignedCharPtr:&uc] == &uc];
  [self assert:[o dereferenceUnsignedCharPtr:&uc] == 246];

  short s1 = -12345;
  short s2 =  12345;
  [self assert:[o giveBackShort:s1] == s1];
  [self assert:[o giveBackShort:s2] == s2];
  [self assert:[o giveBackShortPtr:&s1] == &s1];
  [self assert:[o dereferenceShortPtr:&s1] == -12345];
  [self assert:[o dereferenceShortPtr:&s2] ==  12345];
  
  unsigned short us1 =  0;
  unsigned short us2 =  55000;
  [self assert:[o giveBackUnsignedShort:us1] == us1];
  [self assert:[o giveBackUnsignedShort:us2] == us2];
  [self assert:[o giveBackUnsignedShortPtr:&us1] == &us1];
  [self assert:[o dereferenceUnsignedShortPtr:&us1] == 0];
  [self assert:[o dereferenceUnsignedShortPtr:&us2] == 55000];
  
  int i1 = -1234567890;
  int i2 =  1234567890;
  [self assert:[o giveBackInt:i1]  == i1];
  [self assert:[o giveBackInt:i2]  == i2];
  [self assert:[o giveBackIntPtr:&i1] == &i1];
  [self assert:[o dereferenceIntPtr:&i1] == -1234567890];
  [self assert:[o dereferenceIntPtr:&i2] ==  1234567890];
  
  unsigned int ui = 4234567890;
  [self assert:[o giveBackUnsignedInt:ui]  == ui];
  [self assert:[o giveBackUnsignedIntPtr:&ui] == &ui];
  [self assert:[o dereferenceUnsignedIntPtr:&ui] == 4234567890];
  
  long l1 = -1234567890;
  long l2 =  1234567890;
  [self assert:[o giveBackLong:l1]  == l1];
  [self assert:[o giveBackLong:l2]  == l2];
  [self assert:[o giveBackLongPtr:&l1] == &l1];
  [self assert:[o dereferenceLongPtr:&l1] == -1234567890];
  [self assert:[o dereferenceLongPtr:&l2] ==  1234567890];
  
  unsigned long ul = 4234567890;
  [self assert:[o giveBackUnsignedLong:ul]  == ul];
  [self assert:[o giveBackUnsignedLongPtr:&ul] == &ul];
  [self assert:[o dereferenceUnsignedLongPtr:&ul] == 4234567890];
  
  long long ll1 = -1234567890;
  long long ll2 =  1234567890;
  [self assert:[o giveBackLongLong:ll1]  == ll1];
  [self assert:[o giveBackLongLong:ll2]  == ll2];
  [self assert:[o giveBackLongLongPtr:&ll1] == &ll1];
  [self assert:[o dereferenceLongLongPtr:&ll1] == -1234567890];
  [self assert:[o dereferenceLongLongPtr:&ll2] ==  1234567890];
  
  unsigned long long ull = 4234567890;
  [self assert:[o giveBackUnsignedLongLong:ull]  == ull];
  [self assert:[o giveBackUnsignedLongLongPtr:&ull] == &ull];
  [self assert:[o dereferenceUnsignedLongLongPtr:&ull] == 4234567890];
    
  NSInteger nsi1 = -1234567890;
  NSInteger nsi2 =  1234567890;
  [self assert:[o giveBackNSInteger:nsi1]  == nsi1];
  [self assert:[o giveBackNSInteger:nsi2]  == nsi2];
  [self assert:[o giveBackNSIntegerPtr:&nsi1] == &nsi1];
  [self assert:[o dereferenceNSIntegerPtr:&nsi1] == -1234567890];
  [self assert:[o dereferenceNSIntegerPtr:&nsi2] ==  1234567890];
  
  NSUInteger nsui = 4000999555;
  [self assert:[o giveBackNSUInteger:nsui]  == nsui];
  [self assert:[o giveBackNSUIntegerPtr:&nsui] == &nsui];
  [self assert:[o dereferenceNSUIntegerPtr:&nsui] == 4000999555];
  
  [self assert:[o giveBackFloat:-3458] == -3458];
  float f = [o giveBackFloat:3.1415926];
  [self assert:f > 3.1415925 && f < 3.1415927];
  [self assert:[o giveBackFloatPtr:&f] == &f];
  f = [o dereferenceFloatPtr:&f];
  [self assert:f > 3.1415925 && f < 3.1415927];

  [self assert:[o giveBackDouble:-3458] == -3458];
  double d = [o giveBackDouble:3.1415926];
  [self assert:d > 3.1415925 && d < 3.1415927];
  [self assert:[o giveBackDoublePtr:&d] == &d];
  d = [o dereferenceDoublePtr:&d];
  [self assert:d > 3.1415925 && d < 3.1415927];
  
  [self assert:[o giveBackCGFloat:-3458] == -3458];
  CGFloat cgf = [o giveBackCGFloat:3.1415926];
  [self assert:cgf > 3.1415925 && cgf < 3.1415927];
  [self assert:[o giveBackCGFloatPtr:&cgf] == &cgf];
  cgf = [o dereferenceCGFloatPtr:&cgf];
  [self assert:cgf > 3.1415925 && cgf < 3.1415927];
  
  NSRange range = NSMakeRange(5, 100);
  [self assert:NSEqualRanges([o giveBackNSRange:range], range)];
  [self assert:[o giveBackNSRangePtr:&range] == &range];
  [self assert:NSEqualRanges([o dereferenceNSRangePtr:&range], NSMakeRange(5, 100))];
  
  NSPoint point = NSMakePoint(10, 20);
  [self assert:NSEqualPoints([o giveBackNSPoint:point], point)];
  [self assert:[o giveBackNSPointPtr:&point] == &point];
  [self assert:NSEqualPoints([o dereferenceNSPointPtr:&point], NSMakePoint(10, 20))];
  
  CGPoint cgpoint = CGPointMake(10, 20);
  [self assert:CGPointEqualToPoint([o giveBackCGPoint:cgpoint], cgpoint)];
  [self assert:[o giveBackCGPointPtr:&cgpoint] == &cgpoint];
  [self assert:CGPointEqualToPoint([o dereferenceCGPointPtr:&cgpoint], CGPointMake(10, 20))];
  
  NSRect rect = NSMakeRect(10, 20, 100, 300);
  [self assert:NSEqualRects([o giveBackNSRect:rect], rect)];
  [self assert:[o giveBackNSRectPtr:&rect] == &rect];
  [self assert:NSEqualRects([o dereferenceNSRectPtr:&rect], NSMakeRect(10, 20, 100, 300))];

  CGRect cgrect = CGRectMake(10, 20, 100, 300);
  [self assert:CGRectEqualToRect([o giveBackCGRect:cgrect], cgrect)];
  [self assert:[o giveBackCGRectPtr:&cgrect] == &cgrect];
  [self assert:CGRectEqualToRect([o dereferenceCGRectPtr:&cgrect], CGRectMake(10, 20, 100, 300))];
 
  NSSize size = NSMakeSize(44, 25);
  [self assert:NSEqualSizes([o giveBackNSSize:size], size)];
  [self assert:[o giveBackNSSizePtr:&size] == &size];
  [self assert:NSEqualSizes([o dereferenceNSSizePtr:&size], NSMakeSize(44, 25))];
   
  CGSize cgsize = CGSizeMake(44, 25);
  [self assert:CGSizeEqualToSize([o giveBackCGSize:cgsize], cgsize)];
  [self assert:[o giveBackCGSizePtr:&cgsize] == &cgsize];
  [self assert:CGSizeEqualToSize([o dereferenceCGSizePtr:&cgsize], CGSizeMake(44, 25))];
  
  CGAffineTransform cgat = CGAffineTransformMake(10, 55, 20, 56, 2, 3);
  [self assert:CGAffineTransformEqualToTransform([o giveBackCGAffineTransform:cgat], cgat)];
  [self assert:[o giveBackCGAffineTransformPtr:&cgat] == &cgat];
  [self assert:CGAffineTransformEqualToTransform([o dereferenceCGAffineTransformPtr:&cgat], CGAffineTransformMake(10, 55, 20, 56, 2, 3))];

  float fl = 3.1415926;
  [self assert:[o giveBackVoidPtr:&fl] == &fl];
  float fl2 = [o dereferenceVoidPtrAsFloat:&fl];
  [self assert:fl2 > 3.1415925 && fl2 < 3.1415927];
  
  unsigned long long ull3 = 3123456789;
  unsigned long long *ull3Ptr = &ull3;
  [self assert:[o giveBackUnsignedLongLongPtrPtr:&ull3Ptr] == &ull3Ptr]; 
  [self assert:[o dereferenceUnsignedLongLongPtr:[o dereferenceUnsignedLongLongPtrPtr:&ull3Ptr]] == ull3];
  
  NSString *str = @"hello";
  [self assert:[o giveBackNSString:str] == str];
  [self assert:[o giveBackFSTestClass10:o] == o];  
  
  NSArray *objects = [o giveBackArrayWithId:self Class:cl SEL:@selector(between:and:) BOOL:NO _Bool:1 char:c1 unsignedChar:uc short:s1 unsignedShort:us2  
                        int:i1 unsignedInt:ui long:l2 unsignedLong:ul longLong:ll1 unsignedLongLong:ull NSInteger:nsi1 NSUInteger:nsui float:123 double:456 
                        CGFloat:789 NSRange:range NSPoint:point CGPoint:cgpoint NSRect:rect CGRect:cgrect NSSize:size CGSize:cgsize CGAffineTransform:cgat NSString:str];
  
  NSAffineTransform *nsatControl = [NSAffineTransform transform];
  [nsatControl setTransformStruct:(NSAffineTransformStruct){10, 55, 20, 56, 2, 3}];
  
  NSArray *control = [NSArray arrayWithObjects:self, cl, [@"#between:and:" asBlock], [FSBoolean fsFalse], [FSBoolean fsTrue], [FSBoolean booleanWithBool:c1], 
                     [NSNumber numberWithUnsignedChar:uc], [NSNumber numberWithShort:s1], [NSNumber numberWithUnsignedShort:us2], [NSNumber numberWithInt:i1],
                     [NSNumber numberWithUnsignedInt:ui], [NSNumber numberWithLong:l2], [NSNumber numberWithUnsignedLong:ul], [NSNumber numberWithLongLong:ll1],
                     [NSNumber numberWithUnsignedLongLong:ull], [NSNumber numberWithInteger:nsi1], [NSNumber numberWithUnsignedInteger:nsui],
                     [NSNumber numberWithFloat:123], [NSNumber numberWithDouble:456], [NSNumber numberWithDouble:789], [NSValue valueWithRange:range],
                     [NSValue valueWithPoint:point], [NSValue valueWithPoint:NSPointFromCGPoint(cgpoint)], [NSValue valueWithRect:rect], 
                     [NSValue valueWithRect:NSRectFromCGRect(cgrect)], [NSValue valueWithSize:size], [NSValue valueWithSize:NSSizeFromCGSize(cgsize)], nsatControl, str, nil];
  
  //NSLog(@"%@", [objects operator_equal:control]);
  
  [self assert:[objects isEqualToArray:control]];   
}

@end
