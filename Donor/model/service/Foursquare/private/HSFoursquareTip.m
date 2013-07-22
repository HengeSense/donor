//
//  HSFoursquareTip.m
//  Donor
//
//  Created by Sergey Seroshtan on 22.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSFoursquareTip.h"

@implementation HSFoursquareTip

#pragma mark - Accessors
#pragma mark - Base
- (NSString *)canonicalUrl {
    return [self.underlyingDictionary valueForKeyPath:@"canonicalUrl"];
}

- (NSString *)text {
    return [self.underlyingDictionary valueForKeyPath:@"text"];
}

- (NSDate *)createdAt {
    NSNumber *createdAtInSeconds = [self.underlyingDictionary valueForKeyPath:@"createdAt"];
    return [NSDate dateWithTimeIntervalSince1970:[createdAtInSeconds unsignedIntegerValue]];
}

#pragma mark - User
- (NSString *)userFirstName {
    return [self.underlyingDictionary valueForKeyPath:@"user.firstName"];
}

- (NSString *)userLastName {
    return [self.underlyingDictionary valueForKeyPath:@"user.lastName"];
}

#pragma mark - Venue
- (HSFoursquareVenue *)venue {
    NSDictionary *venueDict = [self.underlyingDictionary valueForKeyPath:@"venue"];
    if (venueDict != nil) {
        return [[HSFoursquareVenue alloc] initWithDictionary:venueDict];
    } else {
        return nil;
    }
}

#pragma mark - NSObject Overriding
- (NSString *)description {
    return [NSString stringWithFormat:@"\n%@ %@ (%@) \n%@\n%@", self.userFirstName, self.userLastName, self.createdAt,
            self.canonicalUrl, self.text];
}

@end
