//
//  HSBloodDonationTypePicker.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 02.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSBloodDonationTypePicker.h"

#pragma mark - Private constants
static const NSUInteger kNumberOfSupportedBloodDonationTypes = 4;


@interface HSBloodDonationTypePicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *bloodDonatioTypePickerView;

@property (nonatomic, copy) void(^completion)(BOOL isDone);

/**
 * Hides view, invokes completion block with specified result.
 */
- (void)hideViewWithResult: (BOOL)isDone;

@end

@implementation HSBloodDonationTypePicker

- (void)showWithCompletion: (void (^)(BOOL))completion {
    self.completion = completion;
    [self showModal];
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
    HSBloodDonationType bloodDonationType = [self bloodDonationTypeForPickerRow: row];
    return bloodDonationTypeToString(bloodDonationType);
};

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    (void)pickerView;
    (void)component;
    self.bloodDonationType = [self bloodDonationTypeForPickerRow: row];
}

#pragma mark - Private interface implementation
- (void)hideViewWithResult: (BOOL)isDone {
    [self hideModal];
    if (self.completion != nil) {
        self.completion(isDone);
    }
}

#pragma mark - Private utility metods
- (HSBloodDonationType)bloodDonationTypeForPickerRow: (NSUInteger)row {
    if (row >= kNumberOfSupportedBloodDonationTypes) {
        @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                       reason: @"Specified row for unsupported blood donation type." userInfo: nil];
    }
    switch (row) {
        case 0:
            return HSBloodDonationType_Blood;
        case 1:
            return HSBloodDonationType_Platelets;
        case 2:
            return HSBloodDonationType_Plasma;
        case 3:
            return HSBloodDonationType_Granulocytes;
        default:
            @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                           reason: @"Unknown blood donation type for the specified row." userInfo: nil];
    }
}
- (NSUInteger)pickerRowForBloodDonationType: (HSBloodDonationType)bloofDonationType {
    switch (bloofDonationType) {
        case HSBloodDonationType_Blood:
            return 0;
        case HSBloodDonationType_Platelets:
            return 1;
        case HSBloodDonationType_Plasma:
            return 2;
        case HSBloodDonationType_Granulocytes:
            return 3;
        default:
            return 0;
    }
}

- (void)viewDidUnload {
    [self setBloodDonatioTypePickerView:nil];
    [super viewDidUnload];
}
@end
