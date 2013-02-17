//
//  SNavigationController.m
//  CentroIOS
//
//  Created by Vladimir Noskov on 21.08.12.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import "SNavigationController.h"

@implementation SNavigationController

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.navigationBarBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
        self.navigationBarBackground.image = [UIImage imageNamed:@"navigationBar"];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backButton.frame = CGRectMake(7.0f, 5.0f, 75.0f, 30.0f);
        [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.backButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        self.backButton.hidden = YES;
        [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.titleButton.frame = CGRectMake(75.0f, 5.0f, 170.0f, 30.0f);
        [self.titleButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [self.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        self.titleButton.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleButton.hidden = YES;
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton.frame = CGRectMake(253.0f, 5.0f, 75.0f, 30.0f);
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.rightButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        self.rightButton.hidden = YES;
    }
    return self;
}

- (void)setBackButtonTitle:(NSString *)title type:(int)type
{
    self.backButton.hidden = NO;
    
    [self.backButton setTitle:title forState:UIControlStateNormal];
    [self.backButton setTitle:title forState:UIControlStateHighlighted];
    
    if (type == BACK_BUTTON_TYPE_BACK)
    {
        [self.backButton setBackgroundImage:[UIImage imageNamed:@"backButtonNormal"] forState:UIControlStateNormal];
        [self.backButton setBackgroundImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.backButton setBackgroundImage:[UIImage imageNamed:@"barButtonNormal"] forState:UIControlStateNormal];
        [self.backButton setBackgroundImage:[UIImage imageNamed:@"barButtonPressed"] forState:UIControlStateHighlighted];
    }
}

- (void)setRightButtonTitle:(NSObject *)object selector:(SEL)selector
{
    self.rightButton.hidden = NO;
    
    if ([object isKindOfClass:[NSArray class]])
    {
        [self.rightButton setImage:[UIImage imageNamed:[(NSArray *)object objectAtIndex:0]] forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:[(NSArray *)object objectAtIndex:1]] forState:UIControlStateHighlighted];
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        [self.rightButton setTitle:(NSString *)object forState:UIControlStateNormal];
        [self.rightButton setTitle:(NSString *)object forState:UIControlStateHighlighted];
        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"barButtonNormal"] forState:UIControlStateNormal];
        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"barButtonPressed"] forState:UIControlStateHighlighted];
    }
    
    [self.rightButton addTarget:self.viewController action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTitleButtonTitle:(NSObject *)object selector:(SEL)selector
{
    self.titleButton.hidden = NO;
    
    if ([object isKindOfClass:[NSArray class]])
    {
        [self.titleButton setImage:[UIImage imageNamed:[(NSArray *)object objectAtIndex:0]] forState:UIControlStateNormal];
        [self.titleButton setImage:[UIImage imageNamed:[(NSArray *)object objectAtIndex:1]] forState:UIControlStateHighlighted];
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        [self.titleButton setTitle:(NSString *)object forState:UIControlStateNormal];
        [self.titleButton setTitle:(NSString *)object forState:UIControlStateHighlighted];
    }
    
    if (selector)
        [self.titleButton addTarget:self.viewController action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)addSubviews
{
    [self.viewController.view addSubview:self.navigationBarBackground];
    [self.viewController.view addSubview:self.backButton];
    [self.viewController.view addSubview:self.titleButton];
    [self.viewController.view addSubview:self.rightButton];
}

- (void)removeSubviews
{
    [self.backButton removeFromSuperview];
    [self.titleButton removeFromSuperview];
    [self.rightButton removeFromSuperview];
    [self.navigationBarBackground removeFromSuperview];
}

- (void)backButtonClick:(id)sender
{
    [self popViewControllerAnimated:YES];
}

- (void)popViewControllerAnimated:(BOOL)animated
{
    NSArray *viewControllers = self.viewController.navigationController.viewControllers;
    if (viewControllers.count > 1)
    {
        UIViewController *previousViewController = [viewControllers objectAtIndex:viewControllers.count - 2];
        CGRect previousFrame = previousViewController.view.frame;
        previousFrame.origin.x = 320;
        previousViewController.view.frame = previousFrame;
        //[self.viewController.view addSubview:previousViewController.view];
        [self.viewController.navigationController.view addSubview:previousViewController.view];
        previousFrame.origin.x = 0;
        
        float animationDuration = 1.0f;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        previousViewController.view.frame = previousFrame;
        
        [UIView commitAnimations];
    }
}

@end
