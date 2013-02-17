//
//  HSRecommendationsLoader.m
//  Donor
//
//  Created by Sergey Seroshtan on 20.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSRecommendationsLoader.h"
#import "HSRecommendation.h"


static NSString * const kRecommendationsFileName = @"recommendations";
static NSString * const kRecommendationsFileType = @"json";

@interface HSRecommendationsLoader ()

@property (nonatomic, strong, readwrite) NSArray *recommendations;

@end

@implementation HSRecommendationsLoader

- (void)loadDataWithCompletion:(void (^)(BOOL, NSError *))completion {

    NSString *recommendationsFilePath = [[NSBundle mainBundle] pathForResource:kRecommendationsFileName
                                                                          ofType:kRecommendationsFileType];
    NSError *fileReadError = nil;
    NSData *recommendationsJson = [NSData dataWithContentsOfFile:recommendationsFilePath
            options:NSDataReadingMappedAlways error:&fileReadError];
    if (fileReadError) {
        completion(NO, fileReadError);
        return;
    }
    
    NSError *serializationError = nil;
    NSDictionary *recommendations = [NSJSONSerialization JSONObjectWithData:recommendationsJson
            options:NSJSONReadingMutableContainers error:&serializationError];
    
    if (serializationError) {
        completion(NO, serializationError);
    } else {
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:recommendations.count];
        for (NSDictionary *rawRecommendation in recommendations) {
            [result addObject:[[HSRecommendation alloc] initWithDictionary:rawRecommendation]];
        }
        self.recommendations = result;
        completion(YES, nil);
    }
}

@end
