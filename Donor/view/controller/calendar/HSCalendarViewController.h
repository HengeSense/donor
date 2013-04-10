//
//  HSCalendarViewController.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 20.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSCalendarEventNotificationHandler.h"

@interface HSCalendarViewController : UIViewController <HSCalendarEventNotificationHandler>

/**
 * Calendar month label.
 */
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

/**
 * Calendar image view.
 */
@property (weak, nonatomic) IBOutlet UIImageView *calendarImageView;

/**
 * View for displaying event planned for today.
 */
@property (weak, nonatomic) IBOutlet UIScrollView *todayEventsScrollView;

/**
 * Moves calendar view to the next month.
 */
- (IBAction)moveToNextMonth:(id)sender;

/**
 * Moves calendar view to the previous month.
 */
- (IBAction)moveToPreviousMonth:(id)sender;

@end
