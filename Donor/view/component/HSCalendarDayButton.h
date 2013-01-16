//
//  HSCalendarDayButton.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 21.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSEvent.h"

/**
 * This class represents day button in HSCalendar class object.
 *     And provides convinient properties and methods for it's configuration.
 */
@interface HSCalendarDayButton : UIButton

/// @name Info properties
@property (nonatomic, strong, readonly) NSDate *date;

/// @name Initializtion methods

/**
 * Initialize button for use in [HSCalendar] object.
 * @param frame button frame.
 * @param date date in calendar, which button object is represented.
 *
 * @note Parameter date is also used to set button title and to check correspond [HSEvent sheduledDate]
 *           in the added calendar events.
 */
- (id)initWithFrame: (CGRect)frame date: (NSDate *)date;

/// @name HSEvent objects management methods

/**
 * Adds and displays specified event.
 */
- (void)addEvent: (HSEvent *)event;

/**
 * Removes specified event from the button and it's view representation.
 */
- (void)removeEvent: (HSEvent *)event;

/**
 * Returns all calendar day events.
 */
- (NSSet *)allEvents;

@end
