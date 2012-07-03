/*--------------------------------------------------*/

#import "HSView.h"

/*--------------------------------------------------*/

@implementation UIView (HintSolutions)

+ (id) viewWithCoder:(NSCoder*)coder
{
    return [[self alloc] initWithCoder:coder];
}

+ (id) viewWithFrame:(CGRect)frame;
{
    return [[self alloc] initWithFrame:frame];
}

@end

/*--------------------------------------------------*/
