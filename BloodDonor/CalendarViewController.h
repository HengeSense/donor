//
//  CalendarViewController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 13.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBoxViewController.h"

@interface CalendarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MessageBoxDelegate>
{
    UIView *indicatorView;
    int currentDay;
    
    NSDate *selectedDate;
    NSMutableDictionary *holidays;
    NSMutableArray *completedArray;
    NSMutableArray *availableArray;
    NSMutableArray *planningArray;
    
    IBOutlet UILabel *monthLabel;
    IBOutlet UIView *sliderView;
    IBOutlet UILabel *sliderMonthLabel;
    IBOutlet UITableView *sliderTableView;
}

- (IBAction)previousMonthButtonClick:(id)sender;
- (IBAction)nextMonthButtonClick:(id)sender;
- (void)infoButtonClick:(id)sender;

- (IBAction)singleTapSlider:(UITapGestureRecognizer *)gestureRecognizer;
- (IBAction)panGestureMoveAround:(UIPanGestureRecognizer *)gesture;

- (IBAction)dayClick:(id)sender;

@end
