/*--------------------------------------------------*/

#import <UIKit/UIKit.h>

/*--------------------------------------------------*/

#import "BDRootView.h"

/*--------------------------------------------------*/

@interface BDApplication : NSObject< UIApplicationDelegate, UITabBarControllerDelegate >
{
    UIWindow *mWindow;
    BDRootView *mRootView;
}

@property (nonatomic, retain) BDRootView *rootView;

@end

/*--------------------------------------------------*/
