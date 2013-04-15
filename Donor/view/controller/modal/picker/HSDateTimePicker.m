//
//  HSDateTimePicker.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 03.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSDateTimePicker.h"

#pragma mark - Private types
typedef enum {
    HSDateTimePickerComponents_Date = 0,
    HSDateTimePickerComponents_Hour = 1,
    HSDateTimePickerComponents_Minute = 2
} HSDateTimePickerComponents;

#pragma mark - Private constants
static const CGFloat kShowHideAnimationDuration = 0.3f;

/**
 * Number of components displayed by picker (date, hour, minute).
 */
static const NSUInteger kDateTimePickerComponentsNumber = 3;

#pragma mark - Privtae interface implementation
@interface HSDateTimePicker ()

/**
 * Picker reference.
 */
@property (nonatomic, weak) IBOutlet UIDatePicker *dateTimePicker;

/**
 * Minimum selection date.
 */
@property (nonatomic, strong) NSDate *startDate;

/**
 * Maximum selection date.
 */
@property (nonatomic, strong) NSDate *endDate;

/**
 * Selected date property with readonly restriction removement.
 */
@property (nonatomic, strong) NSDate *selectedDate;

/**
 * Configures date and time picker view with specified restrictions.
 */
- (void)configureDateTimePickerView;

@end

@implementation HSDateTimePicker

#pragma mark - Public interface implementation
- (void)showWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate currentDate:(NSDate *)currentDate
               completion:(HSPickerCompletion)completion {
    THROW_IF_ARGUMENT_NIL(startDate);
    THROW_IF_ARGUMENT_NIL(currentDate);
    THROW_IF_ARGUMENT_NIL(endDate);
    
    self.startDate = startDate;
    self.endDate = endDate;
    self.selectedDate = currentDate;

    [self showWithCompletion:completion];
}


#pragma mark - Public actions implemntations
- (IBAction)doneButtonClicked:(id)sender {
    self.selectedDate = self.dateTimePicker.date;
    [self hideWithDone:YES];
}

- (IBAction)cancelButtonClicked: (id)sender {
    [self hideWithDone:NO];
}

#pragma mark - UI life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureDateTimePickerView];
}

#pragma mark - Private interface implementation
- (void)configureDateTimePickerView {
    self.dateTimePicker.minimumDate = self.startDate;
    self.dateTimePicker.maximumDate = self.endDate;
    self.dateTimePicker.minuteInterval = 5;
    self.dateTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.dateTimePicker setDate: self.selectedDate animated: YES];
}

@end
