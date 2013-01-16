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
{
    UIImageView *navigationBarBackground;
    UIButton *backButton;
    UIButton *rightButton;
    UIButton *titleButton;
}

@property (nonatomic, assign) UIViewController *viewController;

- (void)addSubviews;
- (void)removeSubviews;

- (void)setBackButtonTitle:(NSString *)title type:(int)type;
- (void)setRightButtonTitle:(NSObject *)object selector:(SEL)selector;
- (void)setTitleButtonTitle:(NSObject *)object selector:(SEL)selector;

- (void)popViewControllerAnimated:(BOOL)animated;

- (void)backButtonClick:(id)sender;

@end
