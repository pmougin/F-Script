//  FSTask.h Copyright (c) 2002 Joerg Garbers.
//  This software is open source. See the license.

#import <Foundation/Foundation.h>


@interface FSTask : NSObject {
}
+ (void)setInputEncoding:(NSStringEncoding)enc;
+ (void)setOutputEncoding:(NSStringEncoding)enc;
+ (void)setReportErrorOnNotZero:(BOOL)yn;
+ (void)setMaxInterval:(NSTimeInterval)interv;

+ (NSString *)outputOfProgram:(NSString *)program;
+ (NSString *)outputOfProgram:(NSString *)program withArguments:(NSArray *)args;
+ (NSString *)outputOfProgram:(NSString *)program withInput:(NSString *)inputString;
+ (NSString *)outputOfProgram:(NSString *)program withArguments:(NSArray *)args withInput:(NSString *)inputString;
+ (NSString *)outputOfProgram:(NSString *)program withArguments:(NSArray *)args withInput:(NSString *)inputString inputEncoding:(NSStringEncoding)inputEncoding outputEncoding:(NSStringEncoding)outputEncoding;
@end

/* Examples:
FSTask outputOfProgram:'/tmp/x'

FSTask outputOfProgram:'/bin/bash' withInput:'ls
echo done
'
(send-eval "FSTask outputOfProgram:'/bin/bash' withInput:'ls
echo done
' "fs")

FSTask outputOfProgram:'/bin/sleep' withArguments:{'11'}
*/

@interface FSRecursiveReplacer : NSObject
{ 
  NSString *from,*to;
  FSRecursiveReplacer *next;
}
+ (FSRecursiveReplacer *)replacerWithFrom:(NSString *)f to:(NSString *)t next:(FSRecursiveReplacer *)n;
+ (FSRecursiveReplacer *)replacerWithFrom:(NSString *)f to:(NSString *)t;
+ (FSRecursiveReplacer *)returnReplacerFromRToN; // "\r" -> "\n"
+ (FSRecursiveReplacer *)returnReplacerFromNToR; // "\n" -> "\r"
- (id)initWithFrom:(NSString *)f to:(NSString *)t next:(FSRecursiveReplacer *)n;
- (NSString *)transform:(NSString *)str;
@end
@interface FSTaskRunByLisp : FSTask
{
}
// overridden
+ (NSString *)outputOfProgram:(NSString *)program withArguments:(NSArray *)args withInput:(NSString *)inputString inputEncoding:(NSStringEncoding)inputEncoding outputEncoding:(NSStringEncoding)outputEncoding;
@end
