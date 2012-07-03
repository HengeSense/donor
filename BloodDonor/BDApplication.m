/*--------------------------------------------------*/

#import "BDApplication.h"

/*--------------------------------------------------*/

@implementation BDApplication

#pragma mark Property

@synthesize window = mWindow;
@synthesize rootView = mRootView;

#pragma mark -
#pragma mark UIApplicationDelegate

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    [[BloodDonor shared] setApplicationId:BD_PARSE_APPLICATION_ID
                                clientKey:BD_PARSE_CLIENT_KEY];
    
    NSArray *nib = nil;
    switch(UI_USER_INTERFACE_IDIOM())
    {
        case UIUserInterfaceIdiomPhone:
            nib = [[NSBundle mainBundle] loadNibNamed:@"BDRootView-iPhone" owner:self options:nil];
            break;
        case UIUserInterfaceIdiomPad:
            nib = [[NSBundle mainBundle] loadNibNamed:@"BDRootView-iPad" owner:self options:nil];
            break;
    }
    for(id item in nib)
    {
        if([item isKindOfClass:[BDRootView class]] == YES)
        {
            mRootView = item;
            break;
        }
    }
    if(mRootView != nil)
    {
        mWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        if(mWindow != nil)
        {
            [mWindow setRootViewController:mRootView];
            [mWindow makeKeyAndVisible];
        }
    }
}

- (void) applicationWillTerminate:(UIApplication*)application
{
    mWindow = nil;
}

#pragma mark -

@end

/*--------------------------------------------------*/

