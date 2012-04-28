/*--------------------------------------------------*/

#import "HSNavigationController.h"

/*--------------------------------------------------*/

@implementation UINavigationController (HintSolutions)

+ (id) navigaionWithRootViewController:(UIViewController*)view;
{
    return [[[self alloc] initWithRootViewController:view] autorelease];
}

@end

/*--------------------------------------------------*/
