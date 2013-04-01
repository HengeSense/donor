//
//  HSProfileRegistrationViewController.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 30.03.13.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSSexPicker;
@class HSBloodTypePicker;

@interface HSProfileRegistrationViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *sexButton;
@property (nonatomic, weak) IBOutlet UIButton *bloodGroupButton;

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordConfirmTextField;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;

@property (nonatomic, weak) IBOutlet UIView *dataView;


- (IBAction)cancelButtonClick:(id)sender;
- (IBAction)doneButtonClick:(id)sender;
- (IBAction)sexButtonClick:(id)sender;
- (IBAction)bloodGroupButtonClick:(id)sender;

@end
