//
//  HSBloodDonationTypePicker.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 02.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSBloodDonationTypePicker.h"

#pragma mark - Private constants
static const CGFloat kShowHideAnimationDuration = 0.3f;
static const NSUInteger kNumberOfSupportedBloodDonationTypes = 4;


@interface HSBloodDonationTypePicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) HSBloodDonationType bloodDonationType;
@property (nonatomic, copy) void(^completion)(BOOL isDone);

/**
 * Hides view, invokes completion block with specified result.
 */
- (void)hideViewWithResult: (BOOL)isDone;

/**
 * Shows view in the specified container view.
 */
- (void)showViewInView: (UIView *)containerView;

@end

@implementation HSBloodDonationTypePicker

- (void)showInView: (UIView *)containerView bloodDonationType: (HSBloodDonationType)bloodDonationType
        completion: (void (^)(BOOL))completion {
    THROW_IF_ARGUMENT_NIL(containerView ,@"containerView is not specifed");
    self.bloodDonationType = bloodDonationType;
    self.completion = completion;
    [self showViewInView: containerView];
}

- (IBAction)doneButtonClicked:(id)sender {
    [self hideViewWithResult: YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self hideViewWithResult: NO];
}

#pragma mark - UIPickerViewDataSource protocol implementation
-(NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView {
    (void)pickerView;
    return 1;
}

- (NSInteger)pickerView: (UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    (void)pickerView;
    (void)component;
    return kNumberOfSupportedBloodDonationTypes;
}

#pragma mark - UIPickerViewDelegate implementation
-(NSString *)pickerView: (UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent:(NSInteger)component {
    (void)pickerView;
    (void)component;
    HSBloodDonationType bloodDonationType = [self pickerRowToBloodDonationType: row];
    return bloodDonationTypeToString(bloodDonationType);
};

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    (void)pickerView;
    (void)component;
    self.bloodDonationType = [self pickerRowToBloodDonationType: row];
}

#pragma mark - Private interface implementation

- (void)showViewInView: (UIView *)containerView {
    [UIView animateWithDuration: kShowHideAnimationDuration animations: ^{
        [containerView addSubview: self.view];
        self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }];
}

- (void)hideViewWithResult: (BOOL)isDone {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect outOfBoundsFrame =
            CGRectMake(0, screenBounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [UIView animateWithDuration: kShowHideAnimationDuration animations:^{
        self.view.frame = outOfBoundsFrame;
    } completion: ^(BOOL finished) {
        [self.view removeFromSuperview];
        if (self.completion != nil) {
            self.completion(isDone);
        }
    }];
}

#pragma mark - Private utility metods
- (HSBloodDonationType)pickerRowToBloodDonationType: (NSUInteger)row {
    if (row >= kNumberOfSupportedBloodDonationTypes) {
        @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                       reason: @"Specified row for unsupported blood donation type." userInfo: nil];
    }
    switch (row) {
        case 0:
            return HSBloodDonationType_Blood;
        case 1:
            return HSBloodDonationType_Granulocytes;
        case 2:
            return HSBloodDonationType_Plasma;
        case 3:
            return HSBloodDonationType_Platelets;
        default:
            @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                           reason: @"Unknown blood donation type for the specified row." userInfo: nil];
    }
}

@end
