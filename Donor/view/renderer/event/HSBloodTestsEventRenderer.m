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
    UIImage *resultImage = [self eventImage];
    if (resultImage == nil) {
        @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                       reason: @"Image for blood tests event is not found" userInfo: nil];
    }
    UIImageView *resultImageView = [[UIImageView alloc] initWithImage: resultImage];
    // Locate in left bottom corner
    CGFloat x = 0;
    CGFloat y = bounds.size.height - resultImageView.bounds.size.height;
    resultImageView.frame = CGRectMake(x, y, resultImage.size.width, resultImage.size.height);
    return resultImageView;
}

- (UIImage *)eventImage {
    return [UIImage imageNamed: @"icon_test_plan.png"];
}

- (NSString *)eventShortDescription {
    return @"Запланирован анализ";
}

@end
