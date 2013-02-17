//
//  HSAddressPicker.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 04.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSModalViewController.h"

@interface HSAddressPicker : HSModalViewController

/**
 * Currently selected address.
 */
@property (nonatomic, strong) NSString *selectedAddress;

/**
 * Show HSAddressPicker view over the specified view.
 *     And hides it when user taps "Готово" or "Отмена" button.
 *
 * @param completion block of code, invoked before view will completely disapeared
 */
- (void)showWithCompletion: (void(^)(BOOL isDone))completion;

/**
 * If user taps button "Готово", bloodDonationType property will change it's value.
 */
- (IBAction)doneButtonClicked: (id)sender;

/**
 * If user taps button "Отмена", bloodDonationType property will not change it's value.
 */
- (IBAction)cancelButtonClicked: (id)sender;

@end
