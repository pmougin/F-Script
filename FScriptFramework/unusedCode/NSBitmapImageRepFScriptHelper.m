//
//  NSBitmapImageRepFScriptHelper.m
//  NSBitmapImageRepFScriptHelper
//
//  Created by Philippe Mougin on Thu Jun 12 2003-2004.
//  Copyright (c) 2003-2004 __MyCompanyName__. All rights reserved.
//

#import "NSBitmapImageRepFScriptHelper.h"
#import "ArrayPrivate.h"
#import "ArrayRepDouble.h"

@protocol FScriptFrameworkDecl
+ arrayRepDoubleWithCapacity:(NSUInteger)capacity;
- (void)addDouble:(double)aDouble;
- initWithRep:(id)rep;
- arrayRep;
- (double *)doublesPtr;
@end


@implementation NSBitmapImageRep(NSBitmapImageRepFScriptHelper)

-(NSArray *) bitmapDataAsArray
{
  NSUInteger byteCount = [self pixelsWide] * [self pixelsHigh] * [self bitsPerPixel] / 8;
  id arrayRep = [NSClassFromString(@"ArrayRepDouble") arrayRepDoubleWithCapacity:byteCount];
  unsigned char *bytes = [self bitmapData];
  NSUInteger i;
  for (i = 0; i < byteCount; i++) { [arrayRep addDouble:bytes[i]]; }   
  return [[NSClassFromString(@"FSArray") alloc] initWithRep:arrayRep];
}


- (id)initWithPlanes:(unsigned char **)planes pixelsWide:(NSInteger)width pixelsHigh:(NSInteger)height bitsPerSample:(NSInteger)bps samplesPerPixel:(NSInteger)spp hasAlpha:(BOOL)alpha isPlanar:(BOOL)isPlanar colorSpaceName:(NSString *)colorSpaceName bytesPerRow:(NSInteger)rowBytes bitsPerPixel:(NSInteger)pixelBits
{
  return [self initWithBitmapDataPlanes:planes pixelsWide:width pixelsHigh:height bitsPerSample:bps samplesPerPixel:spp hasAlpha:alpha isPlanar:isPlanar colorSpaceName:colorSpaceName bytesPerRow:rowBytes bitsPerPixel:pixelBits];
}

- (void) setBitmapDataFromArray:(NSArray *)bitmapArray
{
  unsigned char *bytes = [self bitmapData];
  NSUInteger count = [bitmapArray count];
  NSUInteger i;
  
  if ([bitmapArray isKindOfClass:[FSArray class]] && [[(FSArray *)bitmapArray arrayRep] isKindOfClass:[ArrayRepDouble class]])
  {
    double *doubles = [(ArrayRepDouble *)[(FSArray *)bitmapArray arrayRep] doublesPtr];
    for (i = 0; i < count; i++)
    {
      bytes[i] = doubles[i];
    }
  }
  else
  {
    for (i = 0; i < count; i++)
    {
      id number = [bitmapArray objectAtIndex:i];
      bytes[i] = [number doubleValue];
    }
  }   
}

@end
