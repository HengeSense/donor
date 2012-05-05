/*--------------------------------------------------*/

#import "HSDonorViewStations.h"

/*--------------------------------------------------*/

@implementation HSDonorViewStations

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self != nil)
    {
        [self setTitle:NSLocalizedString(@"Stations", @"Stations")];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"Stations"]];
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
