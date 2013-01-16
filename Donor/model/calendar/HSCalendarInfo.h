//
//  HSCalendarInfo.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 11.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This protocol provides information about calendar statistics and plans.
 */
@protocol HSCalendarInfo <NSObject>

@required

/**
 * Returns next planed blood donation date.
 */
- (NSDate *)nextBloodDonationDate;


/**
 * Returns done blood donation event total number.
 */
- (NSUInteger)numberOfDoneBloodDonationEvents;

@end
