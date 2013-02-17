//
//  SNavigationController.h
//  CentroIOS
//
//  Created by Vladimir Noskov on 21.08.12.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BACK_BUTTON_TYPE_BACK 0
#define BACK_BUTTON_TYPE_NORMAL 1

@interface SNavigationController : UINavigationController

@property (nonatomic, strong) UIImageView *navigationBarBackground;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *titleButton;

@property (nonatomic, assign) UIViewController *viewController;

- (void)addSubviews;
- (void)removeSubviews;

- (void)setBackButtonTitle:(NSString *)title type:(int)type;
- (void)setRightButtonTitle:(NSObject *)object selector:(SEL)selector;
- (void)setTitleButtonTitle:(NSObject *)object selector:(SEL)selector;

- (void)popViewControllerAnimated:(BOOL)animated;

- (void)backButtonClick:(id)sender;

@end
