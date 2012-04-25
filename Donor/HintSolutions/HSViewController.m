/*--------------------------------------------------*/

#import "HSViewController.h"

/*--------------------------------------------------*/

@implementation UIViewController (HintSolutions)

+ (id) viewWithNibName:(NSString*)name bundle:(NSBundle*)bundle
{
    return [[[self alloc] initWithNibName:name bundle:bundle] autorelease];
}

@end

/*--------------------------------------------------*/
