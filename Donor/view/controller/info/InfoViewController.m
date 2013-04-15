//
//  InfoViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Updated by Sergey Seroshtan on 17.01.13
//  Copyright (c) 2012 HintSolution. All rights reserved.
//

#import "InfoViewController.h"

#import <Parse/Parse.h>

#import "NewsSubViewController.h"
#import "AdsSubViewController.h"
#import "InfoSubViewController.h"

#import "AdViewController.h"
#import "HSNewsViewController.h"
#import "HSRecommendationsViewController.h"
#import "HSContraindicationsViewController.h"
#import "StationDescriptionViewController.h"

#import "UIView+HSLayoutManager.h"

@interface InfoViewController () <INewsSelectListener, IAdsSelectListener, IInfoSubViewListener>

@property (nonatomic, strong) AdsSubViewController *adsSubViewController;
@property (nonatomic, strong) NewsSubViewController *newsSubViewController;
@property (nonatomic, strong) InfoSubViewController *infoSubViewController;

@property (nonatomic, weak) UIViewController *currentContentViewController;

@end

@implementation InfoViewController

#pragma mark Lifecycle
- (void)configureUI {
    self.title = @"Информация";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
            style:UIBarButtonItemStyleBordered target:nil action:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.currentContentViewController == nil) {
        // First apearance and ads should be shown
        [self showAdsView:nil];
    }
}

#pragma mark - UI actions
- (IBAction)showAdsView:(id)sender {
    if (self.adsSubViewController == nil) {
        self.adsSubViewController = [[AdsSubViewController alloc] initWithNibName:@"AdsSubViewController" bundle:nil];
        self.adsSubViewController.delegate = self;
    }
    self.adsButton.selected = YES;
    self.newsButton.selected = NO;
    self.infoButton.selected = NO;
    [self showContentViewController:self.adsSubViewController];
}

- (IBAction)showNewsView:(id)sender {
    if (self.newsSubViewController == nil) {
        self.newsSubViewController =
                [[NewsSubViewController alloc] initWithNibName:@"NewsSubViewController" bundle:nil];
        self.newsSubViewController.delegate = self;
    }
    self.adsButton.selected = NO;
    self.newsButton.selected = YES;
    self.infoButton.selected = NO;
    [self showContentViewController:self.newsSubViewController];
}

- (IBAction)showInfoView:(id)sender {
    if (self.infoSubViewController == nil) {
        self.infoSubViewController =
                [[InfoSubViewController alloc] initWithNibName:@"InfoSubViewController" bundle:nil];
        self.infoSubViewController.delegate = self;
    }
    self.adsButton.selected = NO;
    self.newsButton.selected = NO;
    self.infoButton.selected = YES;
    [self showContentViewController:self.infoSubViewController];
}

#pragma mark NewsSubViewControllerDelegate
- (void)newSelected:(MWFeedItem *)selectedNews {
    HSNewsViewController *controller = [[HSNewsViewController alloc] initWithNewsFeedItem:selectedNews];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark NewsSubViewControllerDelegate
- (void)adSelected:(PFObject *)selectedAd {
    AdViewController *controller = [[AdViewController alloc] initWithNibName:@"AdViewController" bundle:nil
            selectedNew:selectedAd];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark NewsSubViewControllerDelegate
 - (void)nextViewSelected:(int)viewId {
    if (viewId == 0) {
        HSRecommendationsViewController *controller =
                [[HSRecommendationsViewController alloc] initWithNibName:@"HSRecommendationsViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        HSContraindicationsViewController *controller =
                [[HSContraindicationsViewController alloc] initWithNibName:@"HSContraindicationsViewController"
                                                                    bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - Private UI utils
- (void)showContentViewController:(UIViewController *)contentViewController {
    [self.currentContentViewController.view removeFromSuperview];
    [contentViewController.view adjustAsContentViewIncludeAdditionalNavigationBar:self.topTabBarView];
    [self.view addSubview:contentViewController.view];
    self.currentContentViewController = contentViewController;
}

@end
