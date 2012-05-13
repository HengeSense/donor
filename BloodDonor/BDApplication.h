/*--------------------------------------------------*/

#import <UIKit/UIKit.h>

/*--------------------------------------------------*/

@interface BDApplication : NSObject< UIApplicationDelegate, UITabBarControllerDelegate >
{
    UIWindow *mWindow;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

/*--------------------------------------------------*/
