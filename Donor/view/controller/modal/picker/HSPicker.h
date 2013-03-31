//
//  HSPicker.h
//  Donor
//
//  Created by Sergey Seroshtan on 30.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSModalViewController.h"

/// @name Types definition
typedef void(^HSPickerCompletion)(BOOL isDone);

/**
 * This class provides basic functionality to all pickers.
 */
@interface HSPicker : HSModalViewController

/// @name UI presenter
/**
 * Shows picker view and configures completion block.
 */
- (void)showWithCompletion:(HSPickerCompletion)completion;

/**
 * Hides picker view end invokes completion block, if it was specified in [HSPicker showWithCompletion:] method.
 */
- (void)hideWithDone:(BOOL)isDone;

@end
