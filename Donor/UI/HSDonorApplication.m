/*--------------------------------------------------*/

#import "HSDonorApplication.h"

/*--------------------------------------------------*/

#import "HSDonorCalendar.h"
#import "HSDonorStations.h"
#import "HSDonorHelp.h"
#import "HSDonorProfile.h"

/*--------------------------------------------------*/

@implementation HSDonorApplication

@synthesize window = mWindow;
@synthesize tabBar = mTabBar;

- (void) dealloc
{
    [mTabBar release];
    [mWindow release];
    [super dealloc];
}

- (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)options
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    mWindow = [[UIWindow windowWithFrame:frame] retain];
    if(mWindow != nil)
    {
        mTabBar = [[UITabBarController tabBar] retain];
        if(mTabBar != nil)
        {
            [mTabBar setViewControllers:[NSArray arrayWithObjects:
                                         [UINavigationController navigaionWithRootViewController:
                                          [HSDonorCalendar viewWithNibName:@"HSDonorCalendar" bundle:nil]],
                                         [UINavigationController navigaionWithRootViewController:
                                          [HSDonorStations viewWithNibName:@"HSDonorStations" bundle:nil]],
                                         [UINavigationController navigaionWithRootViewController:
                                          [HSDonorHelp viewWithNibName:@"HSDonorHelp" bundle:nil]],
                                         [UINavigationController navigaionWithRootViewController:
                                          [HSDonorProfile viewWithNibName:@"HSDonorProfile" bundle:nil]],
                                         nil]];
            [mWindow setRootViewController:mTabBar];
        }
        [mWindow makeKeyAndVisible];
    }
    return YES;
}

@end

/*--------------------------------------------------*/
