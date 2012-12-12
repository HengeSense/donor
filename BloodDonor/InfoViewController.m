//
//  InfoViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"

#import "NewsViewController.h"
#import <Parse/Parse.h>
#import "RecommendationsViewController.h"
#import "HSContraindicationsViewController.h"
#import "StationDescriptionViewController.h"

@implementation InfoViewController

@synthesize infoSubViewController, segmentedViewControllers, infoSubView;

- (NSArray *)segmentedViewControllerContent
{
    AdsSubViewController* controller1 = [[AdsSubViewController alloc] initWithNibName:@"AdsSubViewController" bundle:nil];
    controller1.delegate = self;
    
    NewsSubViewController *controller2 = [[NewsSubViewController alloc] initWithNibName:@"NewsSubViewController" bundle:nil];
    controller2.delegate = self;
    
    InfoSubViewController * controller3 = [[InfoSubViewController alloc] initWithNibName:@"InfoSubViewController" bundle:nil];
    controller3.delegate = self;
    
    NSArray * controllers = [NSArray arrayWithObjects:controller1, controller2, controller3, nil];
    
    [controller1 release];
    [controller2 release];
    [controller3 release];
    
    return controllers;
}

- (void)didChangeSegmentControl:(UIButton *)button
{
    if (self.infoSubViewController) 
    {
        [self.infoSubViewController viewWillDisappear:NO];
        [self.infoSubViewController.view removeFromSuperview];
        [self.infoSubViewController viewDidDisappear:NO];
    }
    
    self.infoSubViewController = [self.segmentedViewControllers objectAtIndex:button.tag];
    
    [self.infoSubViewController viewWillAppear:NO];
    [self.infoSubView addSubview:self.infoSubViewController.view];
    [self.infoSubViewController viewDidAppear:NO];
}

#pragma mark Actions

- (void)selectTab:(int)index
{
    switch (index)
    {
        case 0:
            [self tabSelected:adsButton];
            break;
        case 1:
            [self tabSelected:newsButton];
            break;
        case 2:
            [self tabSelected:infoButton];
            break;
            
        default:
            break;
    }
}

- (IBAction)tabSelected:(id)sender
{
    UIButton *button = (UIButton*)sender;
    infoSubView.scrollsToTop = YES;
    
    if (!button.selected)
    {
        button.selected = YES;
        
        if (button.tag == 0)
        {
            infoSubView.scrollEnabled = YES;
            newsButton.selected = NO;
            infoButton.selected = NO;
        }
        else if (button.tag == 1)
        {
            infoSubView.scrollEnabled = YES;
            adsButton.selected = NO;
            infoButton.selected = NO;
        }
        else
        {
            infoSubView.scrollEnabled = NO;
            newsButton.selected = NO;
            adsButton.selected = NO;
        }
        
        [self didChangeSegmentControl:button];
    }
}

#pragma mark NewsSubViewControllerDelegate

- (void)newSelected:(PFObject *)selectedNew
{
    NewsViewController *controller = [[[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil selectedNew:selectedNew] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark NewsSubViewControllerDelegate

- (void)adSelected:(PFObject *)selectedAd
{
    NewsViewController *controller = [[[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil selectedNew:selectedAd] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark NewsSubViewControllerDelegate
 - (void)nextViewSelected:(int)viewId
{
    if (viewId == 0)
    {
        RecommendationsViewController *controller = [[[RecommendationsViewController alloc] initWithNibName:@"RecommendationsViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        HSContraindicationsViewController *controller = [[HSContraindicationsViewController alloc] initWithNibName:@"HSContraindicationsViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        infoSubView.contentSize = CGSizeMake(320.0f, 323.0f);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Информация";
    
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];
    
    self.segmentedViewControllers = [self segmentedViewControllerContent];
    [self didChangeSegmentControl:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    for (UIViewController * viewController in self.segmentedViewControllers) {
        [viewController didReceiveMemoryWarning];
    }
}

- (void)viewDidUnload 
{
    self.segmentedViewControllers = nil;
    self.infoSubViewController = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    [self.infoSubViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSLog(@"%d", viewControllers.count);
    if (viewControllers.count > 2 && [[viewControllers objectAtIndex:viewControllers.count - 2] isKindOfClass:[StationDescriptionViewController class]])
    {
        [self tabSelected:adsButton];
    }
    
    [self.infoSubViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.infoSubViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.infoSubViewController viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [super dealloc];
}

@end
