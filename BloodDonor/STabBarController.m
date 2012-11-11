//
//  STabBarController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 13.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "STabBarController.h"

@interface STabBarController ()

@end

@implementation STabBarController
@synthesize tabBarController;
- (id)init
{
    self = [super init];
    
    if (self)
    {
        tabBarBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 425, 320, 55)];
        tabBarBackground.image = [UIImage imageNamed:@"tabBarBackground"];
        
        calendarButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        calendarButton.frame = CGRectMake(0, 425, 101, 52);
        [calendarButton addTarget:self
                         action:@selector(tabButtonClick:)
               forControlEvents:UIControlEventTouchUpInside];
        [calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarNormal"] forState:UIControlStateNormal];
        [calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarNormal"] forState:UIControlStateHighlighted];
        calendarButton.tag = 0;
        
        stationsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        stationsButton.frame = CGRectMake(54, 425, 118, 52);
        [stationsButton addTarget:self
                           action:@selector(tabButtonClick:)
                 forControlEvents:UIControlEventTouchUpInside];
        [stationsButton setImage:[UIImage imageNamed:@"tabBarStationsNormal"] forState:UIControlStateNormal];
        [stationsButton setImage:[UIImage imageNamed:@"tabBarStationsNormal"] forState:UIControlStateHighlighted];
        stationsButton.tag = 1;
        
        infoButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        infoButton.frame = CGRectMake(137, 425, 118, 52);
        [infoButton addTarget:self
                           action:@selector(tabButtonClick:)
                 forControlEvents:UIControlEventTouchUpInside];
        [infoButton setImage:[UIImage imageNamed:@"tabBarInfoNormal"] forState:UIControlStateNormal];
        [infoButton setImage:[UIImage imageNamed:@"tabBarInfoNormal"] forState:UIControlStateHighlighted];
        infoButton.tag = 2;
        
        profileButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        profileButton.frame = CGRectMake(216, 425, 104, 52);
        [profileButton addTarget:self
                           action:@selector(tabButtonClick:)
                 forControlEvents:UIControlEventTouchUpInside];
        [profileButton setImage:[UIImage imageNamed:@"tabBarProfileNormal"] forState:UIControlStateNormal];
        [profileButton setImage:[UIImage imageNamed:@"tabBarProfileNormal"] forState:UIControlStateHighlighted];
        profileButton.tag = 3;
    }
    
    return self;
}

- (void)addSubview
{
    [self.tabBarController.view addSubview:tabBarBackground];
    [self.tabBarController.view addSubview:calendarButton];
    [self.tabBarController.view addSubview:stationsButton];
    [self.tabBarController.view addSubview:infoButton];
    [self.tabBarController.view addSubview:profileButton];
}

- (void)removeSubviews
{
    [tabBarBackground removeFromSuperview];
    [calendarButton removeFromSuperview];
    [stationsButton removeFromSuperview];
    [infoButton removeFromSuperview];
    [profileButton removeFromSuperview];
}

- (IBAction)tabButtonClick:(id)sender;
{
    UIButton *tabButton = (UIButton *)sender;
    if (self.tabBarController.selectedIndex != tabButton.tag)
    {
        //[self removeSubviews];
        self.tabBarController.selectedIndex = tabButton.tag;
        [self selectTab];
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
