//
//  HSBloodDonationTypePicker.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 02.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSBloodDonationType.h"


@interface HSBloodDonationTypePicker : UIViewController

/**
 * Contains picked value.
 */
@property (nonatomic, assign, readonly) HSBloodDonationType bloodDonationType;

/**
 * Show HSBloodDonationTypePicker view over the specified view.
 *     And hides it when user taps "Готово" or "Отмена" button.
 *
 * @param containerView parent container view
 * @param bloodDonationType initial type of blood donation
 * @param completion block of code, invoked before view will completely disapeared
 */
- (void)showInView: (UIView *)containerView bloodDonationType: (HSBloodDonationType) bloodDonationType
        completion: (void(^)(BOOL isDone))completion;

/**
 * If user taps button "Готово", bloodDonationType property will change it's value.
 */
- (IBAction)doneButtonClicked: (id)sender;

/**
 * If user taps button "Отмена", bloodDonationType property will not change it's value.
 */
- (IBAction)cancelButtonClicked: (id)sender;

@end
