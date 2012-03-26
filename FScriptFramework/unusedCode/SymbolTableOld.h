/*   SymbolTable.h Copyright (c) 1998-2005 Philippe Mougin.  */
/*   This software is open source. See the license.  */  

#import <Foundation/Foundation.h>
#import "FSContext.h"

@class Array;

enum SymbolTable_value_type {VARIABLE,CLASS,CONSTANT,ARGUMENT};
enum SymbolTable_symbol_status {DEFINED,UNDEFINED};

@interface SymbolTableValueWrapper : NSObject <NSCopying , NSCoding>
{
@public
  enum SymbolTable_value_type type;
  enum SymbolTable_symbol_status status;
  id value;
  NSString *symbol;
  NSUInteger retainCount;
}  

- (id)copy;

- (id)copyWithZone:(NSZone *)zone;

- (void)encodeWithCoder:(NSCoder *)coder;

- (id)initWithCoder:(NSCoder *)coder;

- initWrapperWithValue:(id)theValue type:(enum SymbolTable_value_type)theType
                 symbol:(NSString *)theSymbol;

- initWrapperWithValue:(id)theValue type:(enum SymbolTable_value_type)theType
               symbol:(NSString *)theSymbol 
               status:(enum SymbolTable_symbol_status)theStatus;
// symbol is not copied.

- (void)setValue:(id)theValue;

- (enum SymbolTable_symbol_status)status;

- (NSString *)symbol;

- (enum SymbolTable_value_type)type;

- (id)value;

@end

@interface SymbolTable : FSContext
{
  NSMutableDictionary *symbTable;
  Array *valueWrappers;
  BOOL tryToAttachWhenDecoding;
}

+ (void)initialize;
+ symbolTable;

- (Array *)allDefinedSymbols;

- (BOOL) containsSymbolAtFirstLevel:(NSString *)theKey;

- (id)copy;
- (id)copyWithZone:(NSZone *)zone;

- (void)dealloc;

- (void)encodeWithCoder:(NSCoder *)coder;

- (struct FSContextIndex)findOrInsertSymbol:(NSString*)theKey;

- (struct FSContextIndex)indexOfSymbol:(NSString *)theKey;

- init;

- initWithParent:(SymbolTable *)theParent;

- initWithParent:(SymbolTable *)theParent tryToAttachWhenDecoding:(BOOL)shouldTry;

- (id)initWithCoder:(NSCoder *)coder;

- (struct FSContextIndex)insertSymbol:(NSString*)theKey value:(id)theValue;

- (struct FSContextIndex)insertSymbol:(NSString*)theKey value:(id)theValue
                                   type:(enum SymbolTable_value_type)theType;
                                   
- (struct FSContextIndex)insertSymbol:(NSString*)theKey value:(id)theValue 
                           type:(enum SymbolTable_value_type)theType
                           status:(enum SymbolTable_symbol_status)theStatus;                                   
// theKey is not copied

- (BOOL) isEmpty;

- (id)objectForSymbol:(NSString *)symbol found:(BOOL *)found; // foud may be passed as NULL

- (SymbolTable *) parent;

- (void)removeAllObjects;

-(void)setObject:(id)object forSymbol:(NSString *)symbol;

- (void) setParent:(SymbolTable *)theParent;

- (void)setToNilSymbolsFrom:(NSUInteger)ind;

- (NSString *)symbolForIndex:(struct FSContextIndex)index;

@end
