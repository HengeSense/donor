//
//  HSStationCardViewController.h
//  Donor
//
//  Created by Eugine Korobovsky on 09.04.13.
//  Updated by Sergey Seroshtan on 24.05.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSStationInfo.h"

@class DYRateView;

@interface HSStationCardViewController : UIViewController

/// @name Initialization
- (id)initWithStationInfo:(HSStationInfo *)stationInfo;

/// @name Configuration properties
@property (nonatomic) BOOL isShowAllInfoForced;
@property (nonatomic) BOOL isMapButtonInitiallyHidden;

/// @name UI properties
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *stationContentView;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *dottedLine1;

/// @name User ratings UI
@property (nonatomic, strong) IBOutlet DYRateView *rateView;
@property (nonatomic, strong) IBOutlet UILabel *rateCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *doReviewButton;

@property (strong, nonatomic) IBOutlet UILabel *reviewsLabel;
@property (strong, nonatomic) IBOutlet UILabel *reviewsCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *reviewsArrowImage;
@property (strong, nonatomic) IBOutlet UIImageView *reviewsTopSeparationLine;

@property (strong, nonatomic) IBOutlet UIButton *showReviewsButton;


@property (nonatomic, strong) IBOutlet UIImageView *dottedLine2;
@property (nonatomic, strong) IBOutlet UILabel *regionTitle;
@property (nonatomic, strong) IBOutlet UILabel *regionLabel;
@property (nonatomic, strong) IBOutlet UILabel *districtTitle;
@property (nonatomic, strong) IBOutlet UILabel *districtLabel;
@property (nonatomic, strong) IBOutlet UILabel *townTitle;
@property (nonatomic, strong) IBOutlet UILabel *townLabel;
@property (nonatomic, strong) IBOutlet UILabel *addressTitle;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) IBOutlet UILabel *phoneTitle;
@property (nonatomic, strong) IBOutlet UILabel *phoneLabel;
@property (nonatomic, strong) IBOutlet UIImageView *dottedLine3;
@property (nonatomic, strong) IBOutlet UILabel *workhoursTitle;
@property (nonatomic, strong) IBOutlet UILabel *workhoursLabel;
@property (nonatomic, strong) IBOutlet UIImageView *dottedLine4;
@property (nonatomic, strong) IBOutlet UILabel *citeTitle;
@property (nonatomic, strong) IBOutlet UILabel *citeLabel;
@property (nonatomic, strong) IBOutlet UIButton *goToSiteButton;
@property (nonatomic, strong) IBOutlet UIButton *showOnMapButton;

/// @name UI Actions
- (IBAction)showReviews:(id)sender;
- (IBAction)doReview:(id)sender;

@end
