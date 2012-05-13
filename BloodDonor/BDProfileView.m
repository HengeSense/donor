/*--------------------------------------------------*/

#import "BDProfileView.h"

/*--------------------------------------------------*/

@implementation BDProfileView

- (id) initWithNibName:(NSString*)name bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:name bundle:bundle];
    if(self != nil)
    {
    }
    return self;
}

- (void)dealloc
{
    [guestView release];
    [guestDialog release];
    [guestLogIn release];
    [guestSignUp release];
    [userView release];
    [userDialog release];
    [userLogout release];
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewDidUnload
{
    [guestView release];
    guestView = nil;
    [guestDialog release];
    guestDialog = nil;
    [guestLogIn release];
    guestLogIn = nil;
    [guestSignUp release];
    guestSignUp = nil;
    [userView release];
    userView = nil;
    [userDialog release];
    userDialog = nil;
    [userLogout release];
    userLogout = nil;
    [super viewDidUnload];
}

- (IBAction) logIn:(id)sender
{
}

- (IBAction) signUp:(id)sender
{
}

- (IBAction)logOut:(id)sender
{
}

@end

/*--------------------------------------------------*/
