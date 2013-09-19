//
//  HSStationReviewsViewController.m
//  Donor
//
//  Created by Sergey Seroshtan on 14.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSStationReviewsViewController.h"

#import "DYRateView.h"

#import "HSStationReview.h"
#import "HSViewUtils.h"
#import "HSUIResources.h"

#import "UIView+HSLayoutManager.h"

static const CGFloat kSectionsVerticalPadding = 10.0f;

@interface HSStationReviewsViewController ()

@property (strong, nonatomic) NSString *stationName;
@property (strong, nonatomic) NSArray *stationReviews;

@end

@implementation HSStationReviewsViewController

#pragma mark - Initialization / Lifecycle
- (id)initWithStationName:(NSString *)stationName stationReviews:(NSArray *)stationReviews {
    THROW_IF_ARGUMENT_NIL(stationName);
    THROW_IF_ARGUMENT_NIL(stationReviews);
    
    if ((self = [super initWithNibName:NSStringFromClass([HSStationReviewsViewController class]) bundle:nil]) == nil) {
        return nil;
    }
    self.stationName = stationName;
    self.stationReviews =
            [stationReviews sortedArrayUsingDescriptors:[NSArray arrayWithObject:
            [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    [self feedUI];
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rootScrollView adjustAsContentView];
}

#pragma mark - Private
#pragma mark - UI configuration
- (void)configureUI {
    self.title = @"Отзывы";
    [self configureNavigationBar];
    [self configureContentView];
    [self configureRootScrollView];
}

- (void)configureNavigationBar {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                style:UIBarButtonItemStyleBordered target:nil action:nil];
}

- (void)configureContentView {
    self.stationRateView.editable = NO;
    self.stationRateView.padding = 5.0;
    self.stationRateView.backgroundColor = [UIColor clearColor];
    self.stationRateView.emptyStarImage = [UIImage imageNamed:@"ratedStarEmpty"];
    self.stationRateView.fullStarImage = [UIImage imageNamed:@"ratedStarFill"];
}

- (void)configureRootScrollView {
    [self.rootScrollView addSubview:self.contentView];
}

#pragma mark - UI layout
- (void)layoutUI {
    [self layoutContentView];
    [self layoutRootScrollView];
}

- (void)layoutContentView {
    
    /* Vertical alignment */
    // Station name section
    CGFloat curY = kSectionsVerticalPadding;
    [HSViewUtils setFrameForLabel:self.stationNameLabel atYcoordChange:&curY];
    
    // Station rate section
    curY += kSectionsVerticalPadding;
    [HSViewUtils setFrameForView:self.stationRateTopSeparateLineImageView atYcoordChange:&curY];
    [HSViewUtils setFrameForView:self.stationRateView atYcoord:curY];
    [HSViewUtils setFrameForLabel:self.stationReviewsCountTitleLabel atYcoord:curY];
    [HSViewUtils setFrameForLabel:self.stationReviewsCountLabel atYcoordChange:&curY];
    [HSViewUtils setFrameForView:self.stationRateBottomSeparateLineImageView atYcoordChange:&curY];
    
    // Station reviews section
    curY += kSectionsVerticalPadding;
    [HSViewUtils setFrameForLabel:self.foursquareTitleLabel atYcoord:curY];
    [HSViewUtils setFrameForView:self.foursquareImageView atYcoord:curY];
    [HSViewUtils setFrameForLabel:self.colonLabel atYcoordChange:&curY];
    [HSViewUtils setFrameForView:self.stationReviewsSeparateLineImageView atYcoordChange:&curY];
    
    [self.contentView changeFrameHeight:curY];
    
    /* Horizontal alignment*/
    [self.stationReviewsCountLabel sizeToFit];
    
    [self.stationReviewsCountLabel moveFrameX:self.stationRateTopSeparateLineImageView.frame.origin.x +
            self.stationRateTopSeparateLineImageView.frame.size.width - self.stationReviewsCountLabel.frame.size.width];
    
    const CGFloat kWordGap = 3.0f;
    [self.stationReviewsCountTitleLabel moveFrameX:self.stationReviewsCountLabel.frame.origin.x -
            self.stationReviewsCountTitleLabel.bounds.size.width - kWordGap];
    
    [self createAndLayoutDynamicPartOfContentView];
}

- (void)createAndLayoutDynamicPartOfContentView {
    
    const CGFloat dynamicContentViewX = self.stationRateBottomSeparateLineImageView.frame.origin.x;
    const CGFloat dynamicContentViewWidth = self.stationRateBottomSeparateLineImageView.frame.size.width;
    
    for (HSStationReview *review in self.stationReviews) {
        UIView *reviewView = [self createViewForStationReview:review withWidth:dynamicContentViewWidth];
        [reviewView moveFrameX:dynamicContentViewX];
        [reviewView moveFrameY:self.contentView.bounds.size.height];
        [self.contentView changeFrameHeight:self.contentView.bounds.size.height + reviewView.bounds.size.height];
        [self.contentView addSubview:reviewView];
    }
}

- (void)layoutRootScrollView {
    self.rootScrollView.contentSize = self.contentView.bounds.size;
}

#pragma mark - UI views factory
- (UIImageView *)createSeparationLineImageView {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DonorStations_dottedLine"]];
}

- (UIView *)createViewForStationReview:(HSStationReview *)stationReview withWidth:(CGFloat)viewWidth {
    THROW_IF_ARGUMENT_NIL(stationReview);
    
    const CGFloat labelInitialHeight = 20;
    const CGFloat labelVerticalPadding = 5;
    
    CGFloat viewHeight = 0;
    
    // Date
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, viewHeight, viewWidth, labelInitialHeight)];
    dateLabel.text = [self formatDate:stationReview.date];
    dateLabel.font = [HSUIResources titleLabelFont];
    dateLabel.textColor = [HSUIResources titleLabelColor];
    dateLabel.backgroundColor = [UIColor clearColor];
    [dateLabel sizeToFit];
    
    // Reviewer name
    UILabel *reviewerNameLabel =
            [[UILabel alloc] initWithFrame:CGRectMake(0, viewHeight, viewWidth, labelInitialHeight)];
    reviewerNameLabel.text = stationReview.reviewerName;
    reviewerNameLabel.font = [HSUIResources specialTitleLabelFont];
    reviewerNameLabel.textColor = [HSUIResources specialTitleLabelColor];
    reviewerNameLabel.backgroundColor = [UIColor clearColor];
    [reviewerNameLabel sizeToFit];
    [reviewerNameLabel moveFrameX:viewWidth - reviewerNameLabel.bounds.size.width];
    
    viewHeight = MAX(dateLabel.bounds.size.height, reviewerNameLabel.bounds.size.height);
    
    // Review
    viewHeight += labelVerticalPadding;
    
    UILabel *reviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, viewHeight, viewWidth, labelInitialHeight)];
    reviewLabel.text = stationReview.review;
    reviewLabel.font = [HSUIResources baseTextFont];
    reviewLabel.textColor = [HSUIResources baseTextColor];
    reviewLabel.backgroundColor = [UIColor clearColor];
    reviewLabel.numberOfLines = 0;
    [reviewLabel sizeToFit];

    viewHeight += reviewLabel.bounds.size.height;
    
    // Separation line
    viewHeight += labelVerticalPadding;
    UIImageView *separationLine = [self createSeparationLineImageView];
    separationLine.frame = CGRectMake(0, viewHeight, viewWidth, separationLine.bounds.size.height);
    
    viewHeight += separationLine.bounds.size.height;
    
    // Add subviews
    UIView *result = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    [result addSubview:dateLabel];
    [result addSubview:reviewerNameLabel];
    [result addSubview:reviewLabel];
    [result addSubview:separationLine];

    return result;
}

#pragma mark - UI feed
- (void)feedUI {
    self.stationNameLabel.text = self.stationName;
    self.stationReviewsCountLabel.text = [NSString stringWithFormat:@"%u",
            [HSStationReview calculateRatedStationsWithReviews:self.stationReviews]];
    self.stationRateView.rate = [HSStationReview calculateStationRatingWithReviews:self.stationReviews];
}

#pragma mark - UI feed helpers
- (NSString *)formatDate:(NSDate *)date {
    THROW_IF_ARGUMENT_NIL(date);
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterNoStyle];
        [formatter setDateFormat:@"dd.MM.yyyy"];
    });
    
    return [formatter stringFromDate:date];
}

@end
