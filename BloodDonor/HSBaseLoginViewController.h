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

@property (nonatomic, weak) IBOutlet UITextField *loginTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *baseAuthorizationButton;

- (IBAction)authorizationButtonClicked:(id)sender;

- (IBAction)forgotPasswordButtonClicked:(id)sender;
@end
