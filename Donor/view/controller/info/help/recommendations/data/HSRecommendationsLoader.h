//
//  HSRecommendationsLoader.h
//  Donor
//
//  Created by Sergey Seroshtan on 20.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This class is used for loading blood donation recommendations.
 */
@interface HSRecommendationsLoader : NSObject

/**
 * Loads recommendations
 */
- (void)loadDataWithCompletion:(void(^)(BOOL success, NSError *error))completion;

/**
 * Recommendations (HSRecommendation class objects).
 */
@property (nonatomic, strong, readonly) NSArray *recommendations;

@end
