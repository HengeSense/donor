//
//  HSModalViewController.h
//  Donor
//
//  Created by Sergey Seroshtan on 17.02.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HSModalAnimationDirection_Top = 0, // view appears from bottom
    HSModalAnimationDirection_Bottom   // view appears from top (default)
} HSModalAnimationDirection;

/**
 * This class is used as superclass for all modal views.
 */
@interface HSModalViewController : UIViewController

/// @name Configuration properties.
/**
 * Defines show/hide animation duration.
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 * Defines show/hide animation direction.
 */
@property (nonatomic, assign) HSModalAnimationDirection animationDirection;

/**
 * Shows modal view.
 */
- (void)showModal;

/**
 * Hides modal view
 */
- (void)hideModal;

@end
