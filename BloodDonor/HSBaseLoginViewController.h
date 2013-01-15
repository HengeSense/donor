//
//  HSLoginViewController.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 10.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSLoginViewController.h"

@interface HSBaseLoginViewController : HSLoginViewController <UITextFieldDelegate>

/// @name UI properties
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *baseAuthorizationButton;

/// @name Functional properties
/**
 * Email to be used for link to facebook account. If this property is set, loginTextField will be filled with this
 *     value and will be disabled. Then if user enters correct password this account will be linked to facebook.
 */
@property (strong, nonatomic) PFUser *facebookUser;

/// @name UI action handlers
- (IBAction)authorizationButtonClicked:(id)sender;
- (IBAction)forgotPasswordButtonClicked:(id)sender;
@end
