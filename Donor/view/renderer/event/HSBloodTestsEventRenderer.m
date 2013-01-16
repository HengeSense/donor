//
//  HSBloodTestsEventRenderer.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 22.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSBloodTestsEventRenderer.h"

@implementation HSBloodTestsEventRenderer

-(UIView *)renderViewInBounds: (CGRect)bounds {
    UIImage *resultImage = [UIImage imageNamed: @"icon_test_plan.png"];
    if (resultImage == nil) {
        @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                       reason: @"calendarScheduledTestIcon.png image not found" userInfo: nil];
    }
    UIImageView *resultImageView = [[UIImageView alloc] initWithImage: resultImage];
    // Locate in left bottom corner
    CGFloat x = 0;
    CGFloat y = bounds.size.height - resultImageView.bounds.size.height;
    resultImageView.frame = CGRectMake(x, y, resultImage.size.width, resultImage.size.height);
    return resultImageView;
}

@end
