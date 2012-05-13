/*--------------------------------------------------*/

#import <UIKit/UIKit.h>

/*--------------------------------------------------*/

#import "BloodDonor.h"

/*--------------------------------------------------*/

@interface BDApplication : NSObject< UIApplicationDelegate, UITabBarControllerDelegate >
{
    UIWindow *mWindow;
    UITabBarController *mTabBar;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBar;

@end

/*--------------------------------------------------*/
