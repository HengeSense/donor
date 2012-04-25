/*--------------------------------------------------*/

#import "HSDonor.h"

/*--------------------------------------------------*/

#import "HSWindow.h"
#import "HSTabBarController.h"
#import "HSViewController.h"

/*--------------------------------------------------*/

@interface HSDonorApplication : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    UIWindow *mWindow;
    UITabBarController *mTabBar;
}

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabBar;

@end

/*--------------------------------------------------*/
