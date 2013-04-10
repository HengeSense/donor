//
//  UIView+HSSubviewManagement.m
//  Donor
//
//  Created by Sergey Seroshtan on 08.04.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "UIView+HSSubviewManagement.h"

@implementation UIView (HSSubviewManagement)

- (void)removeSubviews {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

@end
