//
//  HSStationCardViewController.m
//  Donor
//
//  Created by Eugine Korobovsky on 09.04.13.
//  Updated by Sergey Seroshtan on 24.05.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSStationCardViewController.h"
#import "HSStationsMapViewController.h"

#import "HSStationReviewsViewController.h"

#import "Foursquare2.h"
#import "DYRateView.h"
#import "HSViewUtils.h"

#import "HSStationReview.h"

#pragma mark - UI constraints
static const CGFloat kVerticalTab_Label = 10.0f;
static const CGFloat kVerticalTab_ShowOnMapButton = 20.0f;

@interface HSStationCardViewController () <DYRateViewDelegate>

@property (nonatomic, strong) HSStationInfo *stationInfo;

@end

@implementation HSStationCardViewController

- (id)initWithStationInfo:(HSStationInfo *)stationInfo {
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
}

- (void)viewWillAppear:(BOOL)animated{
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
    self.scrollView.contentSize = contentFrame.size;
};

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
    NSMutableArray *stationReviews = [NSMutableArray array];
    [stationReviews addObject:[[HSStationReview alloc] initWithReviewerName:@"user1" rating:@1 review:@"rating1"]];
    [stationReviews addObject:[[HSStationReview alloc] initWithReviewerName:@"user2" rating:@2 review:@"rating2"]];
    [stationReviews addObject:[[HSStationReview alloc] initWithReviewerName:@"user3" rating:@3 review:@"rating3"]];
    [stationReviews addObject:[[HSStationReview alloc] initWithReviewerName:@"user4" rating:@4 review:@"rating4"]];
    [stationReviews addObject:[[HSStationReview alloc] initWithReviewerName:@"user5" rating:@5 review:@"rating5"]];
    
    HSStationReviewsViewController *vc =
            [[HSStationReviewsViewController alloc] initWithStationName:self.stationInfo.name
            stationReviews:stationReviews];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)doReview:(id)sender {
    NSLog([NSString stringWithFormat:@"%@ stub.", NSStringFromSelector(_cmd)]);
}

#pragma mark - Private
#pragma mark - UI configuration
- (void)configureUI {
    self.title = @"Станция";
    
    [self configureRateViews];
    [self configureNavigationBar];

    [self.scrollView addSubview:self.stationContentView];
    self.scrollView.contentSize = self.stationContentView.bounds.size;
}

- (void)configureNavigationBar {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
            style:UIBarButtonItemStyleBordered target:nil action:nil];
}

- (void)configureRateViews {
    // Rate view
    self.rateView.editable = YES;
    self.rateView.delegate = self;
    self.rateView.padding = 10.0;
    self.rateView.backgroundColor = [UIColor clearColor];
    self.rateView.emptyStarImage = [UIImage imageNamed:@"ratedStarEmpty"];
    self.rateView.fullStarImage = [UIImage imageNamed:@"ratedStarFill"];
    
    self.rateCountLabel.text = @" ";
    
    // Rate buttons
    [self.doReviewButton setTitleColor:self.doReviewButton.titleLabel.textColor forState:UIControlStateNormal];
    [self.doReviewButton setTitleColor:self.doReviewButton.titleLabel.textColor forState:UIControlStateHighlighted];
}

#pragma mark - DYRateViewDelegate
- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate {
    NSUInteger correctedRate = [rate unsignedIntegerValue];
    if (correctedRate < 1) {
        correctedRate = 0;
    } else if (correctedRate < 2) {
        correctedRate *= 1;
    } else if (correctedRate < 3) {
        correctedRate *= 10;
    } else if (correctedRate < 4) {
        correctedRate *= 100;
    } else if (correctedRate < 5) {
        correctedRate *= 1000;
    } else {
        correctedRate *= 10000;
    }
    self.rateCountLabel.text = [NSString stringWithFormat:@"(%u)", correctedRate];
}

@end
