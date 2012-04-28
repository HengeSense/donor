/*--------------------------------------------------*/

#import "HSNavigationBarController.h"

/*--------------------------------------------------*/

@implementation UINavigationBarController (HintSolutions)

+ (id) navigaionBarWithRootViewController:(UIViewController*)view;
{
    return [[[self alloc] initWithRootViewController:view] autorelease];
}

@end

/*--------------------------------------------------*/
