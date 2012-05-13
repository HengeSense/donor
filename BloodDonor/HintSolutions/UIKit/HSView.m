/*--------------------------------------------------*/

#import "HSView.h"

/*--------------------------------------------------*/

@implementation UIView (HintSolutions)

+ (id) viewWithFrame:(CGRect)frame;
{
    return [[[self alloc] initWithFrame:frame] autorelease];
}

@end

/*--------------------------------------------------*/
