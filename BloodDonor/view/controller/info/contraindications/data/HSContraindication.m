//
//  HSContraindication.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 10.12.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSContraindication.h"

static NSString * const kContraindicationsKey_Title = @"title";
static NSString * const kContraindicationsKey_Level = @"level";
static NSString * const kContraindicationsKey_Children = @"children";
static NSString * const kContraindicationsKey_Rehabilitation = @"rehabilitation";

@interface HSContraindication ()
@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSNumber *level;
@property (nonatomic, strong, readwrite) NSArray *children;
@property (nonatomic, strong, readwrite) NSString *rehabilitation;
@end

@implementation HSContraindication

- (id)initWithDictionary:(NSDictionary *)contraindication {
    self = [super init];
    if (self) {
        self.title = [contraindication objectForKey:kContraindicationsKey_Title];
        self.level = [contraindication objectForKey:kContraindicationsKey_Level];
        self.rehabilitation = [contraindication objectForKey:kContraindicationsKey_Rehabilitation];
        
        NSArray *children = [contraindication objectForKey:kContraindicationsKey_Children];
        NSMutableArray *childrenAsObjects = [[NSMutableArray alloc] init];
        for (NSDictionary *child in children) {
            [childrenAsObjects addObject: [[HSContraindication alloc] initWithDictionary:child]];
        }
        self.children = childrenAsObjects;
    }
    return self;
}

@end
