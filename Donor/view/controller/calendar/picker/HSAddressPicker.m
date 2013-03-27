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
 * Copy of user defined completion block.
 */
@property (nonatomic, copy) void(^completion)(BOOL isDone);

/**
 * Hides view, invokes completion block with specified result.
 */
- (void)hideViewWithResult: (BOOL)isDone;

/**
 * Specifies default value and restrictions for addressTextField property.
 */
- (void)configureAddressTextField;
@end

@implementation HSAddressPicker

- (void)showWithCompletion: (void (^)(BOOL))completion {

    THROW_IF_ARGUMENT_NIL(completion);
    self.completion = completion;
    [self showModal];
}

#pragma mark - UI lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.addressTextField becomeFirstResponder];
    [self configureAddressTextField];
}

- (void)viewDidUnload {
    [self setAddressTextField:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.addressTextField becomeFirstResponder];
    [self configureAddressTextField];
}

#pragma mark - Public actions implemntations
- (IBAction)doneButtonClicked: (id)sender {
    self.selectedAddress = self.addressTextField.text;
    [self hideViewWithResult: YES];
}

- (IBAction)cancelButtonClicked: (id)sender {
    [self hideViewWithResult: NO];
}

#pragma mark - UITextFiledDelegate
- (BOOL)textFieldShouldReturn: (UITextField *)textField {
    (void)textField;
    [self hideViewWithResult: YES];
    return YES;
}

#pragma mark - Private interface implementation
- (void)hideViewWithResult: (BOOL)isDone {
    [self hideModal];
    [self.addressTextField resignFirstResponder];
    if (self.completion != nil) {
        self.completion(isDone);
    }
}

- (void)configureAddressTextField {
    self.addressTextField.text = self.selectedAddress;
}
@end
