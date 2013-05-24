//
//  HSStationInfo.m
//  Donor
//
//  Created by Sergey Seroshtan on 19.05.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSStationInfo.h"
#import "NSObject+NSCodingSupportForProperties.h"

#import "NSString+HSUtils.h"

@implementation HSStationInfo

- (id)initWithRemoteStation:(PFObject *)station {
    self = [super init];
    if (self) {
        [self updateWithRemoteStation:station];
    }
    return self;
}

- (void)updateWithRemoteStation:(PFObject *)station {
    THROW_IF_ARGUMENT_NIL(station);
    self.objectId = station.objectId;
    self.createdAt = station.createdAt;
    self.updatedAt = station.updatedAt;
    for (NSString *key in [station allKeys]) {
        NSString *setterSelectorName = [NSString stringWithFormat:@"set%@:", [key capitalizedFirstLetterString]];
        SEL setterSelector = NSSelectorFromString(setterSelectorName);
        if ([self respondsToSelector:setterSelector]) {
            [self setValue:[station objectForKey:key] forKey:key];
        }
    }
    self.distance = nil;
}


@end
