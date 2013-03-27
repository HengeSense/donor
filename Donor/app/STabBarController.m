//
//  STabBarController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 13.07.12.
//  Modified by Sergey Seroshtan 21.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "STabBarController.h"

static const NSUInteger kTabBarHeight = 55;
static const NSUInteger kTabBarButtonHeight = 52;

@interface STabBarController ()

@property (nonatomic, strong) UIImageView *tabBarBackground;
@property (nonatomic, strong) UIButton *calendarButton;
@property (nonatomic, strong) UIButton *stationsButton;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) UIButton *profileButton;

@property (nonatomic, assign) UITabBarController *tabBarController;
@end

@implementation STabBarController
@synthesize tabBarController = _tabBarController;

- (id)initWithNativeTabBarController:(UITabBarController *)tabBarController {
    THROW_IF_ARGUMENT_NIL(tabBarController);
    if (self = [super init]) {
        NSUInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
        NSUInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        self.tabBarController = tabBarController;
        
        self.tabBarBackground =
                [[UIImageView alloc] initWithFrame:CGRectMake(0, screenHeight - kTabBarHeight, screenWidth, kTabBarHeight)];
        self.tabBarBackground.image = [UIImage imageNamed:@"tabBarBackground"];
        [self.tabBarController.view addSubview:self.tabBarBackground];

        self.calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.calendarButton.frame = CGRectMake(0, screenHeight - kTabBarHeight, 101, kTabBarButtonHeight);
        [self.calendarButton addTarget:self
                         action:@selector(tabButtonClick:)
               forControlEvents:UIControlEventTouchUpInside];
        [self.calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarNormal"] forState:UIControlStateNormal];
        [self.calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarNormal"] forState:UIControlStateHighlighted];
        self.calendarButton.tag = 0;
        [self.tabBarController.view addSubview:self.calendarButton];

        
        self.stationsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.stationsButton.frame = CGRectMake(54, screenHeight - kTabBarHeight, 118, kTabBarButtonHeight);
        [self.stationsButton addTarget:self
                           action:@selector(tabButtonClick:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self.stationsButton setImage:[UIImage imageNamed:@"tabBarStationsNormal"] forState:UIControlStateNormal];
        [self.stationsButton setImage:[UIImage imageNamed:@"tabBarStationsNormal"] forState:UIControlStateHighlighted];
        self.stationsButton.tag = 1;
        [self.tabBarController.view addSubview:self.stationsButton];
        
        self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.infoButton.frame = CGRectMake(137, screenHeight - kTabBarHeight, 118, kTabBarButtonHeight);
        [self.infoButton addTarget:self
                           action:@selector(tabButtonClick:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self.infoButton setImage:[UIImage imageNamed:@"tabBarInfoNormal"] forState:UIControlStateNormal];
        [self.infoButton setImage:[UIImage imageNamed:@"tabBarInfoNormal"] forState:UIControlStateHighlighted];
        self.infoButton.tag = 2;
        [self.tabBarController.view addSubview:self.infoButton];

        
        self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.profileButton.frame = CGRectMake(216, screenHeight - kTabBarHeight, 104, kTabBarButtonHeight);
        [self.profileButton addTarget:self
                           action:@selector(tabButtonClick:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self.profileButton setImage:[UIImage imageNamed:@"tabBarProfileNormal"] forState:UIControlStateNormal];
        [self.profileButton setImage:[UIImage imageNamed:@"tabBarProfileNormal"] forState:UIControlStateHighlighted];
        self.profileButton.tag = 3;
        [self.tabBarController.view addSubview:self.profileButton];
        
        [self.tabBarController addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew
                                   context:nil];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    (void)change;
    (void)context;
    if (object == self.tabBarController && [keyPath isEqualToString:@"selectedIndex"]) {
        [self selectTab];
    }
}

- (IBAction)tabButtonClick:(id)sender;
{
    UIButton *tabButton = (UIButton *)sender;
    if (self.tabBarController.selectedIndex != tabButton.tag)
    {
        self.tabBarController.selectedIndex = tabButton.tag;
    }
}

- (void)selectTab
{
    int selectedIndex = self.tabBarController.selectedIndex;
    
    [self.calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarNormal"] forState:UIControlStateNormal];
    [self.calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarNormal"] forState:UIControlStateHighlighted];
    [self.stationsButton setImage:[UIImage imageNamed:@"tabBarStationsNormal"] forState:UIControlStateNormal];
    [self.stationsButton setImage:[UIImage imageNamed:@"tabBarStationsNormal"] forState:UIControlStateHighlighted];
    [self.infoButton setImage:[UIImage imageNamed:@"tabBarInfoNormal"] forState:UIControlStateNormal];
    [self.infoButton setImage:[UIImage imageNamed:@"tabBarInfoNormal"] forState:UIControlStateHighlighted];
    [self.profileButton setImage:[UIImage imageNamed:@"tabBarProfileNormal"] forState:UIControlStateNormal];
    [self.profileButton setImage:[UIImage imageNamed:@"tabBarProfileNormal"] forState:UIControlStateHighlighted];
    
    switch (selectedIndex)
    {
        case 0:
            [self.calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarSelected"] forState:UIControlStateNormal];
            [self.calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarSelected"] forState:UIControlStateHighlighted];
            break;
            
        case 1:
            [self.stationsButton setImage:[UIImage imageNamed:@"tabBarStationsSelected"] forState:UIControlStateNormal];
            [self.stationsButton setImage:[UIImage imageNamed:@"tabBarStationsSelected"] forState:UIControlStateHighlighted];
            break;
            
        case 2:
            [self.infoButton setImage:[UIImage imageNamed:@"tabBarInfoSelected"] forState:UIControlStateNormal];
            [self.infoButton setImage:[UIImage imageNamed:@"tabBarInfoSelected"] forState:UIControlStateHighlighted];
            break;
            
        case 3:
            [self.profileButton setImage:[UIImage imageNamed:@"tabBarProfileSelected"] forState:UIControlStateNormal];
            [self.profileButton setImage:[UIImage imageNamed:@"tabBarProfileSelected"] forState:UIControlStateHighlighted];
            break;
            
        default:
            [self.calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarSelected"] forState:UIControlStateNormal];
            [self.calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarSelected"] forState:UIControlStateHighlighted];
            break;
    }
}

@end
