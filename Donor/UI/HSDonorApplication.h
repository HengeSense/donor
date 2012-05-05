/*--------------------------------------------------*/

#import "HSDonor.h"

/*--------------------------------------------------*/

#import "HSWindow.h"
#import "HSViewController.h"
#import "HSNavigationController.h"
#import "HSTabBarController.h"

/*--------------------------------------------------*/

@interface HSDonorApplication : UIResponder< UIApplicationDelegate, UITabBarControllerDelegate >
{
    UIWindow *mWindow;
    UITabBarController *mTabBar;
}

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabBar;

@end

/*--------------------------------------------------*/
