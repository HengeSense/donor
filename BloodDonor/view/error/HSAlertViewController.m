//
//  HSAlertViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 11.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSAlertViewController.h"
#import "NSString+HSAlertViewController.h"

static NSString * const kSingleCancelButtonTitleDefault = @"Продолжить";

@interface HSAlertViewController ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *okButtonTitle;
@property (nonatomic, strong) NSString *cancelButtonTitle;

/**
 * Window for alert displaing.
 */
@property (nonatomic, strong) UIWindow *overlayWindow;

/**
 * Stores old window object before alert showing, to make possible to return key focus to it,
 *     when alert window will be dissmised.
 */
@property (nonatomic, strong) UIWindow *oldWindow;

@property (nonatomic, copy) HSAlertViewControllerResultBlock resultBlock;

/**
 * Shows alert in an overlayed window.
 */
- (void)showAlert;

/**
 * Hides alert and returns focus to previous window.
 */
- (void)hideAlert;

/**
 * Sets text to the label. If text is nil or empty correspond label will be hidden, otherwise shown.
 */
- (void)setLabel:(UILabel *)label withText:(NSString *)text;

/**
 * Sets text to the button. If text is nil or empty correspond button will be hidden, otherwise shown.
 */
- (void)setButton:(UIButton *)button withText:(NSString *)text;


@end

@implementation HSAlertViewController

#pragma mark - Public static interface
+ (void)showWithMessage:(NSString *)message {
    THROW_IF_ARGUMENT_NIL(message, @"message is not specified");
    [self _showWithTitle:@"" message:message cancelButtonTitle:kSingleCancelButtonTitleDefault okButtonTitle:@""
             resultBlock:nil];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message {
    THROW_IF_ARGUMENT_NIL(title, @"title is not specified");
    THROW_IF_ARGUMENT_NIL(message, @"message is not specified");
    [self _showWithTitle:title message:message cancelButtonTitle:kSingleCancelButtonTitleDefault okButtonTitle:@""
             resultBlock:nil];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
    THROW_IF_ARGUMENT_NIL(title, @"title is not specified");
    THROW_IF_ARGUMENT_NIL(message, @"message is not specified");
    THROW_IF_ARGUMENT_NIL(cancelButtonTitle, @"cancelButtonTitle is not specified");

    [self _showWithTitle:@"" message:message cancelButtonTitle:cancelButtonTitle okButtonTitle:@""
             resultBlock:nil];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
        okButtonTitle:(NSString  *)okButtonTitle {
    THROW_IF_ARGUMENT_NIL(title, @"title is not specified");
    THROW_IF_ARGUMENT_NIL(message, @"message is not specified");
    THROW_IF_ARGUMENT_NIL(cancelButtonTitle, @"cancelButtonTitle is not specified");
    THROW_IF_ARGUMENT_NIL(okButtonTitle, @"okButtonTitle is not specified");

    [self _showWithTitle:@"" message:message cancelButtonTitle:cancelButtonTitle okButtonTitle:okButtonTitle
             resultBlock:nil];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
        okButtonTitle:(NSString  *)okButtonTitle resultBlock:(HSAlertViewControllerResultBlock)resultBlock {
    THROW_IF_ARGUMENT_NIL(title, @"title is not specified");
    THROW_IF_ARGUMENT_NIL(message, @"message is not specified");
    THROW_IF_ARGUMENT_NIL(cancelButtonTitle, @"cancelButtonTitle is not specified");
    THROW_IF_ARGUMENT_NIL(okButtonTitle, @"okButtonTitle is not specified");
    THROW_IF_ARGUMENT_NIL(resultBlock, @"resultBlock is not specified");

    [self _showWithTitle:title message:message cancelButtonTitle:cancelButtonTitle okButtonTitle:okButtonTitle
             resultBlock:resultBlock];
}

#pragma mark - Public interface
- (IBAction)okButtonClick:(id)sender {
    [self hideAlert];
    if (self.resultBlock != nil) {
        const BOOL okButtonPressed = YES;
        self.resultBlock(okButtonPressed);
    }
}

- (IBAction)cancelButtonClick:(id)sender {
    [self hideAlert];
    if (self.resultBlock != nil) {
        const BOOL okButtonPressed = NO;
        self.resultBlock(okButtonPressed);
    }
}

#pragma mark - Lifecycle
- (void)hideAllElements {
    self.titleLabel.hidden = YES;
    self.messageWithoutTitleLabel.hidden = YES;
    self.messageWithTitleLabel.hidden = YES;
    self.singleCancelButton.hidden = YES;
    self.okButton.hidden = YES;
    self.cancelButton.hidden = YES;
}
- (void)configureUI {
    [self hideAllElements];
    
    if ([self.title isNotEmpty]) {
        [self setLabel:self.titleLabel withText:self.self.title];
        [self setLabel:self.messageWithTitleLabel withText:self.message];
    } else if ([self.message isNotEmpty]) {
        [self setLabel:self.messageWithoutTitleLabel withText:self.message];
    }
    
    if ([self.okButtonTitle isNotEmpty]) {
        [self setButton:self.okButton withText:self.okButtonTitle];
        [self setButton:self.cancelButton withText:self.cancelButtonTitle];
    } else if ([self.cancelButtonTitle isNotEmpty]) {
        [self setButton:self.singleCancelButton withText:self.cancelButtonTitle];
    } else {
        [self setButton:self.singleCancelButton withText:kSingleCancelButtonTitleDefault];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

#pragma mark - Private static interface
+ (void)_showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
        okButtonTitle:(NSString  *)okButtonTitle resultBlock:(HSAlertViewControllerResultBlock)resultBlock {
    HSAlertViewController *alertViewController =
            [[HSAlertViewController alloc] initWithNibName:@"HSAlertViewController" bundle:nil];
    
    alertViewController.title = title;
    alertViewController.message = message;
    alertViewController.okButtonTitle = okButtonTitle;
    alertViewController.cancelButtonTitle = cancelButtonTitle;
    alertViewController.resultBlock = resultBlock;
    [alertViewController showAlert];
}

#pragma mark - Private interface
- (void)showAlert {
    self.oldWindow = [[UIApplication sharedApplication] keyWindow];
    
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
    self.overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayWindow.windowLevel = UIWindowLevelAlert;
    self.overlayWindow.alpha = 0.0f;
    self.overlayWindow.backgroundColor = [UIColor clearColor];
    self.overlayWindow.rootViewController = self;
    [self.overlayWindow makeKeyAndVisible];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.overlayWindow.alpha = 1.0f;
    }];
}

- (void)hideAlert {
    self.overlayWindow.rootViewController = nil;
    self.overlayWindow = nil;
    [self.oldWindow makeKeyWindow];
}

- (void)setLabel:(UILabel *)label withText:(NSString *)text {
    if ([text isNotEmpty]) {
        label.hidden = NO;
        label.text = text;
    } else {
        label.hidden = YES;
    }
}

- (void)setButton:(UIButton *)button withText:(NSString *)text {
    if ([text isNotEmpty]) {
        button.hidden = NO;
        [button setTitle:text forState:UIControlStateNormal];
    } else {
        button.hidden = YES;
    }
}

@end
