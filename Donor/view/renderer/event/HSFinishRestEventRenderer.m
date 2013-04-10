//
//  HSFinishRestEventRenderer.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 22.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSFinishRestEventRenderer.h"
#import "HSFinishRestEvent.h"
#import "HSBloodDonationType.h"

@implementation HSFinishRestEventRenderer

-(UIView *)renderViewInBounds:(CGRect)bounds {
    HSFinishRestEvent *finishRestEvent = (HSFinishRestEvent *)self.event;
    
    if (finishRestEvent.bloodDonationType == HSBloodDonationType_Granulocytes) {
        // Rendering granulocytes
        return [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
    }

    UIImage *resultImage = [self eventImage];
    UIImageView *resultImageView = [[UIImageView alloc] initWithImage:resultImage];
    
    // Locate in right side
    CGFloat x = bounds.size.width - resultImage.size.width;
    CGFloat y = resultImage.size.height *
            [self getYOffsetCoefficientForBloodDonationType:finishRestEvent.bloodDonationType];
    
    resultImageView.frame = CGRectMake(x, y, resultImage.size.width, resultImage.size.height);
    return resultImageView;
}

- (UIImage *)eventImage {
    HSFinishRestEvent *finishRestEvent = (HSFinishRestEvent *)self.event;
    return [self imageForBloodDonationType:finishRestEvent.bloodDonationType];
}

-(UIImage *)imageForBloodDonationType:(HSBloodDonationType)bloodDonationType {
    switch (bloodDonationType) {
        case HSBloodDonationType_Blood:
            return [UIImage imageNamed:@"icon_blood.png"];
        case HSBloodDonationType_Plasma:
            return [UIImage imageNamed:@"icon_plasma.png"];
        case HSBloodDonationType_Platelets:
            return [UIImage imageNamed:@"icon_plateletes.png"];
        case HSBloodDonationType_Granulocytes:
            return [UIImage imageNamed:@"icon_granulocytes.png"];
        default:
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"Unknown blood donation type" userInfo:nil];
    }
}

- (NSUInteger)getYOffsetCoefficientForBloodDonationType:(HSBloodDonationType)bloodDonationType {
    switch (bloodDonationType) {
        case HSBloodDonationType_Blood:
            return 0;
        case HSBloodDonationType_Plasma:
            return 2;
        case HSBloodDonationType_Platelets:
            return 1;
        case HSBloodDonationType_Granulocytes:
        default:
            return 0;
    }
}

- (NSString *)eventShortDescription {
    HSFinishRestEvent *finishRestEvent = (HSFinishRestEvent *)self.event;
    NSString *result = @"Можно сдать ";
    switch (finishRestEvent.bloodDonationType) {
        case HSBloodDonationType_Blood:
            return [result stringByAppendingString:@"цельную кровь"];
        case HSBloodDonationType_Plasma:
            return [result stringByAppendingString:@"плазму"];
        case HSBloodDonationType_Platelets:
            return [result stringByAppendingString:@"тромбоциты"];
        case HSBloodDonationType_Granulocytes:
            return [result stringByAppendingString:@"гранулоциты"];
        default:
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"Unknown blood donation type" userInfo:nil];
    }
}
@end
