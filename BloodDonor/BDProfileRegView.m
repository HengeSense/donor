/*--------------------------------------------------*/

#import "BDProfileRegView.h"

/*--------------------------------------------------*/

#import "HSBarButtonItem.h"

/*--------------------------------------------------*/

@implementation BDProfileRegView

#pragma mark UIView

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *item = [UIBarButtonItem barButtomItemWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                           target:self
                                                                           action:@selector(signUp:)]
}

- (void) viewDidUnload
{
    userName = nil;
    password = nil;
    passwordConfirm = nil;
    name = nil;
    sex = nil;
    bloodGroup = nil;
    [super viewDidUnload];
}

- (IBAction) signUp:(id)sender
{
    BloodDonorSex signUpSex = BloodDonorSexMan;
    BloodDonorGroup signUpBloodGroup = BloodDonorGroupI;
    BloodDonorRh signUpBloodRh = BloodDonorRhPos;
    
    [[BloodDonor shared] signUpWithUsername:[userName text]
                                   password:[password text]
                                       name:[name text]
                                        sex:signUpSex
                                 bloodGroup:signUpBloodGroup
                                    bloodRh:signUpBloodRh
                                    success:^{
                                    }
                                    failure:^(NSError *error) {
                                    }];
}

#pragma mark -

@end

/*--------------------------------------------------*/
