//
//  HSCalendarViewController.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 20.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSCalendar;

@interface HSCalendarViewController : UIViewController

@property (nonatomic, strong) HSCalendar *calendarModel;

/**
 * Calendar month label.
 */
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

/**
 * Calendar image view.
 */
@property (weak, nonatomic) IBOutlet UIImageView *calendarImageView;

/**
 * Moves calendar view to the next month.
 */
- (IBAction)moveToNextMonth:(id)sender;

/**
 * Moves calendar view to the previous month.
 */
- (IBAction)moveToPreviousMonth:(id)sender;

@end
