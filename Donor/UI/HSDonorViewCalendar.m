/*--------------------------------------------------*/

#import "HSDonorViewCalendar.h"

/*--------------------------------------------------*/

@implementation HSDonorViewCalendar

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self != nil)
    {
        [self setTitle:NSLocalizedString(@"Calendar", @"Calendar")];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"Calendar"]];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end

/*--------------------------------------------------*/
