/*--------------------------------------------------*/

#import "BDProfileView.h"

/*--------------------------------------------------*/

#import "BDProfileRegView.h"

/*--------------------------------------------------*/

@implementation BDProfileView

#pragma mark UIView

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    if([[BloodDonor shared] isAuthenticated] == YES)
    {
        [guestView setAlpha:0.0];
        [userView setAlpha:1.0];
    }
    else
    {
        [guestView setAlpha:1.0];
        [userView setAlpha:0.0];
    }
    [self refresh];
}

- (void) viewDidUnload
{
    guestView = nil;
    guestName = nil;
    guestPassword = nil;
    guestLogIn = nil;
    guestSignUp = nil;
    userView = nil;
    userName = nil;
    userSex = nil;
    userBloodGroup = nil;
    userBloodCount = nil;
    userBloodNext = nil;
    userLogout = nil;
    [super viewDidUnload];
}

#pragma mark -
#pragma mark BDProfileView

- (void) refresh
{
}

- (IBAction) lastEditingResignFirstResponder:(id)sender
{
    [mLastEditing resignFirstResponder];
}

- (IBAction) logIn:(id)sender
{
    [mLastEditing resignFirstResponder];
    
    [guestLogIn setEnabled:NO];
    [guestSignUp setEnabled:NO];
    
    [[BloodDonor shared] logInWithUsername:[guestName text]
                                  password:[guestPassword text]
                                   success:^() {
                                       [UIView transitionWithView:guestView
                                                         duration:0.4f
                                                          options:(UIViewAnimationOptionCurveEaseOut)
                                                       animations:^{
                                                           [guestView setAlpha:0.0f];
                                                           [userView setAlpha:1.0f];
                                                       }
                                                       completion:^(BOOL finished) {
                                                           [guestSignUp setEnabled:YES];
                                                           [guestLogIn setEnabled:YES];
                                                           [self refresh];
                                                       }];
                                   }
                                   failure:^(NSError *error) {
                                       [guestSignUp setEnabled:YES];
                                       [guestLogIn setEnabled:YES];
                                   }];
}

- (IBAction) signUp:(id)sender
{
    [mLastEditing resignFirstResponder];
    
    BDProfileRegView *view = [BDProfileRegView loadWithNibName:@"BDProfileRegView-iPhone" bundle:nil];
    [[self navigationController] pushViewController:view animated:YES];
}

- (IBAction)logOut:(id)sender
{
    [UIView transitionWithView:userView
                      duration:0.4f
                       options:(UIViewAnimationOptionCurveEaseOut)
                    animations:^{
                        [guestView setAlpha:1.0f];
                        [userView setAlpha:0.0f];
                    }
                    completion:^(BOOL finished) {
                        [[BloodDonor shared] logOut];
                        [self refresh];
                    }];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    mLastEditing = textField;
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    mLastEditing = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -

@end

/*--------------------------------------------------*/
