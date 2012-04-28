/*--------------------------------------------------*/

#import "HSDonorViewProfileEdit.h"

/*--------------------------------------------------*/

@implementation HSDonorViewProfileEdit

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
    
    UIBarButtonItem *navBack = [UIBarButtonItem barButtomItemWithTitle:NSLocalizedString(@"ProfileEditBack", @"ProfileEditBack")
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
