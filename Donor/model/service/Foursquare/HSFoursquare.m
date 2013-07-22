//
//  HSFoursquare.m
//  Donor
//
//  Created by Sergey Seroshtan on 18.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSFoursquare.h"

#import "Foursquare2.h"

#import "HSStationInfo.h"
#import "HSStationReview.h"

#import "HSFoursquareVenue.h"
#import "HSFoursquareTip.h"

@implementation HSFoursquare

#pragma mark - Singleton
+ (id)sharedInstance {
    static HSFoursquare *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - API
- (void)getStationReviews:(HSStationInfo *)stationInfo completion:(HSFoursquareCompletionType)completion {
    THROW_IF_ARGUMENT_NIL(stationInfo);
    THROW_IF_ARGUMENT_NIL(completion);
    [Foursquare2 searchTipNearbyLatitude:stationInfo.lat.stringValue longitude:stationInfo.lon.stringValue limit:nil
            offset:nil friendsOnly:NO query:stationInfo.name callback:^(BOOL success, id result) {
                if (success) {
                    NSArray *rawTips = [result valueForKeyPath:@"response.tips"];
                    if (rawTips == nil && rawTips.count == 0) {
                        completion(success, nil);
                    }
                    NSPredicate *nameFilter =
                            [NSPredicate predicateWithFormat:@"venue.name like[cd] %@", stationInfo.name];
                    NSArray *filteredByNameRawTips = [rawTips filteredArrayUsingPredicate:nameFilter];
                    NSArray *tips = [HSFoursquareTip arrayWithDictionaryBasedObjects:filteredByNameRawTips];
                    NSArray *stationReviews = [self createStationReviewsFromTips:tips];
                    completion (success, stationReviews);
                } else {
                    NSLog(@"Fail");
                }
            }];
}

#pragma mark - Private
- (NSRegularExpression *)ratingRegex {
    NSString *ratingPattern = @"\\[Оценка станции[\\s]*-[\\s]*([\\d]+)\\]";
    NSError *ratingRegexError = nil;
    NSRegularExpression *ratingRegex = [NSRegularExpression regularExpressionWithPattern:ratingPattern
            options:NSRegularExpressionCaseInsensitive error:&ratingRegexError];
    if (ratingRegexError) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Invalid regex pattren"
                                     userInfo:@{NSUnderlyingErrorKey : ratingRegexError}];
    }
    return ratingRegex;
}

- (NSNumber *)extractStationRatingFromTip:(HSFoursquareTip *)tip {
    THROW_IF_ARGUMENT_NIL(tip);
    
    NSArray *matches = [[self ratingRegex] matchesInString:tip.text options:NSMatchingCompleted
            range:NSMakeRange(0, tip.text.length)];
    if (matches.count > 0) {
        NSTextCheckingResult *match = matches[0];
        NSRange ratingRange = [match rangeAtIndex:1];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        return [numberFormatter numberFromString:[tip.text substringWithRange:ratingRange]];
    }
    return nil;
}

- (NSString *)trimRatingMetaInfoFromText:(NSString *)text {
    NSArray *matches = [[self ratingRegex] matchesInString:text options:NSMatchingCompleted
            range:NSMakeRange(0, text.length)];
    if (matches.count > 0) {
        NSTextCheckingResult *match = matches[0];
        return [text stringByReplacingCharactersInRange:[match range] withString:@""];
    }
    return text;
}

- (NSArray *)createStationReviewsFromTips:(NSArray *)tips {
    THROW_IF_ARGUMENT_NIL(tips);
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:tips.count];
    for (HSFoursquareTip *tip in tips) {
        NSString *reviewer = @"Unknown";
        if (tip.userFirstName != nil) {
            reviewer = tip.userFirstName;
        } else if (tip.userLastName != nil) {
            reviewer = tip.userLastName;
        }
        
        NSNumber *rating = [self extractStationRatingFromTip:tip];
        NSString *text = [self trimRatingMetaInfoFromText:tip.text];
        
        HSStationReview *review =
                [[HSStationReview alloc] initWithReviewerName:reviewer rating:rating review:text date:tip.createdAt];
        [result addObject:review];
    }
    return result;
}
@end
