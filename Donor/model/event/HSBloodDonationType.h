//
//  HSBloodDonationType.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 19.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

/**
 * This enum type describes different possible types of blood donations.
 */
typedef enum {
    HSBloodDonationType_Blood = 0,
    HSBloodDonationType_Platelets,
    HSBloodDonationType_Plasma,
    HSBloodDonationType_Granulocytes
} HSBloodDonationType;

NSString *bloodDonationTypeToString(HSBloodDonationType bloodDonationType);

NSString *bloodDonationTypeToFinishRestEventMessage(HSBloodDonationType bloodDobationType);
