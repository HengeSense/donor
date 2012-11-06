//
//  HSDayHoliydayEvent.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 06.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSDayPurposeModifierEvent.h"

/**
 * This event type describes calendar's holiday.
 */
@interface HSDayHolidayEvent : HSDayPurposeModifierEvent

/// @name Properties
/**
 * Contains full localized description of holiday represenred by this event.
 */
@property (nonatomic, strong) NSString *holidayDescription;

@end
