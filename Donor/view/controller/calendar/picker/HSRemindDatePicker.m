//
//  HSRemindDatePicker.m
//  Donor
//
//  Created by Sergey Seroshtan on 20.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSRemindDatePicker.h"

// Defines maximum value for remind time interval (2 days);
static const NSTimeInterval kRemindTimeIntervalMax = 48.0 * 60.0 * 60.0;

enum {
    kReminderTimeShiftsCount = 9
};
static NSArray *gReminderTitles;
static NSTimeInterval gReminderTimeShifts[kReminderTimeShiftsCount] =
        {-DBL_MAX, 0.0, (5 * 60.0), (15 * 60.0), (30 * 60.0),
        (60 * 60.0), (2 * 60 * 60.0), (24 * 60 * 60.0), (2 * 24 * 60 * 60.0)};

@interface HSRemindDatePicker () <UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *reminderPicker;

@property (nonatomic, assign) NSTimeInterval reminderTimeShift;
@property (nonatomic, strong) NSString *reminderTimeShiftString;
@property (nonatomic, copy) HSPickerCompletion completion;

@end

@implementation HSRemindDatePicker

#pragma mark - Static
+ (void)initialize {
    gReminderTitles = @[@"Нет", @"В момент события", @"За 5 мин", @"За 15 мин", @"За 30 мин", @"За 1 час",
                                @"За 2 час.", @"За 1 день", @"За 2 дн."];
    if ([gReminderTitles count] != kReminderTimeShiftsCount) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                reason:@"Number of elements in arrays gReminderTimeIntervals and gReminderTitles"
                "should be equal" userInfo:nil];
    }
}

+ (NSTimeInterval)reminderTimeShiftDefault {
    return gReminderTimeShifts[0];
}

+ (NSString *)reminderTimeShiftStringDefault {
    return gReminderTitles[0];
}

+ (NSString *)stringFromReminderTimeShift:(NSTimeInterval)reminderTimeShift {
    return gReminderTitles[[self positionForClosestReminderTimeShift:reminderTimeShift]];
}

+ (NSTimeInterval)closestReminderTimeShift:(NSTimeInterval)reminderTimeShift {
    return gReminderTimeShifts[[self positionForClosestReminderTimeShift:reminderTimeShift]];
}
            
+ (NSUInteger)positionForClosestReminderTimeShift:(NSTimeInterval)reminderTimeShift {
    NSUInteger closestPos = 0;
    for (NSUInteger pos = 1; pos < kReminderTimeShiftsCount; ++pos) {
        double closestDelta = ABS(ABS(reminderTimeShift) - ABS(gReminderTimeShifts[closestPos]));
        double testDelta = ABS(ABS(reminderTimeShift) - ABS(gReminderTimeShifts[pos]));
        if (testDelta < closestDelta) {
            closestPos = pos;
        }
    }
    return closestPos;
}

#pragma mark - Initialization
- (void)showWithInitialReminderTimeInterval:(NSTimeInterval)initialTimeInterval
        completion:(HSPickerCompletion)completion {
    self.reminderTimeShift = [self correctInitialTimeInterval:initialTimeInterval];
    self.completion = completion;
    [self showModal];
}

#pragma mark - Action handlers
- (void)doneButtonClicked:(id)sender {
    NSUInteger keyPos = [self.reminderPicker selectedRowInComponent:0];
    if (keyPos < kReminderTimeShiftsCount) {
        self.reminderTimeShift = gReminderTimeShifts[keyPos];
        self.reminderTimeShiftString = gReminderTitles[keyPos];
    } else {
        NSLog(@"Selected position in %@ is out of bounds of data source.", NSStringFromClass(self.class));
    }
    [self finishWithDone:YES];
}

- (void)cancelButtonClicked:(id)sender {
    [self finishWithDone:NO];
}
#pragma mark - UI life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configurePickerView];
}

#pragma mark - UIPickerViewDataSource protocol implememntation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [gReminderTitles count];
}

#pragma mark - UIPickerViewDelegate protocol implememntation
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return row < [gReminderTitles count] ? gReminderTitles[row] : nil;
}

#pragma mark - Private
#pragma mark - UI configuration
- (void)configurePickerView {
    NSUInteger pos = [HSRemindDatePicker positionForClosestReminderTimeShift:self.reminderTimeShift];
    [self.reminderPicker selectRow:pos inComponent:0 animated:YES];
}


#pragma mark - Utility
- (NSTimeInterval)correctInitialTimeInterval:(NSTimeInterval)initialTimeInerval {
    return MIN(initialTimeInerval, kRemindTimeIntervalMax);
}

- (void)finishWithDone:(BOOL)done {
    [self hideModal];
    if (self.completion != nil) {
        self.completion(done);
    }
}

@end
