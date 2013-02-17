//
//  UIView+HSLayoutManager.h
//  Donor
//
//  Created by Sergey Seroshtan on 21.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HSLayoutManager)

/**
 * Adjusts view frame to locate in parent view between navigation bar and tab bar.
 */
- (void)adjustAsContentView;


/**
 * Adjusts view frame to locate in parent view between navigation bar, additional navigation bar and tab bar.
 */
- (void)adjustAsContentViewIncludeAdditionalNavigationBar:(UIView *)additionalNavBar;

/**
 *
 */
- (void)shiftFromScreenToBottom;

/**
 *
 */
- (void)shiftToScreenFromBottom;

/**
 *
 */
- (void)shiftFromScreenToTop;

/**
 *
 */
- (void)shiftToScreenFromTop;
@end
