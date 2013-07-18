//
//  HSStationReview.h
//  Donor
//
//  Created by Sergey Seroshtan on 14.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This class represents user's review for specific station.
 * It contain information as well about rating left by user as his comments.
 */
@interface HSStationReview : NSObject<NSCoding>

/// @name Properties
@property (nonatomic, strong) NSString *reviewerName;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSString *review;
@property (nonatomic, strong) NSDate *date;


/// @name Initialization
- (id)initWithReviewerName:(NSString *)reviewerName rating:(NSNumber *)rating review:(NSString *)review;
- (id)initWithReviewerName:(NSString *)reviewerName rating:(NSNumber *)rating review:(NSString *)review
        date:(NSDate *)date;

@end
