//
//  STabBarController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 13.07.12.
//  Modified by Sergey Seroshtan 21.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "STabBarController.h"
#import "HSTabBarView.h"

#import "UIView+HSLayoutManager.h"

@interface STabBarController ()

@property (nonatomic, weak) UITabBarController *tabBarController;
@property (nonatomic, strong) HSTabBarView *customTabBarView;

@end

@implementation STabBarController

- (id)initWithNativeTabBarController:(UITabBarController *)tabBarController {
    THROW_IF_ARGUMENT_NIL(tabBarController);
    if (self = [super init]) {        
        self.tabBarController = tabBarController;
        self.tabBarController.moreNavigationController.navigationBar.hidden = YES;

        self.customTabBarView = [[HSTabBarView alloc] init];
        [self.customTabBarView.calendarButton addTarget:self action:@selector(tabButtonClick:)
                forControlEvents:UIControlEventTouchUpInside];
        [self.customTabBarView.stationsButton addTarget:self action:@selector(tabButtonClick:)
                forControlEvents:UIControlEventTouchUpInside];
        [self.customTabBarView.infoButton addTarget:self action:@selector(tabButtonClick:)
                forControlEvents:UIControlEventTouchUpInside];
        [self.customTabBarView.profileButton addTarget:self action:@selector(tabButtonClick:)
                forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarController.view addSubview:self.customTabBarView];
                
        [self.tabBarController addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew
                                   context:nil];
        
        
    }
    return self;
}

#pragma mark - KVO observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change
        context:(void *)context {
    (void)change;
    (void)context;
    if (object == self.tabBarController && [keyPath isEqualToString:@"selectedIndex"]) {
        [self.customTabBarView selectTab:self.tabBarController.selectedIndex];
    }
}

#pragma mark - Public API
- (IBAction)tabButtonClick:(id)sender {
    UIButton *tappedButton = (UIButton *)sender;
    if (self.tabBarController.selectedIndex != tappedButton.tag) {
        self.tabBarController.selectedIndex = tappedButton.tag;
    }
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    const CGFloat animationDuraton = animated ? 0.3f : 0.0f;
    [UIView animateWithDuration:animationDuraton animations:^{
        if (hidden) {
            [self hideTabBar];
        } else {
            [self showTabBar];
        }
    }];
}

- (void)showTabBar {
    if (!self.tabBarController.tabBar.hidden) {
        return;
    }
    UIView *tabBar = nil;
    UIView *customTabBar = nil;
    UIView *contentView = nil;
    for (UIView *view in self.tabBarController.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            tabBar = view;
        } else if ([view isKindOfClass:[HSTabBarView class]]) {
            customTabBar = view;
        } else {
            contentView = view;
        }
    }
    if (tabBar == nil || customTabBar == nil || contentView == nil) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                reason:@"TabBar should contain three subviews: content, default bar, custom bar" userInfo:nil];
    }
    NSUInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    [tabBar moveFrameY:screenHeight - tabBar.bounds.size.height];
    [customTabBar moveFrameY:screenHeight - customTabBar.bounds.size.height];
    [contentView changeFrameHeight:contentView.bounds.size.height - customTabBar.bounds.size.height];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden) {
        return;
    }
    UIView *tabBar = nil;
    UIView *customTabBar = nil;
    UIView *contentView = nil;
    for (UIView *view in self.tabBarController.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            tabBar = view;
        } else if ([view isKindOfClass:[HSTabBarView class]]) {
            customTabBar = view;
        } else {
            contentView = view;
        }
    }
    if (tabBar == nil || customTabBar == nil || contentView == nil) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                reason:@"TabBar should contain three subviews: content, default bar, custom bar" userInfo:nil];
    }
    NSUInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    [tabBar moveFrameY:screenHeight];
    [customTabBar moveFrameY:screenHeight];
    [contentView changeFrameHeight:contentView.bounds.size.height + customTabBar.bounds.size.height];
    self.tabBarController.tabBar.hidden = YES;
}

@end
