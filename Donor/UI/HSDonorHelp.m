/*--------------------------------------------------*/

#import "HSDonorViewInformation.h"

/*--------------------------------------------------*/

@implementation HSDonorViewInformation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self != nil)
    {
        [self setTitle:NSLocalizedString(@"Information", @"Information")];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"Information"]];
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
