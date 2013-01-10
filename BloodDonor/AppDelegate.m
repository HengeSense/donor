//
//  AppDelegate.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "HSFlurryAnalytics.h"

#ifdef NEW_CALENDAR_FUNCTIONALITY_DEVELOPEMENT
#import "HSCalendarViewController.h"
#else
#import "CalendarViewController.h"
#endif

#import "StationsViewController.h"
#import "InfoViewController.h"
#import "HSLoginChoiceViewController.h"
#import "Common.h"
#import "MessageBoxViewController.h"
#import "TutorialViewController.h"

#import "HSCalendar.h"

static NSString * const PARSE_APP_ID = @"EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu";
static NSString * const PARSE_CLIENT_KEY = @"uNarhakSf1on8lJjrAVs1VWmPlG1D6ZJf9dO5QZY";
static NSString * const FACEBOOK_APP_ID = @"438918122827407";
static NSString * const FLURRY_APP_ID = @"2WRYH35MS5SW4ZY2TNPB";
static NSString * const TEST_FLIGHT_APP_ID = @"43651a8fd308e9fd491a1c8aa068f158_MTQxMjA0MjAxMi0xMC0wOSAwOTozMToyMS4zNzU1ODc";

@interface AppDelegate ()

- (void)makeTabBarHidden:(BOOL)hide;
- (void)backButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize sTabBarController;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:PARSE_APP_ID clientKey:PARSE_CLIENT_KEY];
    [PFFacebookUtils initializeWithApplicationId:FACEBOOK_APP_ID];
    [HSFlurryAnalytics initWithAppId:FLURRY_APP_ID];
    [TestFlight takeOff:TEST_FLIGHT_APP_ID];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    UIImage *barImage = [UIImage imageNamed:@"navigationBar"];
    [[UINavigationBar appearance] setBackgroundImage:barImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor,
      [UIColor blackColor], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"Helvetica-Bold" size:15], UITextAttributeFont,
      nil]];
    
    UIImage *backButtonImageNormal = [[UIImage imageNamed:@"backButtonNormal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 23, 6, 16)];
    UIImage *backButtonImagePressed = [[UIImage imageNamed:@"backButtonPressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 23, 6, 16)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImageNormal forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImagePressed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];

#ifdef NEW_CALENDAR_FUNCTIONALITY_DEVELOPEMENT
    HSCalendarViewController *calendarViewController = [[[HSCalendarViewController alloc] initWithNibName:@"HSCalendarViewController" bundle:nil] autorelease];
#else
    CalendarViewController *calendarViewController = [[[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil] autorelease];
#endif
    UINavigationController *calendarNavigationController = [[[UINavigationController alloc] initWithRootViewController:calendarViewController] autorelease];
    
    StationsViewController *stationsViewController = [[[StationsViewController alloc] initWithNibName:@"StationsViewController" bundle:nil] autorelease];
    UINavigationController *stationsNavigationController = [[[UINavigationController alloc] initWithRootViewController:stationsViewController] autorelease];
    
    InfoViewController *infoViewController = [[[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil] autorelease];
    UINavigationController *infoNavigationController = [[[UINavigationController alloc] initWithRootViewController:infoViewController] autorelease];
    
    HSLoginChoiceViewController *loginChoiceViewController = [[[HSLoginChoiceViewController alloc] initWithNibName:@"HSLoginChoiceViewController" bundle:nil] autorelease];
    loginChoiceViewController.calendarViewController = calendarViewController;
    UINavigationController *profileNavigationController = [[[UINavigationController alloc] initWithRootViewController:loginChoiceViewController] autorelease];
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:calendarNavigationController, stationsNavigationController, infoNavigationController, profileNavigationController, nil];
    
    UINavigationController *rootNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.tabBarController] autorelease];
    rootNavigationController.navigationBarHidden = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"isFirstStart"])
    {
        TutorialViewController *tutorialViewController = [[[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil] autorelease];
        [rootNavigationController pushViewController:tutorialViewController animated:NO];
        [defaults setBool:YES forKey:@"isFirstStart"];
    }

    self.sTabBarController = [[STabBarController alloc] initWithNativeTabBarController:self.tabBarController];
    self.tabBarController.selectedIndex = 3;
    
    self.window.rootViewController = rootNavigationController;
    [self makeTabBarHidden:YES];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)backButtonPressed:(UIBarButtonItem *)sender
{
    
}

- (void)makeTabBarHidden:(BOOL)hide
{
    // Custom code to hide TabBar
    if ([self.tabBarController.view.subviews count] < 2)
    {
        return;
    }
    
    UIView *contentView;
    
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
    {
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    }
    else
    {
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    }
    
    if (hide)
    {
        contentView.frame = self.tabBarController.view.bounds;
    }
    else
    {
        contentView.frame = CGRectMake(self.tabBarController.view.bounds.origin.x,
                                       self.tabBarController.view.bounds.origin.y,
                                       self.tabBarController.view.bounds.size.width,
                                       self.tabBarController.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    }
    
    self.tabBarController.tabBar.hidden = hide;
    self.tabBarController.moreNavigationController.navigationBar.hidden = YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self.tabBarController setSelectedIndex:0];
    UINavigationController *navigationController = [self.tabBarController.viewControllers objectAtIndex:0];
    [navigationController popToRootViewControllerAnimated:NO];
#ifdef NEW_CALENDAR_FUNCTIONALITY_DEVELOPEMENT
    HSCalendarViewController *calendarViewController = [[navigationController viewControllers] objectAtIndex:0];
#else
    CalendarViewController *calendarViewController = [[navigationController viewControllers] objectAtIndex:0];
#endif
    
    MessageBoxViewController *messageBox = [[MessageBoxViewController alloc] initWithNibName:@"MessageBoxViewController"
                                                                                      bundle:nil
                                                                                       title:nil
                                                                                     message:notification.alertBody
                                                                                cancelButton:@"Позже"
                                                                                    okButton:@"Ок"];

#ifdef NEW_CALENDAR_FUNCTIONALITY_DEVELOPEMENT
#warning TODO Add this functionality to the HSCalendarViewController view controller.
#else
    messageBox.delegate = calendarViewController;
#endif
    [calendarViewController.navigationController.tabBarController.view addSubview:messageBox.view];
}

- (BOOL)handleOpenURL:(NSURL*)url
{
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleOpenURL:url];
}


@end
