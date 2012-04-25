/*--------------------------------------------------*/

#import "HSWindow.h"

/*--------------------------------------------------*/

@implementation UIWindow (HintSolutions)

+ (id) windowWithFrame:(CGRect)frame
{
    return [[[self alloc] initWithFrame:frame] autorelease];
}

@end

/*--------------------------------------------------*/
