/*--------------------------------------------------*/

#import "BDApplication.h"

/*--------------------------------------------------*/

@implementation BDApplication

@synthesize window = mWindow;

- (void) dealloc
{
    [self setWindow:nil];
    [super dealloc];
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    [mWindow makeKeyAndVisible];
}

@end

/*--------------------------------------------------*/

