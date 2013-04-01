//
//  HSRemindDatePicker.h
//  Donor
//
//  Created by Sergey Seroshtan on 20.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSPicker.h"

@interface HSRemindDatePicker : HSPicker

/// @name Default values accessors.
/**
 * Returns time shift default value for reminder picker.
 */
+ (NSTimeInterval)reminderTimeShiftDefault;

/**
 * Returns string representation of time shift default value for reminder picker.
 */
+ (NSString *)reminderTimeShiftStringDefault;

/**
 * Returns string representation of specified reminder time shift.
 */
+ (NSString *)stringFromReminderTimeShift:(NSTimeInterval)reminderTimeShift;

/**
 * Returns the closest available value of reminder time shift for the specified reminder time shift.
 * Can be negative.
 */
+ (NSTimeInterval)closestReminderTimeShift:(NSTimeInterval)reminderTimeShift;

/// @name Result accessors.
/**
 * Selected time interval, which specifies time shift from actual event to remind event.
 * If value is negative, it means that user does not want to be notified.
 * Note, this time value is specified in seconds.
 */
@property (nonatomic, assign, readonly) NSTimeInterval reminderTimeShift;

/**
 * String representation of [self reminderTimeShift].
 */
@property (nonatomic, strong, readonly) NSString *reminderTimeShiftString;

/// @name Configuration
/**
 * Shows reminder picker with specified initial selected remind time interval shift.
 * @see [self reminderTimeShift];
 */
- (void)showWithInitialReminderTimeInterval:(NSTimeInterval)initialTimeInterval
        completion:(HSPickerCompletion)completion;

/// @name Action handlers
/**
 * If user taps button "Готово", selectedDate property will change it's value.
 */
- (IBAction)doneButtonClicked:(id)sender;

/**
 * If user taps button "Отмена", selectedDate property will not change it's value.
 */
- (IBAction)cancelButtonClicked:(id)sender;

@end
