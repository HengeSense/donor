/*--------------------------------------------------*/

#import "HSBarButtonItem.h"

/*--------------------------------------------------*/

@implementation UIBarButtonItem (HintSolutions)

+ (id) barButtomItemWithImage:(UIImage*)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    return [[[self alloc] initWithImage:image style:style target:target action:action] autorelease];
}

+ (id) barButtomItemWithImage:(UIImage*)image landscapeImagePhone:(UIImage*)landscapeImagePhone style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    return [[[self alloc] initWithImage:image landscapeImagePhone:landscapeImagePhone style:style target:target action:action] autorelease];
}

+ (id) barButtomItemWithTitle:(NSString*)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    return [[[self alloc] initWithTitle:title style:style target:target action:action] autorelease];
}

+ (id) barButtomItemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action
{
    return [[[self alloc] initWithBarButtonSystemItem:systemItem target:target action:action] autorelease];
}

+ (id) barButtomItemWithCustomView:(UIView*)customView
{
    return [[[self alloc] initWithCustomView:customView] autorelease];
}

@end

/*--------------------------------------------------*/
