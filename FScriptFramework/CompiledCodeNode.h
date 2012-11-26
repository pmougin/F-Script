/*   CompiledCodeNode.h Copyright (c) 1998-2008 Philippe Mougin. */
/*   This software is open source. See the license.   */


#import <Foundation/Foundation.h>
#import "FSMsgContext.h" 
#import "FSSymbolTable.h" 
#import "BlockRep.h"
#import "FSCNBase.h"

//enum compiledCodeNode_type {IDENTIFIER, MESSAGE, STATEMENT_LIST, OBJECT, ARRAY, TEST_ABORT, BLOCK, ASSIGNMENT, NUMBER, CASCADE};             

@class FSBlock;
@class FSPattern;
@class FSArray;
@class FSNumber;

@interface CompiledCodeNode: NSObject <NSCopying, NSCoding>
{
@public
  FSArray *subnodes;
  long firstCharIndex;
  long lastCharIndex; 
   
  enum FSCNType nodeType;
  NSString *operator;
  struct FSContextIndex identifier; // IDENTIFIER
  NSString *identifierSymbol;       // IDENTIFIER
  CompiledCodeNode  *receiver;
  NSString *selector;               // used for MESSAGE
  FSMsgContext *msgContext;
  id object;
  SEL sel;
}

+ (id)compiledCodeNode;

- (id)addSubnode:(CompiledCodeNode *)subnode;
- (long)firstCharIndex;
- (long)lastCharIndex;
- (id)copy;
- (id)copyWithZone:(NSZone *)zone;
- (void)dealloc;
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (CompiledCodeNode *)getSubnode:(unsigned)pos;
//- (Array *)getListSubnode;
- (id)init;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (id)insertSubnode:(CompiledCodeNode *)subnode at:(unsigned)pos;
- (unsigned)subnodeCount;
- (id)setSubnode:(CompiledCodeNode *)subnode at:(unsigned)pos;
- (id)removeSubnode:(unsigned)pos;

- (enum FSCNType) nodeType;
- (struct FSContextIndex) identifier;
- (NSString *) identifierSymbol;
- (NSString *) operatorSymbols;
- (CompiledCodeNode *)  receiver;
//- (NSString *) selector;
- (SEL) sel;
- (FSMsgContext *) msgContext;
- (id) object;
- (FSPattern *)pattern;

- (id)setBlockRep:(BlockRep *) theBlockRep;
- (id)setFirstCharIndex:(long)first;
- (id)setLastCharIndex:(long)last;
- (id)setFirstCharIndex:(long)first last:(long)last;
- (id)setFSIdentifier:(struct FSContextIndex) theIdentifier symbol:(NSString *)theSymbol;
- (id)setSubnodes:(FSArray *)theListSubnode;
- (id)setMessageWithReceiver:(CompiledCodeNode *) theReceiver 
                selector:(NSString *)  theSelector
                operatorSymbols:(NSString*) theOperatorSymbols;
- (id)setNodeType:(enum FSCNType) theNodeType;
- (id)setNumber:(FSNumber *)theNumber;
- (id)setobject:(id)theobject;
- (id)setReceiver:(CompiledCodeNode*)theReceiver;

-(void)translateCharRange:(int32_t)translation;                

@end
