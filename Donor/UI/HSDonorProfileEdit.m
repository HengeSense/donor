/*--------------------------------------------------*/

#import "HSDonorProfileEdit.h"

/*--------------------------------------------------*/

@implementation HSDonorProfileEdit

- (id) initWithNibName:(NSString *)nib bundle:(NSBundle *)bundle
{
    self = [super initWithNibName:nib bundle:bundle];
    if(self != nil)
    {
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *navBack = [UIBarButtonItem barButtomItemWithTitle:NSLocalizedString(@"ProfileEditBack", @"ProfileEditBack")
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(navBack:)];
	[[self navigationItem] setLeftBarButtonItem:navBack];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}

- (void) navBack:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

@end

/*--------------------------------------------------*/
