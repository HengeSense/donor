//
//  EventReminderViewController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 02.08.12.
//
//

#import <UIKit/UIKit.h>

@interface EventReminderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    int selectedReminder;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil reminder:(int)indexReminder;

- (IBAction)cancelClick:(id)sender;
- (IBAction)doneClick:(id)sender;

@end
