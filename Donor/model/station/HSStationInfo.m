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

- (NSString *)shortName {
    if (![self.name isNotEmpty]) {
        return nil;
    }
    
    NSString *shortNameStringPattern = @"[^\"«']*[\"«']([^\"«»']+)";
    
    NSError *regexError = nil;
    NSRegularExpression *shortNameStringRegex = [NSRegularExpression regularExpressionWithPattern:shortNameStringPattern
            options:NSRegularExpressionCaseInsensitive error:&regexError];
    
    if (regexError) {
        NSLog(@"Error in regex: %@", [regexError localizedDescription]);
        return nil;
    }
    
    NSTextCheckingResult *match =
            [shortNameStringRegex firstMatchInString:self.name options:0 range:NSMakeRange(0, self.name.length)];
    if (match) {
        return [self.name substringWithRange:[match rangeAtIndex:1]];
    }
    
    return nil;
}

- (NSString *)shortNameOrName {
    NSString *result = self.shortName;
    if (result == nil) {
        return self.name;
    }
    return result;
}

@end
