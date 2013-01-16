//
//  STabBarController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 13.07.12.
//  Modified by Sergey Seroshtan 21.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "STabBarController.h"

@interface STabBarController () {
    UIImageView *tabBarBackground;
    UIButton *calendarButton;
    UIButton *stationsButton;
    UIButton *infoButton;
    UIButton *profileButton;
}
@property (nonatomic, assign) UITabBarController *tabBarController;
@end

@implementation STabBarController
@synthesize tabBarController = _tabBarController;

- (id)initWithNativeTabBarController:(UITabBarController *)tabBarController {
    THROW_IF_ARGUMENT_NIL(tabBarController, @"tabBarController is not defined");
    if (self = [super init]) {
        self.tabBarController = tabBarController;
        
        tabBarBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 425, 320, 55)];
        tabBarBackground.image = [UIImage imageNamed:@"tabBarBackground"];
        [self.tabBarController.view addSubview:tabBarBackground];

        calendarButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        calendarButton.frame = CGRectMake(0, 425, 101, 52);
        [calendarButton addTarget:self
                         action:@selector(tabButtonClick:)
               forControlEvents:UIControlEventTouchUpInside];
        [calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarNormal"] forState:UIControlStateNormal];
        [calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarNormal"] forState:UIControlStateHighlighted];
        calendarButton.tag = 0;
        [self.tabBarController.view addSubview:calendarButton];

        
        stationsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        stationsButton.frame = CGRectMake(54, 425, 118, 52);
        [stationsButton addTarget:self
                           action:@selector(tabButtonClick:)
                 forControlEvents:UIControlEventTouchUpInside];
        [stationsButton setImage:[UIImage imageNamed:@"tabBarStationsNormal"] forState:UIControlStateNormal];
        [stationsButton setImage:[UIImage imageNamed:@"tabBarStationsNormal"] forState:UIControlStateHighlighted];
        stationsButton.tag = 1;
        [self.tabBarController.view addSubview:stationsButton];
        
        infoButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        infoButton.frame = CGRectMake(137, 425, 118, 52);
        [infoButton addTarget:self
                           action:@selector(tabButtonClick:)
                 forControlEvents:UIControlEventTouchUpInside];
        [infoButton setImage:[UIImage imageNamed:@"tabBarInfoNormal"] forState:UIControlStateNormal];
        [infoButton setImage:[UIImage imageNamed:@"tabBarInfoNormal"] forState:UIControlStateHighlighted];
        infoButton.tag = 2;
        [self.tabBarController.view addSubview:infoButton];

        
        profileButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        profileButton.frame = CGRectMake(216, 425, 104, 52);
        [profileButton addTarget:self
                           action:@selector(tabButtonClick:)
                 forControlEvents:UIControlEventTouchUpInside];
        [profileButton setImage:[UIImage imageNamed:@"tabBarProfileNormal"] forState:UIControlStateNormal];
        [profileButton setImage:[UIImage imageNamed:@"tabBarProfileNormal"] forState:UIControlStateHighlighted];
        profileButton.tag = 3;
        [self.tabBarController.view addSubview:profileButton];
        
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
    
    [calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarNormal"] forState:UIControlStateNormal];
    [calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarNormal"] forState:UIControlStateHighlighted];
    [stationsButton setImage:[UIImage imageNamed:@"tabBarStationsNormal"] forState:UIControlStateNormal];
    [stationsButton setImage:[UIImage imageNamed:@"tabBarStationsNormal"] forState:UIControlStateHighlighted];
    [infoButton setImage:[UIImage imageNamed:@"tabBarInfoNormal"] forState:UIControlStateNormal];
    [infoButton setImage:[UIImage imageNamed:@"tabBarInfoNormal"] forState:UIControlStateHighlighted];
    [profileButton setImage:[UIImage imageNamed:@"tabBarProfileNormal"] forState:UIControlStateNormal];
    [profileButton setImage:[UIImage imageNamed:@"tabBarProfileNormal"] forState:UIControlStateHighlighted];
    
    switch (selectedIndex)
    {
        case 0:
            [calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarSelected"] forState:UIControlStateNormal];
            [calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarSelected"] forState:UIControlStateHighlighted];
            break;
            
        case 1:
            [stationsButton setImage:[UIImage imageNamed:@"tabBarStationsSelected"] forState:UIControlStateNormal];
            [stationsButton setImage:[UIImage imageNamed:@"tabBarStationsSelected"] forState:UIControlStateHighlighted];
            break;
            
        case 2:
            [infoButton setImage:[UIImage imageNamed:@"tabBarInfoSelected"] forState:UIControlStateNormal];
            [infoButton setImage:[UIImage imageNamed:@"tabBarInfoSelected"] forState:UIControlStateHighlighted];
            break;
            
        case 3:
            [profileButton setImage:[UIImage imageNamed:@"tabBarProfileSelected"] forState:UIControlStateNormal];
            [profileButton setImage:[UIImage imageNamed:@"tabBarProfileSelected"] forState:UIControlStateHighlighted];
            break;
            
        default:
            [calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarSelected"] forState:UIControlStateNormal];
            [calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarSelected"] forState:UIControlStateHighlighted];
            break;
    }
}

- (void)dealloc
{
    [tabBarBackground release];
    [calendarButton release];
    [stationsButton release];
    [infoButton release];
    [profileButton release];
    
    [super dealloc];
}

@end
