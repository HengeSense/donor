/*--------------------------------------------------*/

#import "HSDonorApplication.h"

/*--------------------------------------------------*/

#import "HSDonorViewCalendar.h"
#import "HSDonorViewStations.h"
#import "HSDonorViewInformation.h"
#import "HSDonorViewProfile.h"

/*--------------------------------------------------*/

@implementation HSDonorApplication

@synthesize window = mWindow;
@synthesize tabBar = mTabBar;

- (void)dealloc
{
    [mTabBar release];
    [mWindow release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
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
                                          [HSDonorViewCalendar viewWithNibName:@"HSDonorViewCalendar" bundle:nil]],
                                         [UINavigationController navigaionWithRootViewController:
                                          [HSDonorViewStations viewWithNibName:@"HSDonorViewStations" bundle:nil]],
                                         [UINavigationController navigaionWithRootViewController:
                                          [HSDonorViewInformation viewWithNibName:@"HSDonorViewInformation" bundle:nil]],
                                         [UINavigationController navigaionWithRootViewController:
                                          [HSDonorViewProfile viewWithNibName:@"HSDonorViewProfile" bundle:nil]],
                                         nil]];
            [mWindow setRootViewController:mTabBar];
        }
        [mWindow makeKeyAndVisible];
    }
    return YES;
}

@end

/*--------------------------------------------------*/
