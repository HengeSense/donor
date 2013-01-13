//
//  HSRestorePasswordViewCotroller.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 13.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSRestorePasswordViewCotroller.h"
#import "HSModelCommon.h"
#import "HSAlertViewController.h"
#import "NSString+HSUtils.h"

#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface HSRestorePasswordViewCotroller ()

@end

@implementation HSRestorePasswordViewCotroller

#pragma mark - Lifecycle

- (void)configureUI {
    self.title = @"Восстановление пароля";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}


- (IBAction)restorePassword:(id)sender {
    [self.emailTextField resignFirstResponder];
    if ([self.emailTextField.text isNotEmpty]) {
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [PFUser requestPasswordResetForEmailInBackground:self.emailTextField.text
            block:^(BOOL succeeded, NSError *error) {
                [progressHud hide:YES];
               if (succeeded) {
                   [HSAlertViewController showWithTitle:@" "
                            message:@"Запрос на восстановление пароля успешно отправлен. Проверьте почту."
                    resultBlock:^(BOOL isOkButtonPressed) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
               } else {
                   [HSAlertViewController showWithTitle:@"Ошибка" message:localizedDescriptionForParseError(error)];
               }
        }];
    }
    else {
        [HSAlertViewController showWithTitle:@"Ошибка" message:@"Не указан email"];
    }
}
@end
