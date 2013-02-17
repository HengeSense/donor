//
//  HSRecommendation.h
//  Donor
//
//  Created by Sergey Seroshtan on 20.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This class encapsulates blood donation recommendatios.
 */
@interface HSRecommendation : NSObject

/**
 * Init class object with raw data that represents blood donation recommendations.
 */
- (id)initWithDictionary:(NSDictionary *)rawData;

/**
 * Group title for recommendations.
 */
@property (nonatomic, strong, readonly) NSString *title;

/**
 * String array with recommendations.
 */
@property (nonatomic, strong, readonly) NSArray *recommendations;

@end
