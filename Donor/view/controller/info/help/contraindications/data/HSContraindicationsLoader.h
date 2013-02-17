//
//  HSContraindicationsLoader.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 04.12.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSAbsoluteContraindicationsDataSource;
@class HSTempContraindicationsDataSource;

/**
 * This class provides loading blood donation contraindications from Parse.com service operation
 *     and correspond UITableViewDataSource objects: (for absoulute and temp contraindications).
 *
 */
@interface HSContraindicationsLoader : NSObject

/// @name Data loading/selection
/**
 * Loads data from the Parse.com.
 * Precondition [PFUser currentUser] should exist.
 */
- (void)loadDataWithCompletion:(void(^)(BOOL success, NSError *error))completion;

/**
 * Absolute contraindications (HSContraindication class objects).
 */
@property (nonatomic, strong, readonly) NSArray *absolute;

/**
 * Temporary contraindications (HSContraindications class objects).
 */
@property (nonatomic, strong, readonly) NSArray *temporary;

@end
