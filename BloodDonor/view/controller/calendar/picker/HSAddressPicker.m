//
//  HSAddressPicker.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 04.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSAddressPicker.h"

#pragma mark - Private constants
static const CGFloat kShowHideAnimationDuration = 0.3f;

#pragma mark - Private interface declaration
@interface HSAddressPicker () <UITextFieldDelegate>

/**
 * Text filed for specifieng address.
 */
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

/**
 * Current selected address, removed readonly restriction.
 */
@property (nonatomic, strong) NSString *selectedAddress;

/**
 * Copy of user defined completion block.
 */
@property (nonatomic, copy) void(^completion)(BOOL isDone);

/**
 * Hides view, invokes completion block with specified result.
 */
- (void)hideViewWithResult: (BOOL)isDone;

/**
 * Shows view in the specified container view.
 */
- (void)showViewInView: (UIView *)containerView;

/**
 * Specifies default value and restrictions for addressTextField property.
 */
- (void)configureAddressTextField;
@end

@implementation HSAddressPicker

- (void)showInView: (UIView *)containerView defaultAddress: (NSString *)defaultAdress
        completion: (void (^)(BOOL))completion {

    THROW_IF_ARGUMENT_NIL(completion, @"completion is not specified");
    self.completion = completion;
    self.selectedAddress = defaultAdress;
    [self showViewInView: containerView];
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

- (void)showViewInView: (UIView *)containerView {
    [UIView animateWithDuration: kShowHideAnimationDuration animations: ^{
        [containerView addSubview: self.view];
        self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        [self.addressTextField becomeFirstResponder];
    } completion: ^(BOOL finished) {
        [self configureAddressTextField];
    }];
}

- (void)hideViewWithResult: (BOOL)isDone {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect outOfBoundsFrame =
            CGRectMake(0, screenBounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    self.selectedAddress = self.addressTextField.text;
    
    [UIView animateWithDuration: kShowHideAnimationDuration animations:^{
        self.view.frame = outOfBoundsFrame;
        [self.addressTextField resignFirstResponder];
    } completion: ^(BOOL finished) {
        [self.view removeFromSuperview];
        if (self.completion != nil) {
            self.completion(isDone);
        }
    }];
}

- (void)configureAddressTextField {
    self.addressTextField.text = self.selectedAddress;
}
@end
