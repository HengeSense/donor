/*--------------------------------------------------*/

#import "HSDonorViewSettings.h"

/*--------------------------------------------------*/

@implementation HSDonorViewSettings

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self != nil)
    {
        [self setTitle:NSLocalizedString(@"Settings", @"Settings")];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"Settings"]];
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
