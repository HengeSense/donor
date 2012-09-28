//
//  ReviewsCell.m
//  BloodDonor
//
//  Created by Владимир Носков on 12.08.12.
//
//

#import "ReviewsCell.h"

@implementation ReviewsCell

@synthesize ratedStar1, ratedStar2, ratedStar3, ratedStar4, ratedStar5, nameLabel, dateLabel, reviewLabel, contentSize;

- (void)dealloc
{
    [ratedStar1 release];
    [ratedStar2 release];
    [ratedStar3 release];
    [ratedStar4 release];
    [ratedStar5 release];
    [nameLabel release];
    [dateLabel release];
    [reviewLabel release];
    [super dealloc];
}

@end
