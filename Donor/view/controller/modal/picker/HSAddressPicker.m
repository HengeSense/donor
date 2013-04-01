//
//  HSAddressPicker.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 04.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSAddressPicker.h"

#pragma mark - Private interface declaration
@interface HSAddressPicker () <UITextFieldDelegate>

/**
 * Text filed for specifieng address.
 */
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

/**
 * Specifies default value and restrictions for addressTextField property.
 */
- (void)configureAddressTextField;
@end

@implementation HSAddressPicker
#pragma mark - UI lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.addressTextField becomeFirstResponder];
    [self configureAddressTextField];
}

#pragma mark - Public actions implemntations
- (IBAction)doneButtonClicked:(id)sender {
    self.selectedAddress = self.addressTextField.text;
    [self hideWithDone: YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self hideWithDone:NO];
}

#pragma mark - Override
- (void)hideWithDone:(BOOL)isDone {
    [self.addressTextField resignFirstResponder];
    [super hideWithDone:isDone];
}

#pragma mark - UITextFiledDelegate
- (BOOL)textFieldShouldReturn: (UITextField *)textField {
    (void)textField;
    [self hideWithDone:YES];
    return YES;
}

#pragma mark - Private interface implementation
- (void)configureAddressTextField {
    self.addressTextField.text = self.selectedAddress;
}
@end
