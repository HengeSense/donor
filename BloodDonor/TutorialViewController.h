//
//  TutorialViewController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 06.09.12.
//
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIButton *doneButton;
    IBOutlet UIScrollView *scrollView;
    NSMutableArray *imageArray;
    BOOL pageControlUsed;
    __weak IBOutlet UIPageControl *pageControl;
}

- (IBAction)doneButtonClick:(id)sender;
- (IBAction)changePage:(id)sender;

@end
