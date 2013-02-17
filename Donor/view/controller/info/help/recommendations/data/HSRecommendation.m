//
//  HSRecommendation.m
//  Donor
//
//  Created by Sergey Seroshtan on 20.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSRecommendation.h"

static NSString * const kRecommendationKey_Title = @"title";
static NSString * const kRecommendationKey_Recommendations = @"recommendations";

@interface HSRecommendation ()

@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSArray *recommendations;

@end

@implementation HSRecommendation

- (id)initWithDictionary:(NSDictionary *)rawData {
    self = [super init];
    if (self) {
        self.title = [rawData objectForKey:kRecommendationKey_Title];
        self.recommendations = [rawData objectForKey:kRecommendationKey_Recommendations];
    }
    return self;
}

@end
