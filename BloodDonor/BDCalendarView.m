/*--------------------------------------------------*/

#import "BDCalendarView.h"

/*--------------------------------------------------*/

@implementation BDCalendarView

- (id) initWithNibName:(NSString*)name bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:name bundle:bundle];
    if(self != nil)
    {
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = [[self view] frame];
    mPullView = [HSPullView viewWithSuperViewFrame:frame
                                        headerSize:40.0f
                                         direction:HSPullDirectionBottom
                                            opened:NO];
    if(mPullView != nil)
    {
        [[mPullView handleView] setBackgroundColor:[UIColor redColor]];
        [[mPullView clientView] setBackgroundColor:[UIColor greenColor]];
        [mPullView setBackgroundColor:[UIColor blueColor]];
        [mPullView setDelegate:self];
        
        [[self view] addSubview:mPullView];

    }
    
    if([[BloodDonor shared] isAuthenticated] == NO)
    {
        [[self tabBarController] setSelectedIndex:3];
    }
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}

@end

/*--------------------------------------------------*/
