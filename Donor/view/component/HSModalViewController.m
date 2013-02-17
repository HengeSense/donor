//
//  HSModalViewController.m
//  Donor
//
//  Created by Sergey Seroshtan on 17.02.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSModalViewController.h"
#import "UIView+HSLayoutManager.h"

@interface HSModalViewController ()

/**
 * Window for modal view.
 */
@property (nonatomic, strong) UIWindow *overlayWindow;

/**
 * Stores old window object before modal view showing, to make possible to return key focus to it,
 *     when modal view will be dissmised.
 */
@property (nonatomic, strong) UIWindow *oldWindow;

@end

@implementation HSModalViewController

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.animationDuration = 0.3f;
        self.animationDirection = HSModalAnimationDirection_Bottom;
    }
    return self;
}

#pragma mark - Public methods
- (void)showModal {
    self.oldWindow = [[UIApplication sharedApplication] keyWindow];
    
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
    self.overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayWindow.windowLevel = UIWindowLevelAlert;
    self.overlayWindow.backgroundColor = [UIColor clearColor];
    self.overlayWindow.rootViewController = self;
    [self hideOverlayByShift:self.overlayWindow];
    [self.overlayWindow makeKeyAndVisible];
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        [self showOverlayByShift:self.overlayWindow];
    }];
}

- (void)hideModal {
    [UIView animateWithDuration:self.animationDuration animations:^{
    [self hideOverlayByShift:self.overlayWindow];
    } completion:^(BOOL finished) {
        if (!finished) {
            return;
        }
        self.overlayWindow.rootViewController = nil;
        self.overlayWindow = nil;
        [self.oldWindow makeKeyWindow];
    }];
}

#pragma mark - Utility
- (void)showOverlayByShift:(UIView *)overlay {
    THROW_IF_ARGUMENT_NIL(overlay, @"overlay view is not specified");
    switch (self.animationDirection) {
        case HSModalAnimationDirection_Top:
            [overlay shiftToScreenFromTop];
            break;
        case HSModalAnimationDirection_Bottom:
            [overlay shiftToScreenFromBottom];
            break;
        default:
            break;
    }
}

- (void)hideOverlayByShift:(UIView *)overlay {
    THROW_IF_ARGUMENT_NIL(overlay, @"overlay view is not specified");
    switch (self.animationDirection) {
        case HSModalAnimationDirection_Top:
            [overlay shiftFromScreenToTop];
            break;
        case HSModalAnimationDirection_Bottom:
            [overlay shiftFromScreenToBottom];
            break;
        default:
            break;
    }
}

@end
