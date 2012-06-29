/*--------------------------------------------------*/

#import "HSViewController.h"

/*--------------------------------------------------*/

#import "BloodDonor.h"

/*--------------------------------------------------*/

@interface BDProfileRegView : UIViewController< UIKeyInput >
{
    IBOutlet UITextField *userName;
    IBOutlet UITextField *password;
    IBOutlet UITextField *passwordConfirm;
    IBOutlet UILabel *name;
    IBOutlet UILabel *sex;
    IBOutlet UILabel *bloodGroup;
}

@end

/*--------------------------------------------------*/
