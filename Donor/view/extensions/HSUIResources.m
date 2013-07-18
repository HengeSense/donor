//
//  HSUIResources.m
//  Donor
//
//  Created by Sergey Seroshtan on 18.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSUIResources.h"

@implementation HSUIResources

+ (UIFont *)baseTextFont {
    static UIFont *font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont systemFontOfSize:13];
    });
    return font;
}

+ (UIColor *)baseTextColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:203./255 green:178./255 blue:163./255 alpha:1.];
    });
    return color;
}

+ (UIFont *)titleLabelFont {
    static UIFont *font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont boldSystemFontOfSize:13];
    });
    return font;
}

+ (UIColor *)titleLabelColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:203./255 green:178./255 blue:163./255 alpha:1.];
    });
    return color;
}

+ (UIFont *)specialTitleLabelFont {
    return [self titleLabelFont];
}

+ (UIColor *)specialTitleLabelColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:223./255 green:141./255 blue:75./255 alpha:1.];
    });
    return color;
}

@end
