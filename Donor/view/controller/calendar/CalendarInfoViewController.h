//
//  CalendarInfoViewController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 15.08.12.
//
//

#import <UIKit/UIKit.h>

@interface CalendarInfoViewController : UIViewController
{
    IBOutlet UIView *contentView;
    IBOutlet UIScrollView *scrollView;
}

- (IBAction)backButtonClick:(id)sender;

@end
