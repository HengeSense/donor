//
//  AppDelegate.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "CalendarViewController.h"
#import "StationsViewController.h"
#import "InfoViewController.h"
#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "Common.h"
//#import "SHKConfiguration.h"
//#import "SHKFacebook.h"
#import "MessageBoxViewController.h"
#import "TutorialViewController.h"

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
    [Parse setApplicationId:@"EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu" clientKey:@"uNarhakSf1on8lJjrAVs1VWmPlG1D6ZJf9dO5QZY"];
    
    if ([Common getInstance].isNeedPassword && [PFUser currentUser])
        [PFUser logOut];
    
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
    
    CalendarViewController *calendarViewController = [[[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil] autorelease];
    UINavigationController *calendarNavigationController = [[[UINavigationController alloc] initWithRootViewController:calendarViewController] autorelease];
    
    StationsViewController *stationsViewController = [[[StationsViewController alloc] initWithNibName:@"StationsViewController" bundle:nil] autorelease];
    UINavigationController *stationsNavigationController = [[[UINavigationController alloc] initWithRootViewController:stationsViewController] autorelease];
    
    InfoViewController *infoViewController = [[[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil] autorelease];
    UINavigationController *infoNavigationController = [[[UINavigationController alloc] initWithRootViewController:infoViewController] autorelease];
    
    ProfileViewController *profileViewController = [[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil] autorelease];
    UINavigationController *profileNavigationController = [[[UINavigationController alloc] initWithRootViewController:profileViewController] autorelease];
    
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
    
    self.sTabBarController = [[STabBarController alloc] init];
    self.sTabBarController.tabBarController = self.tabBarController;
    [self.sTabBarController addSubview];
    
    self.window.rootViewController = rootNavigationController;
    
    [self.window makeKeyAndVisible];
    
    [self makeTabBarHidden:YES];
    
    if (![PFUser currentUser])
    {
        [self.tabBarController setSelectedIndex:3];
    }
    
    [self.sTabBarController selectTab];
        
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

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self.tabBarController setSelectedIndex:0];
    UINavigationController *navigationController = [self.tabBarController.viewControllers objectAtIndex:0];
    [navigationController popToRootViewControllerAnimated:NO];
    CalendarViewController *calendarViewController = [[navigationController viewControllers] objectAtIndex:0];
    
    MessageBoxViewController *messageBox = [[MessageBoxViewController alloc] initWithNibName:@"MessageBoxViewController"
                                                                                      bundle:nil
                                                                                       title:nil
                                                                                     message:notification.alertBody
                                                                                cancelButton:@"Позже"
                                                                                    okButton:@"Ок"];
    messageBox.delegate = calendarViewController;
    [calendarViewController.navigationController.tabBarController.view addSubview:messageBox.view];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if ([Common getInstance].isNeedPassword && [PFUser currentUser])
        [PFUser logOut];
}

- (BOOL)handleOpenURL:(NSURL*)url
{
   // NSString* scheme = [url scheme];
  //  NSString* prefix = [NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)];
  //  if ([scheme hasPrefix:prefix])
  //      return [SHKFacebook handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleOpenURL:url];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
