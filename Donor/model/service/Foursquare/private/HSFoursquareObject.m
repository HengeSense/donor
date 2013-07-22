//
//  HSFoursquareObject.m
//  Donor
//
//  Created by Sergey Seroshtan on 22.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSFoursquareObject.h"

@implementation HSFoursquareObject

- (NSString *)uid {
    return [self.underlyingDictionary valueForKeyPath:@"id"];
}

@end
