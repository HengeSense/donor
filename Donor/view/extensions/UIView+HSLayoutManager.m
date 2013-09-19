//
//  UIView+HSLayoutManager.m
//  Donor
//
//  Created by Sergey Seroshtan on 21.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "UIView+HSLayoutManager.h"

static const NSUInteger kNavigationBarHeight = 44;
static const NSUInteger kBottomTabBarHeight = 55;

@implementation UIView (HSLayoutManager)

- (void)adjustAsContentView {
    self.frame = [self defineContentFrameWithAdditionalTopHeight:0];
}

- (void)adjustAsContentViewIncludeAdditionalNavigationBar:(UIView *)additionalNavBar {
    self.frame = [self defineContentFrameWithAdditionalTopHeight:additionalNavBar.bounds.size.height];
}

- (void)adjustViewWithOrigin:(CGPoint)origin {
    NSUInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSUInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGRect contentViewFrame = CGRectZero;
    contentViewFrame.origin = origin;
    contentViewFrame.size.height = screenHeight - kNavigationBarHeight - origin.y - kBottomTabBarHeight;
    contentViewFrame.size.width = screenWidth - origin.x;
    self.frame = contentViewFrame;
}

- (void)adjustAsContentViewWithHeaderHeight:(CGFloat)headerHeight footerHeight:(CGFloat)footerHeight {
    NSUInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGRect contentViewFrame = CGRectZero;
    contentViewFrame.origin.y = headerHeight;
    contentViewFrame.size.height = screenHeight - headerHeight - footerHeight;
    self.frame = contentViewFrame;
}

- (CGRect)defineContentFrameWithAdditionalTopHeight:(NSUInteger)additionalHeight {
    NSUInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSUInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
        
    CGRect contentViewFrame = CGRectZero;
    contentViewFrame.origin.x = 0;
    contentViewFrame.origin.y = additionalHeight;
    contentViewFrame.size.height = screenHeight - kNavigationBarHeight - additionalHeight - kBottomTabBarHeight;
    contentViewFrame.size.width = screenWidth;
    return contentViewFrame;
}

- (void)shiftFromScreenToBottom {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect frame = self.frame;
    frame.origin.y = screenSize.height;
    self.frame = frame;
}

- (void)shiftToScreenFromBottom {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect frame = self.frame;
    frame.origin.y = screenSize.height - frame.size.height;
    self.frame = frame;
}

- (void)shiftFromScreenToTop {
    CGRect frame = self.frame;
    frame.origin.y = -frame.size.height;
    self.frame = frame;
}

- (void)shiftToScreenFromTop {
    CGRect frame = self.frame;
    frame.origin.y = 0;
    self.frame = frame;
}

- (void)moveFrameX:(CGFloat)xPos {
    CGRect frame = self.frame;
    frame.origin.x = xPos;
    self.frame = frame;
}

- (void)moveFrameY:(CGFloat)yPos {
    CGRect frame = self.frame;
    frame.origin.y = yPos;
    self.frame = frame;
}

- (void)changeFrameHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)changeFrameWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

@end
