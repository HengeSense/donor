/*--------------------------------------------------*/

#import "HSDonorProfileRegistred.h"

/*--------------------------------------------------*/

@implementation HSDonorProfileRegistred

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
    
    UIBarButtonItem *navBack = [UIBarButtonItem barButtomItemWithTitle:NSLocalizedString(@"ProfileRegistredBack", @"ProfileRegistredBack")
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
