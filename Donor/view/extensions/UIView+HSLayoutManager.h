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
 * Moves view's frame under the screen bottom line.
 */
- (void)shiftFromScreenToBottom;

/**
 * Moves view's frame over the screen bottom line.
 */
- (void)shiftToScreenFromBottom;

/**
 * Moves view's frame over the screen top line.
 */
- (void)shiftFromScreenToTop;

/**
 * Moves view's frame under the screen top line.
 */
- (void)shiftToScreenFromTop;

/**
 * Moves frame to new 'x' position.
 */
-(void)moveFrameX:(CGFloat)xPos;

/**
 * Moves frame to new 'y' position.
 */
-(void)moveFrameY:(CGFloat)yPos;

/**
 * Changes frame width.
 */
- (void)changeFrameWidth:(CGFloat)width;

/**
 * Changes frame height.
 */
- (void)changeFrameHeight:(CGFloat)height;
@end
