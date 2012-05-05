/*--------------------------------------------------*/

#import "HSDonorViewProfile.h"

/*--------------------------------------------------*/

#import "HSDonorViewProfilePreference.h"

/*--------------------------------------------------*/

@implementation HSDonorViewProfile

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self != nil)
    {
        [self setTitle:NSLocalizedString(@"Profile", @"Profile")];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"Profile"]];
    }
    return self;
}

- (void) dealloc
{
    [invalid release];
    [login release];
    [password release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *navPreference = [UIBarButtonItem barButtomItemWithTitle:NSLocalizedString(@"ProfilePreference", @"ProfilePreference")
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(preference:)];
	[[self navigationItem] setLeftBarButtonItem:navPreference];
}

- (void)viewDidUnload
{
    if(invalid != nil)
    {
        [invalid release];
        invalid = nil;
    }
    if(login != nil)
    {
        [login release];
        login = nil;
    }
    if(password != nil)
    {
        [password release];
        password = nil;
    }
    [super viewDidUnload];
}

- (IBAction) login:(id)sender
{
}

- (IBAction)forgot:(id)sender
{
}

- (void) preference:(id)sender
{
    HSDonorViewProfilePreference *view = [HSDonorViewProfilePreference viewWithNibName:@"HSDonorViewProfilePreference" bundle:nil];
    if(view != nil)
    {
        [[self navigationController] pushViewController:view animated:YES];
    }
}

@end

/*--------------------------------------------------*/
