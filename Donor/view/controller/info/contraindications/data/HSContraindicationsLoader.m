//
//  HSContraindicationsLoader.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 04.12.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSContraindicationsLoader.h"
#import "HSContraindication.h"

static NSString * const kContraindicationsFileName = @"contraindications";
static NSString * const kContraindicationsFileType = @"json";
static NSString * const kContraindicationsKey_Absolute = @"absolute";
static NSString * const kContraindicationsKey_Temporary = @"temporary";

@interface HSContraindicationsLoader ()
@property (nonatomic, strong, readwrite) NSArray *absolute;
@property (nonatomic, strong, readwrite) NSArray *temporary;
@end

@implementation HSContraindicationsLoader

#pragma mark - Data loading/selection
- (void)loadDataWithCompletion:(void (^)(BOOL, NSError *))completion {
    NSString *contraindicationsFilePath = [[NSBundle mainBundle] pathForResource:kContraindicationsFileName
                                                                          ofType:kContraindicationsFileType];
    NSError *fileReadError = nil;
    NSData *contraindicationsJson = [NSData dataWithContentsOfFile:contraindicationsFilePath
            options:NSDataReadingMappedAlways error:&fileReadError];
    if (fileReadError) {
        completion(NO, fileReadError);
        return;
    }
    
    NSError *serializationError = nil;
    NSDictionary *contraindications = [NSJSONSerialization JSONObjectWithData:contraindicationsJson
            options:NSJSONReadingMutableContainers error:&serializationError];

    if (serializationError) {
        completion(NO, serializationError);
    } else {
        self.absolute = [self buildContraindicationsFromRawData:
                [contraindications objectForKey:kContraindicationsKey_Absolute]];
        self.temporary = [self buildContraindicationsFromRawData:
                [contraindications objectForKey:kContraindicationsKey_Temporary]];
        completion(YES, nil);
    }
}

- (NSArray *)buildContraindicationsFromRawData:(NSArray *)rawContraindications {
    NSMutableArray *contraindications = [[NSMutableArray alloc] initWithCapacity:rawContraindications.count];
    for (NSDictionary *rawContraindication in rawContraindications) {
        [contraindications addObject:[[HSContraindication alloc] initWithDictionary:rawContraindication]];
    }
    return contraindications;
}
@end
