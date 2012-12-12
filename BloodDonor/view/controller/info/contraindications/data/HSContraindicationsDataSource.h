//
//  HSContraindicationsDataSource.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 04.12.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This class provides common behavior for table data filtering.
 * Note UITableViewDataSource should be implemented in subclasses.
 */
@interface HSContraindicationsDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

/// @name Initialization
/**
 * Initialize object with array of HSContraindications class objects.
 */
- (id)initWithData:(NSArray *)data;

/// @name Data properties
/**
 * Array of loaded HSContraindications class objects (HSContraindications).
 */
@property (strong, nonatomic, readonly) NSArray *data;

/// @name Data filtration.
/**
 * Abstract.
 * Filters data provided to UITableView by specified value.
 */
- (void)filterDataByValue:(NSString *)filter;

/**
 * Abstract.
 * Clears data filter.
 */
- (void)clearFilter;

@end
