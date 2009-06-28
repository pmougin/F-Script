/* FScriptTextView.h Copyright (c) 2002-2006 Philippe Mougin.  */
/*   This software is open source. See the license.  */ 

#import <AppKit/AppKit.h>
 
@interface FScriptTextView : NSTextView {

}

+ (void)initialize;

+ (void)registerClassNameForCompletion: (NSString *)className;
+ (void)registerMethodNameForCompletion:(NSString *)methodName;

@end
