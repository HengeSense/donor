//
//  HSStationCardViewController.m
//  Donor
//
//  Created by Eugine Korobovsky on 09.04.13.
//  Updated by Sergey Seroshtan on 24.05.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSStationCardViewController.h"

#import "MBProgressHUD.h"

#import "HSAlertViewController.h"
#import "HSStationsMapViewController.h"
#import "HSStationReviewsViewController.h"
#import "HSAddStationReviewViewController.h"

#import "HSFoursquare.h"
#import "DYRateView.h"
#import "HSViewUtils.h"
#import "UIView+HSLayoutManager.h"

#import "HSStationReview.h"

#pragma mark - UI constraints
static const CGFloat kVerticalTab_Label = 10.0f;
static const CGFloat kVerticalTab_ShowOnMapButton = 20.0f;

@interface HSStationCardViewController ()

@property (nonatomic, strong) HSStationInfo *stationInfo;
@property (nonatomic, strong) NSArray *stationReviews;

@end

@implementation HSStationCardViewController

- (id)initWithStationInfo:(HSStationInfo *)stationInfo {
    THROW_IF_ARGUMENT_NIL(stationInfo);
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if (self) {
        self.stationInfo = stationInfo;
        self.isShowAllInfoForced = NO;
        self.isMapButtonInitiallyHidden = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.scrollView adjustAsContentView];
    if (self.stationReviews == nil) {
        [self loadStationReviews];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)onGoToSitePressed:(id)sender{
    NSString *site = self.stationInfo.site;
    if(site){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:site]];
    };
};

- (IBAction)onShowOnMapPressed:(id)sender{
    HSStationsMapViewController *mapViewConroller =
            [[HSStationsMapViewController alloc] initWithStations:[NSArray arrayWithObject:self.stationInfo]];
    [self.navigationController pushViewController:mapViewConroller animated:YES];
};

- (IBAction)showReviews:(id)sender {
    HSStationReviewsViewController *vc = [[HSStationReviewsViewController alloc]
            initWithStationName:self.stationInfo.name stationReviews:self.stationReviews];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)doReview:(id)sender {
    HSAddStationReviewViewController *vc = [[HSAddStationReviewViewController alloc]
            initWithStationInfo:self.stationInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private
#pragma mark - UI configuration
- (void)configureUI {
    self.title = @"Станция";
    
    [self configureContentViews];
    [self configureNavigationBar];
    [self configureRootView];
}

- (void)configureNavigationBar {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
            style:UIBarButtonItemStyleBordered target:nil action:nil];
}

- (void)configureContentViews {
    // Rate view
    self.rateView.editable = NO;
    self.rateView.padding = 10.0;
    self.rateView.backgroundColor = [UIColor clearColor];
    self.rateView.emptyStarImage = [UIImage imageNamed:@"ratedStarEmpty"];
    self.rateView.fullStarImage = [UIImage imageNamed:@"ratedStarFill"];
    
    self.rateCountLabel.text = @" ";
    
    // Rate buttons
    [self.doReviewButton setTitleColor:self.doReviewButton.titleLabel.textColor forState:UIControlStateNormal];
    [self.doReviewButton setTitleColor:self.doReviewButton.titleLabel.textColor forState:UIControlStateHighlighted];
    
    // Reviews label
    self.reviewsCountLabel.text = @" ";
}

- (void)configureRootView {
    [self.scrollView addSubview:self.stationContentView];
}

#pragma mark - UI layout
- (void)layoutUI {
    [self layoutContentView];
    [self layoutRootView];
}

- (void)layoutContentView {
    self.nameLabel.text = self.stationInfo.name;
    self.regionLabel.text = self.stationInfo.region_name;
    self.districtLabel.text = self.stationInfo.district_name;
    self.townLabel.text = self.stationInfo.town;
    self.addressLabel.text = self.stationInfo.address;
    self.phoneLabel.text = self.stationInfo.phone;
    self.workhoursLabel.text = self.stationInfo.work_time;
    self.citeLabel.text = self.stationInfo.site;
    
    // User reviews section
    float curY = kVerticalTab_Label;
    [HSViewUtils setFrameForLabel:self.nameLabel atYcoordChange:&curY];
    [HSViewUtils setFrameForView:self.dottedLine1 atYcoordChange:&curY];
    
    [HSViewUtils setFrameForView:self.rateView atYcoord:curY];
    [HSViewUtils setFrameForLabel:self.rateCountLabel atYcoord:curY];
    [HSViewUtils setFrameForView:self.doReviewButton atYcoordChange:&curY];
    
    [HSViewUtils setFrameForView:self.reviewsTopSeparationLine atYcoordChange:&curY];

    [HSViewUtils setFrameForLabel:self.reviewsLabel atYcoord:curY];
    [HSViewUtils setFrameForLabel:self.reviewsCountLabel atYcoord:curY];
    [HSViewUtils setFrameForView:self.reviewsArrowImage atYcoord:curY];
    [HSViewUtils setFrameForView:self.showReviewsButton atYcoordChange:&curY];
    
    [HSViewUtils setFrameForView:self.dottedLine2 atYcoordChange:&curY];
    curY += kVerticalTab_Label;
    
    // 
    BOOL isHideRegionArea = NO;
    if(self.isShowAllInfoForced == NO){
        int curRegionId = [self.stationInfo.region_id integerValue];
        if(curRegionId == 35 || curRegionId == 79){
            isHideRegionArea = YES;
        };
    };
    if(isHideRegionArea == NO){
        [HSViewUtils setFrameForLabel:self.regionTitle atYcoord:curY];
        [HSViewUtils setFrameForLabel:self.regionLabel atYcoordChange:&curY];
        [HSViewUtils setFrameForLabel:self.districtTitle atYcoord:curY];
        [HSViewUtils setFrameForLabel:self.districtLabel atYcoordChange:&curY];
        [HSViewUtils setFrameForLabel:self.townTitle atYcoord:curY];
        [HSViewUtils setFrameForLabel:self.townLabel atYcoordChange:&curY];
        curY += kVerticalTab_Label;
    }
    [self.regionTitle setHidden:isHideRegionArea];
    [self.regionLabel setHidden:isHideRegionArea];
    [self.districtTitle setHidden:isHideRegionArea];
    [self.districtLabel setHidden:isHideRegionArea];
    [self.townTitle setHidden:isHideRegionArea];
    [self.townLabel setHidden:isHideRegionArea];
    
    [HSViewUtils setFrameForLabel:self.addressTitle atYcoord:curY];
    [HSViewUtils setFrameForLabel:self.addressLabel atYcoordChange:&curY];
    [HSViewUtils setFrameForLabel:self.phoneTitle atYcoord:curY];
    [HSViewUtils setFrameForLabel:self.phoneLabel atYcoordChange:&curY];
    curY += kVerticalTab_Label;
    
    [HSViewUtils setFrameForView:self.dottedLine3 atYcoordChange:&curY];
    [HSViewUtils setFrameForLabel:self.workhoursTitle atYcoord:curY];
    [HSViewUtils setFrameForLabel:self.workhoursLabel atYcoordChange:&curY];
    [HSViewUtils setFrameForView:self.dottedLine4 atYcoordChange:&curY];
    
    BOOL isSiteHidden = NO;
    if(!self.stationInfo.site || ![self.stationInfo.site isKindOfClass:[NSString class]] ||
       [self.stationInfo.site isEqualToString:@""]){
        isSiteHidden = YES;
    } else {
        isSiteHidden = NO;
        [HSViewUtils setFrameForLabel:self.citeTitle atYcoord:curY];
        [HSViewUtils setFrameForLabel:self.citeLabel atYcoordChange:&curY];
    }
    [self.citeTitle setHidden:isSiteHidden];
    [self.citeLabel setHidden:isSiteHidden];
    [self.goToSiteButton setHidden:isSiteHidden];
    
    curY += kVerticalTab_ShowOnMapButton;
    [self.showOnMapButton setHidden:self.isMapButtonInitiallyHidden];
    [HSViewUtils setFrameForView:self.showOnMapButton atYcoordChange:&curY];
    curY += kVerticalTab_ShowOnMapButton;
    
    CGRect contentFrame = self.stationContentView.frame;
    contentFrame.size.height = curY;
    self.stationContentView.frame = contentFrame;
}

- (void)layoutRootView {
    self.scrollView.contentSize = self.stationContentView.frame.size;
}

#pragma mark - UI feed
- (void)feedUI {
    if (self.stationReviews == nil) {
        NSLog(@"No statio reviews to feed UI");
        return;
    }
    self.rateView.rate = [HSStationReview calculateStationRatingWithReviews:self.stationReviews];
    self.rateCountLabel.text = [NSString stringWithFormat:@"%.2f",self.rateView.rate];
    self.reviewsCountLabel.text = [NSString stringWithFormat:@"%u", self.stationReviews.count];
}

#pragma mark - Station reviews
- (void)loadStationReviews {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [[HSFoursquare sharedInstance] getStationReviews:self.stationInfo completion:^(BOOL success, id result) {
        [hud hide:YES];
        if (success) {
            self.stationReviews = result;
            [self feedUI];
        } else {
            [HSAlertViewController showWithMessage:@"Произошла ошибка загрузки отзывов."];
        }
    }];
}

@end
