//
//  HSTabBarView.m
//  Donor
//
//  Created by Sergey Seroshtan on 16.04.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSTabBarView.h"

#import "STabBarController.h"

static const NSUInteger kTabBarHeight = 55;
static const NSUInteger kTabBarButtonHeight = 52;

@interface HSTabBarView ()

@property (nonatomic, weak) STabBarController *customTabBarViewController;

@end

@implementation HSTabBarView

- (id)init {
    NSUInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSUInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self = [super initWithFrame:CGRectMake(0, screenHeight - kTabBarHeight, screenWidth, kTabBarHeight)];
    if (self) {
        self.tabBarBackground = [[UIImageView alloc] initWithFrame:
                CGRectMake(0, 0, screenWidth, kTabBarHeight)];
        self.tabBarBackground.image = [UIImage imageNamed:@"tabBarBackground"];
        self.tabBarBackground.userInteractionEnabled = NO;
        [self addSubview:self.tabBarBackground];
        
        self.calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.calendarButton.frame = CGRectMake(0, 0, 101, kTabBarButtonHeight);
        [self.calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarNormal"] forState:UIControlStateNormal];
        [self.calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarNormal"] forState:UIControlStateHighlighted];
        self.calendarButton.tag = 0;
        [self addSubview:self.calendarButton];
        
        
        self.stationsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.stationsButton.frame = CGRectMake(54, 0, 118, kTabBarButtonHeight);
        [self.stationsButton setImage:[UIImage imageNamed:@"tabBarStationsNormal"] forState:UIControlStateNormal];
        [self.stationsButton setImage:[UIImage imageNamed:@"tabBarStationsNormal"] forState:UIControlStateHighlighted];
        self.stationsButton.tag = 1;
        [self addSubview:self.stationsButton];
        
        self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.infoButton.frame = CGRectMake(137, 0, 118, kTabBarButtonHeight);
        [self.infoButton setImage:[UIImage imageNamed:@"tabBarInfoNormal"] forState:UIControlStateNormal];
        [self.infoButton setImage:[UIImage imageNamed:@"tabBarInfoNormal"] forState:UIControlStateHighlighted];
        self.infoButton.tag = 2;
        [self addSubview:self.infoButton];
        
        
        self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.profileButton.frame = CGRectMake(216, 0, 104, kTabBarButtonHeight);
        [self.profileButton setImage:[UIImage imageNamed:@"tabBarProfileNormal"] forState:UIControlStateNormal];
        [self.profileButton setImage:[UIImage imageNamed:@"tabBarProfileNormal"] forState:UIControlStateHighlighted];
        self.profileButton.tag = 3;
        [self addSubview:self.profileButton];
    }
    return self;
}

- (void)selectTab:(NSUInteger)tabIndex {
    [self.calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarNormal"] forState:UIControlStateNormal];
    [self.calendarButton setImage:[UIImage imageNamed:@"tabBarCalendarNormal"] forState:UIControlStateHighlighted];
    [self.stationsButton setImage:[UIImage imageNamed:@"tabBarStationsNormal"] forState:UIControlStateNormal];
    [self.stationsButton setImage:[UIImage imageNamed:@"tabBarStationsNormal"] forState:UIControlStateHighlighted];
    [self.infoButton setImage:[UIImage imageNamed:@"tabBarInfoNormal"] forState:UIControlStateNormal];
    [self.infoButton setImage:[UIImage imageNamed:@"tabBarInfoNormal"] forState:UIControlStateHighlighted];
    [self.profileButton setImage:[UIImage imageNamed:@"tabBarProfileNormal"] forState:UIControlStateNormal];
    [self.profileButton setImage:[UIImage imageNamed:@"tabBarProfileNormal"] forState:UIControlStateHighlighted];
    
    switch (tabIndex)
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
