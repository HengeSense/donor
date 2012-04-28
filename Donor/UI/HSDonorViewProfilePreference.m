/*--------------------------------------------------*/

#import "HSDonorViewProfilePreference.h"

/*--------------------------------------------------*/

@implementation HSDonorViewProfilePreference

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self != nil)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *navBack = [UIBarButtonItem barButtomItemWithTitle:NSLocalizedString(@"ProfilePreferenceBack", @"ProfilePreferenceBack")
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(navBack:)];
	[[self navigationItem] setLeftBarButtonItem:navBack];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void) navBack:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

@end

/*--------------------------------------------------*/
