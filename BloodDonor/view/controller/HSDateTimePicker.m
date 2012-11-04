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
 * Configures date and time picker view with specified restrictions.
 */
- (void)configureDateTimePickerView;

@end

@implementation HSDateTimePicker

#pragma mark - Public interface implementation
- (void)showInView: (UIView *)containerView startDate: (NSDate *)startDate endDate: (NSDate *)endDate
        currentDate:(NSDate *)currentDate completion: (void (^)(BOOL))completion {
    THROW_IF_ARGUMENT_NIL(containerView, @"containerView is not specified");
    THROW_IF_ARGUMENT_NIL(startDate, @"startDate is not specified");
    THROW_IF_ARGUMENT_NIL(currentDate, @"currentDate is not specified");
    THROW_IF_ARGUMENT_NIL(endDate, @"endDate is not specified");
    
    self.startDate = startDate;
    self.endDate = endDate;
    self.completion = completion;
    self.selectedDate = currentDate;

    [self showViewInView: containerView];
}


#pragma mark - Public actions implemntations
- (IBAction)doneButtonClicked: (id)sender {
    self.selectedDate = self.dateTimePicker.date;
    [self hideViewWithResult: YES];
}

- (IBAction)cancelButtonClicked: (id)sender {
    [self hideViewWithResult: NO];
}

#pragma mark - UI life cycle
- (void)viewDidUnload {
    [self setDateTimePicker:nil];
    [self setDateTimePicker:nil];
    [super viewDidUnload];
}

#pragma mark - Private interface implementation

- (void)showViewInView: (UIView *)containerView {
    [UIView animateWithDuration: kShowHideAnimationDuration animations: ^{
        [containerView addSubview: self.view];
        self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    } completion: ^(BOOL finished) {
        [self configureDateTimePickerView];
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

- (void)configureDateTimePickerView {
    self.dateTimePicker.minimumDate = self.startDate;
    self.dateTimePicker.maximumDate = self.endDate;
    self.dateTimePicker.minuteInterval = 5;
    self.dateTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.dateTimePicker setDate: self.selectedDate animated: YES];
}

@end
