//
//  HSTimetableModifierEvent.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 19.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSEvent.h"

#import "HSCalendarTypes.h"

/**
 * This event allows modify default value of the calendar.
 * For example saturday is day off, but blood center decided to make this day workday,
 *     so creating this event overrides default calendar behaviour and user can schedule blood donation event
 *     on this day. And vise versa some holiday may be instead of work day.
 */
@interface HSTimetableModifierEvent : HSEvent

/**
 * This value overrides default calendar day type.
 */
@property (nonatomic, assign) HSCalendarDayType dayType;

@end
