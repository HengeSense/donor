/*--------------------------------------------------*/

#import "HSDonorStations.h"

/*--------------------------------------------------*/

@implementation HSDonorStations

- (id) initWithNibName:(NSString *)nib bundle:(NSBundle *)bundle
{
    self = [super initWithNibName:nib bundle:bundle];
    if(self != nil)
    {
        [self setTitle:NSLocalizedString(@"Stations", @"Stations")];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"Stations"]];
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
