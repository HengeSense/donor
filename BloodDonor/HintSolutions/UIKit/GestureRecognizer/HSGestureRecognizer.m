/*--------------------------------------------------*/

#import "HSGestureRecognizer.h"

/*--------------------------------------------------*/

@implementation UIGestureRecognizer (HintSolutions)

+ (id) gestureRecognizerWithTarget:(id)target action:(SEL)action
{
    return [[[self alloc] initWithTarget:target action:action] autorelease];
}

@end

/*--------------------------------------------------*/
