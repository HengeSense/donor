/*--------------------------------------------------*/

#import "HSViewController.h"

/*--------------------------------------------------*/

#import "BloodDonor.h"

/*--------------------------------------------------*/

@interface BDProfileView : UIViewController< UITextFieldDelegate >
{
    UITextField *mLastEditing;
    
    IBOutlet UIView *guestView;
    IBOutlet UITextField *guestName;
    IBOutlet UITextField *guestPassword;
    IBOutlet UIButton *guestLogIn;
    IBOutlet UIButton *guestSignUp;
    IBOutlet UIView *userView;
    IBOutlet UILabel *userName;
    IBOutlet UILabel *userSex;
    IBOutlet UILabel *userBloodGroup;
    IBOutlet UILabel *userBloodCount;
    IBOutlet UILabel *userBloodNext;
    IBOutlet UIButton *userLogout;
}

- (void) refresh;

@end

/*--------------------------------------------------*/
