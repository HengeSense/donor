//
//  HSBloodDonationEvent.m
//  HSBloodDonationEvent
//
//  Created by Sergey Seroshtan on 19.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSBloodDonationEvent.h"
#import "HSBloodRemoteEvent_Protected.h"
#import "HSBloodRemoteEvent+LocalNotification_Protected.h"

#import "HSModelCommon.h"
#import "HSFinishRestEvent.h"
#import "NSDate+HSCalendar.h"

#import <Parse/Parse.h>

static NSString * const kRemoteEventFields_BloodDonationType = @"delivery";
static const size_t kRemoteEventFields_BloodDonationType_Platelets = 0;
static const size_t kRemoteEventFields_BloodDonationType_Plasma = 1;
static const size_t kRemoteEventFields_BloodDonationType_Whole = 2;
static const size_t kRemoteEventFields_BloodDonationType_Granulocytes = 3;

static const size_t REST_PERIODS_TABLE[4][4] =
{
    /*HSBloodDonationType_Blood*/       {60, 30, 30, 30},
    /*HSBloodDonationType_Platelets*/   {30, 30, 30, 30},
    /*HSBloodDonationType_Plasma*/      {14, 14, 14, 14},
    /*HSBloodDonationType_Granulocytes*/{30, 30, 30, 360}
};

@implementation HSBloodDonationEvent

#pragma mark - Getters / Setters bridget to PFObject class object.
- (HSBloodDonationType)bloodDonationType {
    size_t bloodDonationType = [[self.remoteEvent objectForKey: kRemoteEventFields_BloodDonationType] intValue];
    switch (bloodDonationType) {
        case kRemoteEventFields_BloodDonationType_Platelets:
            return HSBloodDonationType_Platelets;
        case kRemoteEventFields_BloodDonationType_Plasma:
            return HSBloodDonationType_Plasma;
        case kRemoteEventFields_BloodDonationType_Whole:
            return HSBloodDonationType_Blood;
        case kRemoteEventFields_BloodDonationType_Granulocytes:
            return HSBloodDonationType_Granulocytes;
        default:
            @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                           reason: @"Unexpected type of blood donation on remote server" userInfo: nil];
    }
}

- (void)setBloodDonationType: (HSBloodDonationType)bloodDonationType {
    size_t remoteBloodDonationTypeCode = SIZE_T_MAX;
    switch (bloodDonationType) {
        case HSBloodDonationType_Platelets:
            remoteBloodDonationTypeCode = kRemoteEventFields_BloodDonationType_Platelets;
            break;
        case HSBloodDonationType_Plasma:
            remoteBloodDonationTypeCode = kRemoteEventFields_BloodDonationType_Plasma;
            break;
        case HSBloodDonationType_Blood:
            remoteBloodDonationTypeCode = kRemoteEventFields_BloodDonationType_Whole;
            break;
        case HSBloodDonationType_Granulocytes:
            remoteBloodDonationTypeCode = kRemoteEventFields_BloodDonationType_Granulocytes;
            break;
        default:
            @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                           reason: @"Unexpected type of bloof donation" userInfo: nil];
    }
    [self.remoteEvent setObject: [NSNumber numberWithUnsignedInteger: remoteBloodDonationTypeCode]
                         forKey: kRemoteEventFields_BloodDonationType];
}

- (NSArray *)getFinishRestEvents {
    NSCalendar *systemCalendar = [NSCalendar currentCalendar];
    int dateComponentsUnits = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *beginingDayComponents =
            [systemCalendar components: dateComponentsUnits fromDate: self.scheduleDate];
    
    NSDate *beginingDay = [systemCalendar dateFromComponents: beginingDayComponents];
    
    const size_t kSecondsInDay = 24 * 60 * 60;
    
    NSUInteger restPeriodForBlood = REST_PERIODS_TABLE[self.bloodDonationType][HSBloodDonationType_Blood];
    NSDate *finishRestDateForBlood = [NSDate dateWithTimeInterval: (restPeriodForBlood) * kSecondsInDay
                                                        sinceDate: beginingDay];
    HSFinishRestEvent *finishRestEventForBlood = [[HSFinishRestEvent alloc] init];
    finishRestEventForBlood.bloodDonationType = HSBloodDonationType_Blood;
    finishRestEventForBlood.scheduleDate = finishRestDateForBlood;
    
    NSUInteger restPeriodForGranulocytes = REST_PERIODS_TABLE[self.bloodDonationType][HSBloodDonationType_Granulocytes];
    NSDate *finishRestDateForGranulocytes = [NSDate dateWithTimeInterval: (restPeriodForGranulocytes) * kSecondsInDay
                               sinceDate: beginingDay];
    HSFinishRestEvent *finishRestEventForGranulocytes = [[HSFinishRestEvent alloc] init];
    finishRestEventForGranulocytes.bloodDonationType = HSBloodDonationType_Granulocytes;
    finishRestEventForGranulocytes.scheduleDate = finishRestDateForGranulocytes;

    NSUInteger restPeriodForPlasma = REST_PERIODS_TABLE[self.bloodDonationType][HSBloodDonationType_Plasma];
    NSDate *finishRestDateForPlasma = [NSDate dateWithTimeInterval: (restPeriodForPlasma) * kSecondsInDay
                                                         sinceDate: beginingDay];
    HSFinishRestEvent *finishRestEventForPlasma = [[HSFinishRestEvent alloc] init];
    finishRestEventForPlasma.bloodDonationType = HSBloodDonationType_Plasma;
    finishRestEventForPlasma.scheduleDate = finishRestDateForPlasma;
    
    NSUInteger restPeriodForPlateletes = REST_PERIODS_TABLE[self.bloodDonationType][HSBloodDonationType_Platelets];
    NSDate *finishRestDateForPlatelets = [NSDate dateWithTimeInterval: (restPeriodForPlateletes) * kSecondsInDay
                                                            sinceDate: beginingDay];
    HSFinishRestEvent *finishRestEventForPlatelets = [[HSFinishRestEvent alloc] init];
    finishRestEventForPlatelets.bloodDonationType = HSBloodDonationType_Platelets;
    finishRestEventForPlatelets.scheduleDate = finishRestDateForPlatelets;
    
    return [NSArray arrayWithObjects: finishRestEventForBlood, finishRestEventForPlasma, finishRestEventForPlatelets,
            finishRestEventForGranulocytes, nil];
}

#pragma mark - Protected interface implementation
- (NSString *)alertBodyForReminderLocalNotificationWithMinutesLeft:(NSUInteger)minutesLeft {
    if (minutesLeft < 60) {
        return [NSString stringWithFormat:@"Через %u мин. у Вас запланирована кроводача: %@.", minutesLeft,
                [bloodDonationTypeToString(self.bloodDonationType) lowercaseString]];
    } else {
        return [NSString stringWithFormat:@"Через %u ч. %u мин. у Вас запланирована кроводача: %@.",
                (NSUInteger)(minutesLeft / 60), minutesLeft % 60,
                [bloodDonationTypeToString(self.bloodDonationType) lowercaseString]];
    }
}

- (NSString *)alertBodyForConfirmationLocalNotification {
    return @"Вы сдавали сегодня кровь?";
}

#pragma mark - NSCopying protocol implementation
- (id)copyWithZone:(NSZone *)zone {
    HSBloodDonationEvent *event = [super copyWithZone:zone];
    event.bloodDonationType = self.bloodDonationType;
    return event;
}

@end
