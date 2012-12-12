//
//  HSContraindication.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 10.12.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This is value object class for blood donation contraindication.
 */
@interface HSContraindication : NSObject

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSNumber *level;
@property (nonatomic, strong, readonly) NSArray *children;
@property (nonatomic, strong, readonly) NSString *rehabilitation;

- (id)initWithDictionary:(NSDictionary *)contraindication;

@end
