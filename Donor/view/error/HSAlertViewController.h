//
//  HSAlertViewController.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 11.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HSAlertViewControllerResultBlock)(BOOL isOkButtonPressed);

@interface HSAlertViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageWithTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageWithoutTitleLabel;

@property (nonatomic, weak) IBOutlet UIButton *singleCancelButton;
@property (nonatomic, weak) IBOutlet UIButton *okButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

- (IBAction)okButtonClick:(id)sender;
- (IBAction)cancelButtonClick:(id)sender;

/**
 * Shows error message with specified message text and 'Ok' cancel button.
 */
+ (void)showWithMessage:(NSString *)message;

/**
 * Shows error message with specifed message text, 'Ok' cancel button and finishes with resultBlock.
 */
+ (void)showWithMessage:(NSString *)message resultBlock:(HSAlertViewControllerResultBlock)resultBlock;

/**
 * Shows error message with specified message title and text.
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message;

/**
 * Shows error message with specified message title, text and finishes with resultBlock.
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message
          resultBlock:(HSAlertViewControllerResultBlock)resultBlock;

/**
 * Shows error message with specified message title, text, and cancel button title.
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;

/**
 * Shows error message with specified message title, text, and cancel button title, ok button title.
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
        okButtonTitle:(NSString  *)okButtonTitle;

/**
 * Shows error message with specified message title, text, and cancel button title, ok button title
 *     and result block of code which is called after alert disappearance.
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
        okButtonTitle:(NSString  *)okButtonTitle resultBlock:(HSAlertViewControllerResultBlock)resultBlock;

@end
