//
//  NSObject+NSCodingSupportForProperties.m
//  Donor
//
//  Created by Sergey Seroshtan on 24.05.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "NSObject+NSCodingSupportForProperties.h"
#import <objc/runtime.h>

static NSString * const kPFObjectPersistentKey_AllPropertiesName = @"kPFObjectPersistentKey_AllPropertiesName";

@implementation NSObject (NSCodingSupportForProperties)

- (void)encodeWithCoder:(NSCoder *)encoder {
    // Encode first className, objectId and All Keys
    [encoder encodeObject:[self allPropertiesName] forKey:kPFObjectPersistentKey_AllPropertiesName];
    for (NSString * key in [self allPropertiesName]) {
        [encoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [[self.class alloc] init];
    if (self) {
        NSArray * allPropertiesName = [decoder decodeObjectForKey:kPFObjectPersistentKey_AllPropertiesName];
        for (NSString * propertyName in allPropertiesName) {
            id propertyValue = [decoder decodeObjectForKey:propertyName];
            if (propertyValue) {
                [self setValue:propertyValue forKey:propertyName];
            }
        }
    }
    return self;
}

#pragma mark - Private
- (NSArray *)allPropertiesName {
    unsigned int propertiesCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertiesCount);
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:propertiesCount];
    for (unsigned int i = 0; i < propertiesCount; ++i) {
    	objc_property_t property = properties[i];
    	const char *propertyNameC = property_getName(property);
    	if (propertyNameC) {
    		NSString *propertyName = [NSString stringWithCString:propertyNameC encoding:NSUTF8StringEncoding];
            [result addObject:propertyName];
    	}
    }
    free(properties);
    return result;
}

@end
