//
//  InfoViewController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Updated by Sergey Seroshtan on 17.01.13
//  Copyright (c) 2012 HintSolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *adsButton;
@property (nonatomic, weak) IBOutlet UIButton *newsButton;
@property (nonatomic, weak) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIImageView *topTabBarView;

- (IBAction)showAdsView:(id)sender;
- (IBAction)showNewsView:(id)sender;
- (IBAction)showInfoView:(id)sender;

@end
