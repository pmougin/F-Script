#import <Foundation/Foundation.h>

typedef struct {int a; int b;} fsstruct;

@interface TestFS : NSObject 
{
 NSString *str1, *str2, *str3, *str4;
 NSInteger     total;
 float p_p1;
 BOOL p_toto;
 id p_tutu; 
 fsstruct p_zozo;
 double ddd;
}

@property float p1;
@property BOOL toto;
//@property fsstruct zozo;
@property(retain) id tutu;
//@property id dynamicProperty;

@end


@interface TestFSSub : TestFS 
{
}
@end