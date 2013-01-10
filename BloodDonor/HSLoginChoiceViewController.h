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

- (IBAction)basicAuthenticationSelected:(id)sender;
- (IBAction)facebookAuthenticationSelected:(id)sender;
- (IBAction)registrationSelected:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *facebookAuthorizationButton;
@end
