//
//  HSFinishRestEvent.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 19.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSNotificationEvent.h"

#import "HSBloodDonationType.h"

@interface HSFinishRestEvent : HSNotificationEvent

/**
 * Blood donation type which are allowed after the donor's rest.
 */
@property (nonatomic, assign) HSBloodDonationType bloodDonationType;

@end
