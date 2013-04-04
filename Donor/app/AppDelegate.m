//
//  AppDelegate.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Crittercism.h"
#import <Crashlytics/Crashlytics.h>
#import "TestFlight.h"
#import "Appirater.h"
#import "HSFlurryAnalytics.h"
#include "HSMailChimp.h"

#import "ItsBeta.h"

#import "HSCalendarViewController.h"

#import "StationsViewController.h"
#import "InfoViewController.h"
#import "HSLoginChoiceViewController.h"
#import "Common.h"
#import "TutorialViewController.h"

#import "HSCalendar.h"
#import "HSCalendarEventNotifier.h"

static NSString * const PARSE_APP_ID = @"EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu";
static NSString * const PARSE_CLIENT_KEY = @"uNarhakSf1on8lJjrAVs1VWmPlG1D6ZJf9dO5QZY";
static NSString * const FACEBOOK_APP_ID = @"438918122827407";
static NSString * const FLURRY_APP_ID = @"2WRYH35MS5SW4ZY2TNPB";
static NSString * const TEST_FLIGHT_APP_ID = @"43651a8fd308e9fd491a1c8aa068f158_MTQxMjA0MjAxMi0xMC0wOSAwOTozMToyMS4zNzU1ODc";
static NSString * const CRITTERCISM_APP_ID = @"50f5e3804f633a256d000003";
static NSString * const APP_STORE_APP_ID = @"578970724";
static NSString * const ITSBETA_ACCESS_TOKEN = @"059db4f010c5f40bf4a73a28222dd3e3";
static NSString * const MAILCHIMP_API_KEY = @"9392e150a6a0a5e66d42d2cd56d5d219-us4";
static NSString * const MAILCHIMP_DONOR_LIST_ID = @"63b23fc742";
static NSString * const CRASHLYTICS_ID = @"9d515447ae8b641e682dacd6b67757ba2762308f";

#define IS_NEW_STATIONS NO

@interface AppDelegate ()

@property (nonatomic, strong) HSCalendarEventNotifier *calendarEventNotifier;

- (void)makeTabBarHidden:(BOOL)hide;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [self configureServices];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [self createRootViewController];    
    
    [self makeTabBarHidden:YES];
    [self.window makeKeyAndVisible];
    
    [self handleNotificationsIfExistsInOptions:launchOptions];
    [self launchServices];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [Appirater appEnteredForeground:YES];
}

- (void)makeTabBarHidden:(BOOL)hide {
    // Custom code to hide TabBar
    if ([self.tabBarController.view.subviews count] < 2) {
        return;
    }
    
    UIView *contentView = [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ?
            [self.tabBarController.view.subviews objectAtIndex:1] :
            [self.tabBarController.view.subviews objectAtIndex:0];
    
    if (hide) {
        contentView.frame = self.tabBarController.view.bounds;
    } else {
        contentView.frame = CGRectMake(self.tabBarController.view.bounds.origin.x,
                                       self.tabBarController.view.bounds.origin.y,
                                       self.tabBarController.view.bounds.size.width,
                                       self.tabBarController.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    }
    
    self.tabBarController.tabBar.hidden = hide;
    self.tabBarController.moreNavigationController.navigationBar.hidden = YES;
}

- (BOOL)handleOpenURL:(NSURL*)url {
    BOOL handled = [PFFacebookUtils handleOpenURL:url];
    if(handled == NO) {
        handled = [ItsBeta handleOpenURL:url];
    }
    return handled;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self handleOpenURL:url];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [self handleLocalNotification:notification];
}

#pragma mark  Private
#pragma mark - Notifications handler
- (void)handleLocalNotification:(UILocalNotification *)notification {
    [self.calendarEventNotifier processLocalNotification:notification];
}

#pragma mark - Configuration helpers
- (void)configureServices {
    [Parse setApplicationId:PARSE_APP_ID clientKey:PARSE_CLIENT_KEY];
    [PFFacebookUtils initializeWithApplicationId:FACEBOOK_APP_ID];
    [HSFlurryAnalytics initWithAppId:FLURRY_APP_ID];
#ifndef DEBUG
    [TestFlight takeOff:TEST_FLIGHT_APP_ID];
    [Crashlytics startWithAPIKey:CRASHLYTICS_ID];
#endif
    //[Crittercism enableWithAppID: CRITTERCISM_APP_ID];
    
    [Appirater setAppId:APP_STORE_APP_ID];
    [Appirater setDaysUntilPrompt:2];
    [Appirater setUsesUntilPrompt:3];
    [Appirater setTimeBeforeReminding:2];
    
    [[HSMailChimp sharedInstance] configureWithApiKey:MAILCHIMP_API_KEY listId:MAILCHIMP_DONOR_LIST_ID];
    
    [ItsBeta setApplicationAccessToken:ITSBETA_ACCESS_TOKEN];
    [ItsBeta setApplicationProjectWhiteList:[NSArray arrayWithObjects:@"donor", nil]];
    [ItsBeta synchronizeApplication];
}

- (void)launchServices {
    [Appirater appLaunched:YES];
}

- (void)handleNotificationsIfExistsInOptions:(NSDictionary *)options {
    UILocalNotification *localNotification = [options objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification != nil) {
        [self handleLocalNotification:localNotification];
    }
}

- (UIViewController *)createRootViewController {
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
    
    self.calendarEventNotifier = [[HSCalendarEventNotifier alloc] init];
    
    HSCalendarViewController *calendarViewController = [[HSCalendarViewController alloc] initWithNibName:@"HSCalendarViewController" bundle:nil];
    UINavigationController *calendarNavigationController = [[UINavigationController alloc] initWithRootViewController:calendarViewController];
    
    [self.calendarEventNotifier addNotificationHandler:calendarViewController];
    
    NSString *stationsControllerName = IS_NEW_STATIONS ? @"HSStationsViewController" : @"StationsViewController";
    StationsViewController *stationsViewController = [[StationsViewController alloc] initWithNibName:stationsControllerName bundle:nil];
    UINavigationController *stationsNavigationController = [[UINavigationController alloc] initWithRootViewController:stationsViewController];
    
    InfoViewController *infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
    UINavigationController *infoNavigationController = [[UINavigationController alloc] initWithRootViewController:infoViewController];
    
    HSLoginChoiceViewController *loginChoiceViewController = [[HSLoginChoiceViewController alloc] initWithNibName:@"HSLoginChoiceViewController" bundle:nil];
    UINavigationController *profileNavigationController = [[UINavigationController alloc] initWithRootViewController:loginChoiceViewController];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:calendarNavigationController, stationsNavigationController, infoNavigationController, profileNavigationController, nil];
    
    UINavigationController *rootNavigationController = [[UINavigationController alloc] initWithRootViewController:self.tabBarController];
    rootNavigationController.navigationBarHidden = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"isFirstStart"])
    {
        TutorialViewController *tutorialViewController = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
        [rootNavigationController pushViewController:tutorialViewController animated:NO];
        [defaults setBool:YES forKey:@"isFirstStart"];
    }
    
    self.sTabBarController = [[STabBarController alloc] initWithNativeTabBarController:self.tabBarController];
    self.tabBarController.selectedIndex = 3;
    
    return rootNavigationController;
}

@end
