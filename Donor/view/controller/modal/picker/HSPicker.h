//
//  HSPicker.h
//  Donor
//
//  Created by Sergey Seroshtan on 18.05.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/// @name Types definition
typedef void(^HSPickerCompletion)(BOOL isDone);

/**
 * This protocol specifies functionality for all pickers.
 */
@protocol HSPicker <NSObject>

/// @name UI presenter
/**
 * Shows picker view and configures completion block.
 */
- (void)showWithCompletion:(HSPickerCompletion)completion;

@optional
/// @name Private usage only
/**
 * Hides picker view end invokes completion block, if it was specified in [HSPicker showWithCompletion:] method.
 */
- (void)hideWithDone:(BOOL)isDone;

@end
