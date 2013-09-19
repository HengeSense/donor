//
//  HSContraindicationCell.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 10.12.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSContraindicationCell.h"

static volatile UILabel *gTitleLabel = nil;
static volatile UILabel *gDetailsLabel = nil;

static const CGFloat kLabelMargin = 5.0f;
static const CGFloat kSeparationLineHeight = 2.0f;
static const CGFloat kIndentationWidthBase = 10.0f;


@implementation HSContraindicationCell

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize titleSize = [HSContraindicationCell calculateSizeFitToText:self.title.text font:self.title.font
            lineBreakMode:self.title.lineBreakMode indentation:self.indentationLevel];

    CGSize detailsSize = [HSContraindicationCell calculateSizeFitToText:self.details.text font:self.details.font
            lineBreakMode:self.details.lineBreakMode indentation:self.indentationLevel];
    
    CGRect titleFrame = self.title.frame;
    titleFrame.size = titleSize;

    const CGFloat indentationWidth = kIndentationWidthBase * self.indentationLevel;
    titleFrame.origin.x += indentationWidth;
    self.title.frame = titleFrame;
    
    CGRect detailsFrame = CGRectMake(titleFrame.origin.x, titleFrame.origin.y + titleFrame.size.height + kLabelMargin,
                                     detailsSize.width, detailsSize.height);
    self.details.frame = detailsFrame;
    
    CGRect separationLineFrame = self.separationLine.frame;
    separationLineFrame.origin.x += indentationWidth;
    separationLineFrame.size.width -= indentationWidth;
    self.separationLine.frame = separationLineFrame;
    
    if (self.indentationLevel > 0) {
        [self.asterixLabel removeFromSuperview];
        [self.dashLabel removeFromSuperview];
        
        UILabel *indentationLabel = self.indentationLevel % 2 == 0 ? self.asterixLabel : self.dashLabel;
        CGRect indentationLabelFrame = indentationLabel.frame;
        indentationLabelFrame.origin.x = self.title.frame.origin.x - indentationLabelFrame.size.width;
        indentationLabelFrame.origin.y = self.title.frame.origin.y;
        indentationLabel.frame = indentationLabelFrame;
        [self addSubview:indentationLabel];
    }
}

+ (void)initialize {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HSContraindicationCell" owner:self options:nil];
    HSContraindicationCell *cell = [nib objectAtIndex:0];
    gTitleLabel = cell.title;
    gDetailsLabel = cell.details;
}

+ (CGFloat)calculateHightForTitle:(NSString *)title details:(NSString *)details indentation:(NSUInteger)indentation {
    CGFloat result = 7.0f;
    if (title != nil) {
        CGSize expectedTitleSize = [self calculateSizeFitToText:title font:gTitleLabel.font
                                                  lineBreakMode:gTitleLabel.lineBreakMode indentation:indentation];
        result += expectedTitleSize.height + kLabelMargin;
    }
    
    if (details != nil) {
        CGSize expectedDetailsSize = [self calculateSizeFitToText:details font:gDetailsLabel.font
                                                    lineBreakMode:gDetailsLabel.lineBreakMode indentation:indentation];
        result += expectedDetailsSize.height;
    }
    
    return result + kSeparationLineHeight;
}

+ (CGSize)calculateSizeFitToText:(NSString *)text font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode
                     indentation:(NSUInteger)indentation {
    CGFloat indentationWidth = kIndentationWidthBase * indentation;
    CGSize maximumLabelSize = CGSizeMake(290 - indentationWidth, 1000);
    if (text != nil) {
        return [text sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:lineBreakMode];
    } else {
        return CGSizeZero;
    }
}



@end
