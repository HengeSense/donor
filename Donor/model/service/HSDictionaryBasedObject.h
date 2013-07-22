//
//  HSDictionaryBasedObject.h
//  Donor
//
//  Created by Sergey Seroshtan on 22.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+NSCodingSupportForProperties.h"

@interface HSDictionaryBasedObject : NSObject<NSCoding>

/// @name Initialization properties
@property (nonatomic, strong, readonly) NSDictionary *underlyingDictionary;

/// @name Initialization
- (id)initWithDictionary:(NSDictionary *)underlyingDictionary;

/// Factory creation
+ (NSArray *)arrayWithDictionaryBasedObjects:(NSArray *)dictionaries;

@end
