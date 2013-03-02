//
//  HSBloodDonationEvent.h
//  HSBloodDonationEvent
//
//  Created by Sergey Seroshtan on 19.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSBloodRemoteEvent.h"

#import "HSBloodDonationType.h"

/**
 * This class provides information about donor's blood donation event.
 */
@interface HSBloodDonationEvent : HSBloodRemoteEvent

/**
 * Type of blood donation.
 */
@property (nonatomic, assign) HSBloodDonationType bloodDonationType;

/**
 * Calculates and returns array of HSFinishRestEvent objects, which provide information about dates when user can
 *      plans his next blood donation.
 */
- (NSArray *)getFinishRestEvents;

/// @name Schedule local notifications
/**
 * Schedules local notification to ask user about done (undone) blood donation.
 */
- (void)scheduleConfirmationLocalNotification;

@end
