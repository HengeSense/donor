//
//  HSFoursquareVenue.m
//  Donor
//
//  Created by Sergey Seroshtan on 18.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSFoursquareVenue.h"

@implementation HSFoursquareVenue

#pragma mark - Accessors
- (NSString *)name {
    return [self.underlyingDictionary valueForKeyPath:@"name"];
}

- (NSString *)canonicalUrl {
    return [self.underlyingDictionary valueForKeyPath:@"canonicalUrl"];
}

/// @name Location
- (NSNumber *)lat {
    return [self.underlyingDictionary valueForKeyPath:@"location.lat"];
}

- (NSNumber *)lon {
    return [self.underlyingDictionary valueForKeyPath:@"location.lng"];
}

- (NSString *)address {
    return [self.underlyingDictionary valueForKeyPath:@"location.address"];
}

- (NSString *)city {
    return [self.underlyingDictionary valueForKeyPath:@"location.city"];
}

- (NSString *)country {
    return [self.underlyingDictionary valueForKeyPath:@"location.country"];
}

- (NSNumber *)tipCount {
    return [self.underlyingDictionary valueForKeyPath:@"stats.tipCount"];
}

#pragma mark - NSObject Overriding
-(NSString *)description {
    return [NSString stringWithFormat:@"%@ (lat=%@, lon=%@)", self.name, self.lat, self.lon];
}

@end
