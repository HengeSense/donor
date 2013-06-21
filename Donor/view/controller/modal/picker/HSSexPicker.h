//
//  HSSexPicker.h
//  BloodDonor
//
//  Created by Sergey Seroshran on 30.03.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSPickerModal.h"
#import "HSSexType.h"

/**
 * Picker for selection person sex.
 */
@interface HSSexPicker : HSPickerModal

/// @name Selection properties
/**
 * Contains last selected value of 'sex'. This property is changed only if user taps "Готово" button.
 */
@property (nonatomic, assign, readonly) HSSexType sex;

/// @name UI presenters
/**
 * Shows sex picker with initial sex value.
 */
- (void)showWithSex:(HSSexType)sex completion:(HSPickerCompletion)completion;

/// @name Action handlers
/**
 * If user taps button "Готово", [HSSexPicker selectedSex] property will change it's value.
 */
- (IBAction)doneButtonClicked: (id)sender;

/**
 * If user taps button "Отмена", [HSSexPicker selectedSex] property will not change it's value.
 */
- (IBAction)cancelButtonClicked: (id)sender;

/**
 * Handle taps on sex radio buttons.
 */
- (IBAction)sexButtonClicked:(id)sender;

@end
