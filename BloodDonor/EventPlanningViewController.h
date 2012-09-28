//
//  EventPlanningViewController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 23.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventPlanningViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate>
{
    UIView *indicatorView;
    NSString *eventId;
    
    BOOL isTest;
    int typeDonate;
    int bloodDonateDay;
    int bloodDonateHour;
    int bloodDonateMinute;
    int testDay;
    int testHour;
    int testMinute;
    int eventTimeReminderIndex;
    int year;
    
    NSArray *typeDonateArray;
    NSMutableArray *daysArray;
    NSArray *hoursArray;
    NSArray *minutesArray;
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIView *bloodDonationView;
    IBOutlet UIButton *typeDonateButton;
    IBOutlet UIButton *bloodDonationDateButton;
    IBOutlet UITextView *bloodDonateCommentTextField;
    IBOutlet UIButton *bloodDonateRemoveButton;
    IBOutlet UIButton *bloodDonateLocationButton;
    
    IBOutlet UIView *testView;
    IBOutlet UIButton *timeReminderButton;
    IBOutlet UIButton *knowReminderButton;
    IBOutlet UIButton *testDateButton;
    IBOutlet UITextView *testCommentTextField;
    IBOutlet UIButton *testRemoveButton;
    IBOutlet UIButton *testLocationButton;
    
    IBOutlet UIPickerView *typeDonatePickerView;
    IBOutlet UIView *typeDonateInputView;
    
    IBOutlet UIPickerView *datePickerView;
    IBOutlet UIView *dateInputView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(NSString *)event date:(NSDate *)date;

- (IBAction)cancelClick:(id)sender;
- (IBAction)doneClick:(id)sender;

- (IBAction)eventClick:(id)sender;
- (IBAction)typeDonateClick:(id)sender;
- (IBAction)dateClick:(id)sender;
- (IBAction)locationClick:(id)sender;
- (IBAction)donateReminderClick:(id)sender;
- (IBAction)knowReminderClick:(id)sender;
- (IBAction)removeClick:(id)sender;

- (IBAction)typeDonateCancelClick:(id)sender;
- (IBAction)typeDonateDoneClick:(id)sender;

- (IBAction)dateCancelClick:(id)sender;
- (IBAction)dateDoneClick:(id)sender;

@end
