/*   KTestManager.h Copyright (c) 2001-2009 Philippe Mougin.     */
/*   This software is open source. See the license.  */  

#import <Foundation/Foundation.h>
#import "FSArray.h"

@class FSBlock;
@class FSBoolean;

@interface KTestManager : NSObject 
{
  NSMutableArray *names;       // an array of NSString objects
  NSMutableArray *times;       // an array of Number objects
  NSMutableArray *results;     // an array of Boolean objects
  NSMutableArray *comments;    // an array of NSMutableString objects
  NSString       *currentCategory;
  NSDate         *startDate; 
  BOOL           shouldLog;
  NSInteger      assertCount;
}

-(void) addComment:(NSString *)comment;
-(void) assert:(BOOL)b;
-(void) assertError:(FSBlock *)b;
-(void) dealloc;
-(void) finish;
- (id)init;
-(void) setShouldLog:(BOOL)should;
-(void) startCategory:(NSString *)categoryName;
-(void) startTest:(NSString *)testName;

@end

@interface KTestManager(KTestSpecificTests)

- (id *)                 idPointer               ;
- (Class *)              ClassPointer            ; 
- (char *)               charPointer             ;
- (signed char *)        signedCharPointer       ;
- (_Bool *)              _BoolPointer            ;
- (int *)                intPointer              ; 
- (short *)              shortPointer            ; 
- (long *)               longPointer             ; 
- (unsigned char *)      unsignedCharPointer     ; 
- (unsigned int *)       unsignedIntPointer      ; 
- (unsigned short *)     unsignedShortPointer    ; 
- (unsigned long *)      unsignedLongPointer     ; 
- (float *)              floatPointer            ; 
- (double *)             doublePointer           ; 
- (long long *)          longLongPointer         ; 
- (unsigned long long *) unsignedLongLongPointer ; 
- (char **)              charPointerPointer      ;
- (SEL *)                SELPointer              ;
- (NSRange *)            rangePointer            ;   
- (NSPoint *)            pointPointer            ;   
- (NSSize *)             sizePointer             ;
- (CGPoint *)            CGPointPointer          ;   
- (CGSize *)             CGSizePointer           ;   
- (CGRect *)             CGRectPointer           ;   
- (int **)               intPointerPointer       ;
- (void *)               voidPointer             ;

- (int *) staticIntPointer;

- (CGPoint) CGPointMapping:(CGPoint) a;
- (CGSize)  CGSizeMapping:(CGSize) a;
- (CGRect)  CGRectMapping:(CGRect) a;

- (FSArray *) duplicateUsingFastEnemeration:(NSArray *)array;

-(unsigned int) getUINT_MAX;
-(BOOL) runsIn64BitsMode;
-(int) sizeofId;
-(BOOL) testFSNSDistantObjectClassOrMetaclass:(id)p;

-(void) testMethodMappingWithFScriptObject:(id)fscriptObject;

@end
