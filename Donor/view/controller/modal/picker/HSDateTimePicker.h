//
//  HSDateTimePicker.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 03.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSPicker.h"

/**
 * Provides view of date and time picker and handles it's show and hide process.
 */
@interface HSDateTimePicker : HSPicker

/// @name Properties

/**
 * Selected date and time.
 */
@property (nonatomic, strong, readonly) NSDate *selectedDate;

/**
 * Show HSDateTimePicker view over the specified view.
 *     And hides it when user taps "Готово" or "Отмена" button.
 *
 * @param startDate, endDate - date selection diapason
 * @param currentDate default selection date
 * @param completion block of code, invoked before view will completely disapeared
 */
- (void)showWithStartDate: (NSDate *)startDate endDate: (NSDate *)endDate currentDate: (NSDate *) currentDate
               completion: (HSPickerCompletion)completion;

/**
 * If user taps button "Готово", selectedDate property will change it's value.
 */
- (IBAction)doneButtonClicked: (id)sender;

/**
 * If user taps button "Отмена", selectedDate property will not change it's value.
 */
- (IBAction)cancelButtonClicked: (id)sender;

@end
