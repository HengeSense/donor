//
//  HSFoursquare.m
//  Donor
//
//  Created by Sergey Seroshtan on 18.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSFoursquare.h"

#include <libkern/OSAtomic.h>

#import "Foursquare2.h"

#import "HSStationInfo.h"
#import "HSStationReview.h"

#import "HSFoursquareError.h"
#import "HSFoursquareVenue.h"
#import "HSFoursquareTip.h"

#pragma mark - Foursquare setup keys
static NSString * const FOURSQUARE_ID = @"SCVGUV4WOSZKD3NJ53D1EHBTKU3RC0QAVGCB40D10Y14IGQM";
static NSString * const FOURSQUARE_SECRET = @"CF3PIZ24E14TGKNEQ3NXUNDXVDB2MD2ZI12RJV4V13LEUFJZ";
static NSString * const FOURSQUARE_CALLBACK = @"http://donorapp.ru";

static NSString * const FOURSQUARE_HOSPITAL_CATEGORY_ID = @"4bf58dd8d48988d196941735";

@implementation HSFoursquare

static NSMutableDictionary *venueCache;
static NSMutableDictionary *tipCache;

#pragma mark - Foursquare service initialization
+ (void)initialize {
    [Foursquare2 setupFoursquareWithKey:FOURSQUARE_ID secret:FOURSQUARE_SECRET callbackURL:FOURSQUARE_CALLBACK];
    venueCache = [NSMutableDictionary dictionary];
    tipCache = [NSMutableDictionary dictionary];
}

#pragma mark - Singleton
+ (id)sharedInstance {
    static HSFoursquare *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Foursquare API
+ (BOOL)isUserAuthenticated {
    return [Foursquare2 isAuthorized];
}

+ (void)getStationReviews:(HSStationInfo *)stationInfo completion:(HSFoursquareCompletionType)completion {
    THROW_IF_ARGUMENT_NIL(stationInfo);
    THROW_IF_ARGUMENT_NIL(completion);
    [Foursquare2 searchTipNearbyLatitude:stationInfo.lat.stringValue longitude:stationInfo.lon.stringValue limit:nil
            offset:nil friendsOnly:NO query:nil callback:^(BOOL success, id result) {
                if (success) {
                    NSArray *rawTips = [result valueForKeyPath:@"response.tips"];
                    if (rawTips == nil && rawTips.count == 0) {
                        completion(success, nil);
                    }
                    NSPredicate *nameFilter =
                            [NSPredicate predicateWithFormat:@"venue.name like[cd] %@", stationInfo.name];
                    NSArray *filteredByNameRawTips = [rawTips filteredArrayUsingPredicate:nameFilter];
                    NSArray *tips = [HSFoursquareTip arrayWithUnderlyingDictionaries:filteredByNameRawTips];
                    NSArray *stationReviews = [self createStationReviewsFromTips:tips];
                    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date"
                            ascending:NO];
                    NSSortDescriptor *reviwerNameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"reviewerName"
                            ascending:YES];
                    NSArray *stationReviewsSorted =
                            [stationReviews sortedArrayUsingDescriptors:@[dateDescriptor, reviwerNameDescriptor]];
                    completion(success, stationReviewsSorted);
                } else {
                    completion(NO, [HSFoursquareError errorWithResponse:result]);
                }
            }];
}

+ (void)addStationReview:(HSStationReview *)stationReview toStation:(HSStationInfo *)stationInfo
        completion:(HSFoursquareCompletionType)completion {
    
    THROW_IF_ARGUMENT_NIL(stationReview);
    THROW_IF_ARGUMENT_NIL(stationInfo);
    
    void (^processSuccess)(id foursquareResult) = ^(id foursquareResult) {
        (void)foursquareResult;
        if (completion) {
            completion(YES, nil);
        }
    };
    
    void (^processFailure)(id) = ^(id foursquareResult){
        if (completion) {
            completion(NO, [HSFoursquareError errorWithResponse:foursquareResult]);
        }
    };
    
    void (^processAddStationReviewForVenue)(HSFoursquareVenue *, HSStationReview *) =
            ^(HSFoursquareVenue *venue, HSStationReview *stationReview) {
                NSString *review = stationReview.review;
                if (stationReview.rating != nil) {
                    //review = [review stringByAppendingFormat:@" [Оценка станции - %d]", stationReview.rating.intValue];
                }
                [Foursquare2 addTip:review forVenue:venue.uid withURL:nil callback:^(BOOL success, id result) {
                    if (success) {
                        processSuccess(result);
                    } else {
                        processFailure(result);
                    }
                }];
            };
    
    // Main algorithm
    void (^processAddStationReview)(void) = ^{
        [self findNearestVenueForStation:stationInfo completion:^(BOOL success, id result) {
            if (success) {
                processAddStationReviewForVenue((HSFoursquareVenue *)result, stationReview);
            } else {
                [self createVenueForStation:stationInfo completion:^(BOOL success, id result) {
                    if (success) {
                        processAddStationReviewForVenue((HSFoursquareVenue *)result, stationReview);
                    } else {
                        processFailure(result);
                    }
                }];
            }
        }];
    };
    
    if ([self isUserAuthenticated]) {
        processAddStationReview();
    } else {
        [Foursquare2 authorizeWithCallback:^(BOOL success, id result) {
            if (success) {
                processAddStationReview();
            } else {
                processFailure(result);
            }
        }];
    }
}

+ (double)getDistanceBetweenStation:(HSStationInfo *)stationInfo andVenue:(HSFoursquareVenue *)venue {
    THROW_IF_ARGUMENT_NIL(stationInfo);
    THROW_IF_ARGUMENT_NIL(venue);
    
    const double R = 6371.0;
    
    double lat1 = stationInfo.lat.doubleValue;
    double lon1 = stationInfo.lon.doubleValue;
    
    double lat2 = venue.lat.doubleValue;
    double lon2 = venue.lon.doubleValue;
    
    double x = (lon2-lon1) * cos((lat1+lat2)/2);
    double y = (lat2-lat1);
    double d = sqrt(x*x + y*y) * R;
    
    return d;
}

+ (void)findNearestVenueForStation:(HSStationInfo *)stationInfo completion:(HSFoursquareCompletionType)completion {
    THROW_IF_ARGUMENT_NIL(stationInfo);
    THROW_IF_ARGUMENT_NIL(completion);
    
    void (^findNearestVenueAndComplete)(NSArray *) = ^(NSArray *venues){
        NSArray *sortedByLocationVenues = [venues sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            HSFoursquareVenue *venue1 = obj1;
            HSFoursquareVenue *venue2 = obj2;
            
            double d1 = [self getDistanceBetweenStation:stationInfo andVenue:venue1];
            double d2 = [self getDistanceBetweenStation:stationInfo andVenue:venue2];
            
            return d1 - d2;
        }];
        
        if (sortedByLocationVenues.count > 0) {
            completion(YES, sortedByLocationVenues[0]);
        } else {
            completion(NO, nil);
        }
    };
    
    [self getVenuesForStation:stationInfo completion:^(BOOL success, id result) {
        if (success) {
            findNearestVenueAndComplete(result);
        } else {
            completion(NO, result);
        }
    }];
}

+ (void)createVenueForStation:(HSStationInfo *)stationInfo completion:(HSFoursquareCompletionType)completion {
    THROW_IF_ARGUMENT_NIL(stationInfo);
    THROW_IF_ARGUMENT_NIL(completion);
    
    [Foursquare2 addVenueWithName:stationInfo.name address:stationInfo.address crossStreet:nil city:stationInfo.town
            state:stationInfo.region_name zip:nil phone:stationInfo.phone latitude:stationInfo.lat.stringValue
            longitude:stationInfo.lon.stringValue primaryCategoryId:FOURSQUARE_HOSPITAL_CATEGORY_ID
            callback:completion];
}

+ (void)getVenuesForStation:(HSStationInfo *)stationInfo completion:(HSFoursquareCompletionType)completion {
    THROW_IF_ARGUMENT_NIL(stationInfo);
    THROW_IF_ARGUMENT_NIL(completion);
    
    [Foursquare2 searchVenuesNearByLatitude:stationInfo.lat longitude:stationInfo.lon accuracyLL:nil
            altitude:nil accuracyAlt:nil query:stationInfo.name limit:nil intent:intentGlobal
            radius:nil categoryId:nil callback:^(BOOL success, id result) {
                if (success) {
                    NSArray *rawVenues = [result valueForKeyPath:@"response.venues"];
                    NSArray *venues = [HSFoursquareVenue arrayWithUnderlyingDictionaries:rawVenues];
                    completion(YES, venues);
                } else {
                    completion(NO, result);
                }
            }];
}

#pragma mark - Private
+ (NSRegularExpression *)ratingRegex {
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

+ (NSNumber *)extractStationRatingFromTip:(HSFoursquareTip *)tip {
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

+ (NSString *)trimRatingMetaInfoFromText:(NSString *)text {
    NSArray *matches = [[self ratingRegex] matchesInString:text options:NSMatchingCompleted
            range:NSMakeRange(0, text.length)];
    if (matches.count > 0) {
        NSTextCheckingResult *match = matches[0];
        return [text stringByReplacingCharactersInRange:[match range] withString:@""];
    }
    return text;
}

+ (NSArray *)createStationReviewsFromTips:(NSArray *)tips {
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
