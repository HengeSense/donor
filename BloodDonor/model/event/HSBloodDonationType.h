//
//  HSBloodDonationType.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 19.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#ifndef BloodDonor_HSBloodDonationType_h
#define BloodDonor_HSBloodDonationType_h

/**
 * This enum type describes different possible types of blood donations.
 */
typedef enum {
    BloodDonationType_Blood = 0,
    BloodDonationType_Platelets,
    BloodDonationType_Plasma,
    BloodDonationType_Granulocytes
} HSBloodDonationType;

#endif
