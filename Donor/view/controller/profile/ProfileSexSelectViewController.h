//
//  ProfileSexSelectViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 18.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSModalViewController.h"

@protocol ISexListener <NSObject>

- (void) sexChanged:(NSString *)selectedSex; 

@end

@interface ProfileSexSelectViewController : HSModalViewController
{
    IBOutlet UIButton *maleButton;
    IBOutlet UIButton *femaleButton;
    IBOutlet UILabel *maleLabel;
    IBOutlet UILabel *femaleLabel;
    
    NSString *sex;
}

@property(assign, nonatomic) id delegate;

- (IBAction)cancelClick:(id)sender;
- (IBAction)doneClick:(id)sender;
- (IBAction)sexSelected:(id)sender;

- (void)setSelectedSexButton:(UIButton *)button;

@end
