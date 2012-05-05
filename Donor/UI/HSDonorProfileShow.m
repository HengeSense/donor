/*--------------------------------------------------*/

#import "HSDonorProfileShow.h"

/*--------------------------------------------------*/

@implementation HSDonorProfileShow

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
    
    UIBarButtonItem *navBack = [UIBarButtonItem barButtomItemWithTitle:NSLocalizedString(@"ProfileShowBack", @"ProfileShowBack")
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(navBack:)];
	[[self navigationItem] setLeftBarButtonItem:navBack];
}

- (void) viewDidUnload
{
    if(info != nil)
    {
        [info release];
        info = nil;
    }
    [super viewDidUnload];
}

- (void) dealloc
{
    [info release];
    [super dealloc];
}

- (IBAction)logout:(id)sender
{
}

- (void) navBack:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

@end

/*--------------------------------------------------*/
