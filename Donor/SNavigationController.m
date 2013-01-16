//
//  SNavigationController.m
//  CentroIOS
//
//  Created by Vladimir Noskov on 21.08.12.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import "SNavigationController.h"

@implementation SNavigationController

@synthesize viewController;

- (void)dealloc
{
    [navigationBarBackground release];
    [backButton release];
    [rightButton release];
    [titleButton release];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        navigationBarBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
        navigationBarBackground.image = [UIImage imageNamed:@"navigationBar"];
        
        backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        backButton.frame = CGRectMake(7.0f, 5.0f, 75.0f, 30.0f);
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [backButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        backButton.hidden = YES;
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        titleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        titleButton.frame = CGRectMake(75.0f, 5.0f, 170.0f, 30.0f);
        [titleButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        titleButton.titleLabel.textAlignment = UITextAlignmentCenter;
        titleButton.hidden = YES;
        
        rightButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        rightButton.frame = CGRectMake(253.0f, 5.0f, 75.0f, 30.0f);
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [rightButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        rightButton.hidden = YES;
    }
    return self;
}

- (void)setBackButtonTitle:(NSString *)title type:(int)type
{
    backButton.hidden = NO;
    
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setTitle:title forState:UIControlStateHighlighted];
    
    if (type == BACK_BUTTON_TYPE_BACK)
    {
        [backButton setBackgroundImage:[UIImage imageNamed:@"backButtonNormal"] forState:UIControlStateNormal];
        [backButton setBackgroundImage:[UIImage imageNamed:@"backButtonPressed"] forState:UIControlStateHighlighted];
    }
    else
    {
        [backButton setBackgroundImage:[UIImage imageNamed:@"barButtonNormal"] forState:UIControlStateNormal];
        [backButton setBackgroundImage:[UIImage imageNamed:@"barButtonPressed"] forState:UIControlStateHighlighted];
    }
}

- (void)setRightButtonTitle:(NSObject *)object selector:(SEL)selector
{
    rightButton.hidden = NO;
    
    if ([object isKindOfClass:[NSArray class]])
    {
        [rightButton setImage:[UIImage imageNamed:[(NSArray *)object objectAtIndex:0]] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:[(NSArray *)object objectAtIndex:1]] forState:UIControlStateHighlighted];
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        [rightButton setTitle:(NSString *)object forState:UIControlStateNormal];
        [rightButton setTitle:(NSString *)object forState:UIControlStateHighlighted];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"barButtonNormal"] forState:UIControlStateNormal];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"barButtonPressed"] forState:UIControlStateHighlighted];
    }
    
    [rightButton addTarget:viewController action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTitleButtonTitle:(NSObject *)object selector:(SEL)selector
{
    titleButton.hidden = NO;
    
    if ([object isKindOfClass:[NSArray class]])
    {
        [titleButton setImage:[UIImage imageNamed:[(NSArray *)object objectAtIndex:0]] forState:UIControlStateNormal];
        [titleButton setImage:[UIImage imageNamed:[(NSArray *)object objectAtIndex:1]] forState:UIControlStateHighlighted];
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        [titleButton setTitle:(NSString *)object forState:UIControlStateNormal];
        [titleButton setTitle:(NSString *)object forState:UIControlStateHighlighted];
    }
    
    if (selector)
        [titleButton addTarget:viewController action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)addSubviews
{
    [self.viewController.view addSubview:navigationBarBackground];
    [self.viewController.view addSubview:backButton];
    [self.viewController.view addSubview:titleButton];
    [self.viewController.view addSubview:rightButton];
}

- (void)removeSubviews
{
    [backButton removeFromSuperview];
    [titleButton removeFromSuperview];
    [rightButton removeFromSuperview];
    [navigationBarBackground removeFromSuperview];
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
