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

@end
