/*--------------------------------------------------*/

#import "HSDonorHelp.h"

/*--------------------------------------------------*/

@implementation HSDonorHelp

- (id) initWithNibName:(NSString *)nib bundle:(NSBundle *)bundle
{
    self = [super initWithNibName:nib bundle:bundle];
    if(self != nil)
    {
        [self setTitle:NSLocalizedString(@"Information", @"Information")];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"Information"]];
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
