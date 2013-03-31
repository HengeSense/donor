//
//  HSBloodDonationTypePicker.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 02.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSBloodDonationType.h"
#import "HSPicker.h"

@interface HSBloodDonationTypePicker : HSPicker

/**
 * Contains picked value.
 */
@property (nonatomic, assign, readonly) HSBloodDonationType bloodDonationType;

/**
 * Show picker with specified initial blood donatio type.
 */
- (void)showWithBloodDonationType:(HSBloodDonationType)bloodDonationType completion:(HSPickerCompletion)completion;

/**
 * If user taps button "Готово", bloodDonationType property will change it's value.
 */
- (IBAction)doneButtonClicked: (id)sender;

/**
 * If user taps button "Отмена", bloodDonationType property will not change it's value.
 */
- (IBAction)cancelButtonClicked: (id)sender;

@end
