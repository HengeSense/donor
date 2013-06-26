//
//  HSLoginChoiceViewController.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 09.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSLoginViewController.h"

@interface HSLoginChoiceViewController : HSLoginViewController

- (IBAction)baseAuthorizationSelected:(id)sender;
- (IBAction)facebookAuthenticationSelected:(id)sender;
- (IBAction)registrationSelected:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *baseAuthorizationButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookAuthorizationButton;
@property (weak, nonatomic) IBOutlet UIButton *registrationButton;
@end