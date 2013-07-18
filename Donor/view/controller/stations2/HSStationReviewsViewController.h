//
//  HSStationReviewsViewController.h
//  Donor
//
//  Created by Sergey Seroshtan on 14.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DYRateView;
@class HSStationInfo;

@interface HSStationReviewsViewController : UIViewController

/**
 * @param stationName - name of the blood station
 * @param stationReviews - array of HSStationReview objetcs
 */
- (id)initWithStationName:(NSString *)stationName stationReviews:(NSArray *)stationReviews;

/// @name Root views
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

/// @name Content views
@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (weak, nonatomic) IBOutlet DYRateView *stationRateView;
@property (weak, nonatomic) IBOutlet UILabel *stationReviewsCountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationReviewsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *foursquareTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *foursquareImageView;
@property (weak, nonatomic) IBOutlet UILabel *colonLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stationRateTopSeparateLineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stationRateBottomSeparateLineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stationReviewsSeparateLineImageView;

@end
