//
//  HSMessageView.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 10.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This class is used to unify error showing entry point.
 */
@interface HSMessageView : NSObject

/**
 * Shows error message with specifed message's text and 'Ok' cancel button.
 */
+ (void)showWithMessage:(NSString *)message;

/**
 * Shows error message with specifed message's title and text and 'Ok' cancel button.
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message;

/**
 * Shows error message with specifed message's title, text and cancel button title.
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;

@end
