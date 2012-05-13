/*--------------------------------------------------*/

#import "BDApplication.h"

/*--------------------------------------------------*/

@implementation BDApplication

@synthesize window = mWindow;
@synthesize tabBar = mTabBar;

- (void) dealloc
{
    [self setWindow:nil];
    [self setTabBar:nil];
    [super dealloc];
}

- (void) tabBarController:(UITabBarController*)tabBar didSelectViewController:(UIViewController*)view
{
}

@end

/*--------------------------------------------------*/

