//
//  HSBloodDonationType.c
//  BloodDonor
//
//  Created by Sergey Seroshtan on 03.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSBloodDonationEvent.h"

NSString* bloodDonationTypeToString(HSBloodDonationType bloodDonationType) {
    switch (bloodDonationType) {
        case HSBloodDonationType_Blood:
            return @"Цельная кровь";
        case HSBloodDonationType_Granulocytes:
            return @"Гранулоциты";
        case HSBloodDonationType_Plasma:
            return @"Плазма";
        case HSBloodDonationType_Platelets:
            return @"Тромбоциты";
        default:
            @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                           reason: @"Unknown blood donation type was specified." userInfo: nil];
    }
}
