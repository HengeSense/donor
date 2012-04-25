/*--------------------------------------------------*/

#import "HSDonorApplication.h"

/*--------------------------------------------------*/

#import "HSDonorViewCalendar.h"
#import "HSDonorViewStations.h"
#import "HSDonorViewInformation.h"
#import "HSDonorViewSettings.h"

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
            mTabBar.viewControllers = [NSArray arrayWithObjects:
                                       [[HSDonorViewCalendar viewWithNibName:@"HSDonorViewCalendar" bundle:nil] retain],
                                       [[HSDonorViewStations viewWithNibName:@"HSDonorViewStations" bundle:nil] retain],
                                       [[HSDonorViewInformation viewWithNibName:@"HSDonorViewInformation" bundle:nil] retain],
                                       [[HSDonorViewSettings viewWithNibName:@"HSDonorViewSettings" bundle:nil] retain],
                                       nil];
            mWindow.rootViewController = mTabBar;
        }
        [mWindow makeKeyAndVisible];
    }
    return YES;
}

@end

/*--------------------------------------------------*/
