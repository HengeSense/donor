//
//  TutorialViewController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 06.09.12.
//
//

#import <UIKit/UIKit.h>
#import "PageControl.h"

@interface TutorialViewController : UIViewController <UIScrollViewDelegate, PageControlDelegate>
{
    IBOutlet UIButton *doneButton;
    IBOutlet UIScrollView *scrollView;
    PageControl *pageControl;
    //IBOutlet UIPageControl *pageControl;
    NSMutableArray *imageArray;
    BOOL pageControlUsed;
}

- (IBAction)doneButtonClick:(id)sender;
- (IBAction)changePage:(id)sender;

@end
