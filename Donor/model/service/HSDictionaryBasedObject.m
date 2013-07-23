//
//  HSDictionaryBasedObject.m
//  Donor
//
//  Created by Sergey Seroshtan on 22.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSDictionaryBasedObject.h"

@interface HSDictionaryBasedObject ()

@property (nonatomic, strong, readwrite) NSDictionary *underlyingDictionary;

@end

@implementation HSDictionaryBasedObject

- (id)initWithDictionary:(NSDictionary *)underlyingDictionary {
    THROW_IF_ARGUMENT_NIL(underlyingDictionary);
    if ((self = [super init]) == nil) {
        return nil;
    }
    self.underlyingDictionary = underlyingDictionary;
    return self;
}

+ (NSArray *)arrayWithUnderlyingDictionaries:(NSArray *)dictionaries {
    THROW_IF_ARGUMENT_NIL(dictionaries);
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:dictionaries.count];
    for (NSDictionary *dict in dictionaries) {
        [result addObject:[(HSDictionaryBasedObject *)([self alloc]) initWithDictionary:dict]];
    }
    return result;
}

@end
