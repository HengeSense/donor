//
//  RecommendationsViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 03.08.12.
//
//

#import <UIKit/UIKit.h>

@interface RecommendationsViewController : UIViewController
{
    IBOutlet UIView *canBloodDonateIfView;
    IBOutlet UIView *beforeBloodDonateView;
    IBOutlet UIView *afterBloodDonateView;
    
    IBOutlet UIButton *canBloodDonateIfButton;
    IBOutlet UIButton *beforeBloodDonateButton;
    IBOutlet UIButton *afterBloodDonateButton;
    
    IBOutlet UIScrollView *contentScrollView;
    
    IBOutlet UIScrollView *canBloodDonateIfSubView;
    IBOutlet UIScrollView *beforeBloodDonateSubView;
    IBOutlet UIScrollView *afterBloodDonateSubView;
}

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)spoilerButtonPressed:(id)sender;

@end
