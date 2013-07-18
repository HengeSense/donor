//
//  HSViewUtils.h
//  Donor
//
//  Created by Sergey Seroshtan on 14.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSViewUtils : NSObject

+ (void)setFrameForLabel:(UILabel *)oneLabel atYcoord:(float)y;
+ (void)setFrameForLabel:(UILabel *)oneLabel atYcoordChange:(float *)y;

+ (void)setFrameForView:(UIView *)oneView atYcoord:(float)y;
+ (void)setFrameForView:(UIView *)oneView atYcoordChange:(float *)y;

@end
