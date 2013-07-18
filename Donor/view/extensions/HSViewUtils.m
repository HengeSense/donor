//
//  HSViewUtils.m
//  Donor
//
//  Created by Sergey Seroshtan on 14.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSViewUtils.h"

static const CGFloat kVerticalPadding = 3.0;

@implementation HSViewUtils

+ (void)setFrameForLabel:(UILabel *)oneLabel atYcoord:(float)y {
    CGSize labelSize = [oneLabel.text sizeWithFont:oneLabel.font
            constrainedToSize:CGSizeMake(oneLabel.bounds.size.width, CGFLOAT_MAX) lineBreakMode:oneLabel.lineBreakMode];
    CGRect labelFrame = oneLabel.frame;
    labelFrame.origin.y = y;
    labelFrame.size.height = labelSize.height;
    oneLabel.frame = labelFrame;
}

+ (void)setFrameForLabel:(UILabel *)oneLabel atYcoordChange:(float *)y {
    [self setFrameForLabel:oneLabel atYcoord:(*y)];
    (*y) += (oneLabel.bounds.size.height + kVerticalPadding);
}

+ (void)setFrameForView:(UIView *)oneView atYcoord:(float)y {
    CGRect viewFrame = oneView.frame;
    viewFrame.origin.y = y;
    oneView.frame = viewFrame;
}

+ (void)setFrameForView:(UIView *)oneView atYcoordChange:(float *)y {
    [self setFrameForView:oneView atYcoord:(*y)];
    (*y) += (oneView.bounds.size.height + kVerticalPadding);
}

@end
