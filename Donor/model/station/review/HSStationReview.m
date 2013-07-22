//
//  HSStationReview.m
//  Donor
//
//  Created by Sergey Seroshtan on 14.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSStationReview.h"

#import "NSObject+NSCodingSupportForProperties.h"

@implementation HSStationReview

- (id)initWithReviewerName:(NSString *)reviewerName rating:(NSNumber *)rating review:(NSString *)review {
    return [self initWithReviewerName:reviewerName rating:rating review:review date:[NSDate date]];
}

- (id)initWithReviewerName:(NSString *)reviewerName rating:(NSNumber *)rating review:(NSString *)review
        date:(NSDate *)date{
    THROW_IF_ARGUMENT_NIL(reviewerName);
    THROW_IF_ARGUMENT_NIL(review);
    
    if ((self = [super init]) == nil) {
        return nil;
    }
    self.reviewerName = reviewerName;
    self.rating = rating;
    self.review = review;
    self.date = date;
    
    return self;
}

+ (NSArray *)getRatedStationReviews:(NSArray *)reviews {
    NSPredicate *reviewsWithRatingPredicate = [NSPredicate predicateWithFormat:@"rating != nil"];
    return [reviews filteredArrayUsingPredicate:reviewsWithRatingPredicate];
}

+ (double)calculateStationRatingWithReviews:(NSArray *)reviews {
    THROW_IF_ARGUMENT_NIL(reviews);
    return [[[self getRatedStationReviews:reviews] valueForKeyPath:@"@avg.rating"] doubleValue];
}

+ (NSUInteger)calculateRatedStationsWithReviews:(NSArray *)reviews {
    return [[self getRatedStationReviews:reviews] count];
}

@end
