//
//  HSMessageView.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 10.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSMessageView.h"

@implementation HSMessageView

+ (void)showWithMessage:(NSString *)message {
    [self showWithTitle:@"" message:message];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message {
    [self showWithTitle:title message:message cancelButtonTitle:@"Ok"];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil
                                              cancelButtonTitle:cancelButtonTitle otherButtonTitles: nil];
    [errorView show];
}

@end
