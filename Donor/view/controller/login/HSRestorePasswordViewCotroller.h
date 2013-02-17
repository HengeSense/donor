//
//  HSRestorePasswordViewCotroller.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 13.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSRestorePasswordViewCotroller : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *restorePasswordButton;

- (IBAction)restorePassword:(id)sender;
@end
