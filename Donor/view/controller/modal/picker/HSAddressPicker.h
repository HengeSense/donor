//
//  HSAddressPicker.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 04.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSPicker.h"

@interface HSAddressPicker : HSPicker

/**
 * Currently selected address.
 */
@property (nonatomic, strong) NSString *selectedAddress;

/**
 * If user taps button "Готово", bloodDonationType property will change it's value.
 */
- (IBAction)doneButtonClicked: (id)sender;

/**
 * If user taps button "Отмена", bloodDonationType property will not change it's value.
 */
- (IBAction)cancelButtonClicked: (id)sender;

@end
