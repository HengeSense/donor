/*--------------------------------------------------*/

#import "HSDonorCalendar.h"

/*--------------------------------------------------*/

@implementation HSDonorCalendar

- (id) initWithNibName:(NSString *)nib bundle:(NSBundle *)bundle
{
    self = [super initWithNibName:nib bundle:bundle];
    if(self != nil)
    {
        [self setTitle:NSLocalizedString(@"Calendar", @"Calendar")];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"Calendar"]];
    }
    return self;
}
							
- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}

@end

/*--------------------------------------------------*/
