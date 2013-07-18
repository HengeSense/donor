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
    THROW_IF_ARGUMENT_NIL(rating);
    THROW_IF_ARGUMENT_NIL(review);
    THROW_IF_ARGUMENT_NIL(date);
    
    if ((self = [super init]) == nil) {
        return nil;
    }
    self.reviewerName = reviewerName;
    self.rating = rating;
    self.review = review;
    self.date = date;
    
    return self;
} 

@end
