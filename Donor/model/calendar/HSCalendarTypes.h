//
//  HSCalendarTypes.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 19.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#ifndef BloodDonor_HSCalendarTypes_h
#define BloodDonor_HSCalendarTypes_h

/**
 * This enum type describes type of calendar day.
 */
typedef enum {
    HSDayType_Workday = 0,
    HSDayType_DayOff,
    HSDayType_AdditionalBloodDonationDay,
    HSDayType_Holiday
} HSCalendarDayType;


#endif
