/*   FSNSMovie.h Copyright (c) 2003-2009 Philippe Mougin.  */
/*   This software is open source. See the license.   */

#import "FSQTMovie.h"
#import "FSMovieInspector.h"

@implementation QTMovie (FSQTMovie)

-(void)inspect
{
  [FSMovieInspector movieInspectorWithMovie:self];  
}

@end
