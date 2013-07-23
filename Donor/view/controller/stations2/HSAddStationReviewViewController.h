//
//  HSAddStationReviewViewController.h
//  Donor
//
//  Created by Sergey Seroshtan on 22.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DYRateView;
@class HSStationInfo;
@class HSStationReview;

@protocol HSAddStationReviewDelegate;

@interface HSAddStationReviewViewController : UIViewController

/// @name Initialization
- (id)initWithStationInfo:(HSStationInfo *)stationInfo;

/// @name UI properties
/// @name Root views
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

/// @name Content views
@property (weak, nonatomic) IBOutlet UIView *underStationNameLabelView;
@property (weak, nonatomic) IBOutlet UIView *additionalInfoView;

@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (weak, nonatomic) IBOutlet DYRateView *stationRateView;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet UIButton *addReviewButton;


/// @name Functional
@property (nonatomic, assign) id<HSAddStationReviewDelegate>delegate;

/// @name UI actions
- (IBAction)addReview:(id)sender;

@end

@protocol HSAddStationReviewDelegate <NSObject>
@required
- (void)stationReviewsWasUpdated;

@end


