//
//  HSBloodDonationEventRenderer.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 22.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSBloodDonationEventRenderer.h"

#import "HSBloodDonationType.h"
#import "HSBloodDonationEvent.h"

@implementation HSBloodDonationEventRenderer

-(UIView *)renderViewInBounds: (CGRect)bounds {
    HSBloodDonationEvent *bloodDonationEvent = (HSBloodDonationEvent *)self.event;
    UIImage *resultImage = bloodDonationEvent.isDone ?
            [self imageForDoneBloodDonationType: bloodDonationEvent.bloodDonationType] :
            [self imageForBloodDonationType: bloodDonationEvent.bloodDonationType];
    if (resultImage == nil) {
        @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                       reason: @"Image for blood donation event is not found" userInfo: nil];
    }
    UIImageView *resultImageView = [[UIImageView alloc] initWithImage: resultImage];
    // Locate in left bottom corner
    CGFloat x = 0;
    CGFloat y = bounds.size.height - resultImageView.bounds.size.height;
    resultImageView.frame = CGRectMake(x, y, resultImage.size.width, resultImage.size.height);
    return resultImageView;
}


-(UIImage *)imageForBloodDonationType: (HSBloodDonationType)bloodDonationType {
    switch (bloodDonationType) {
        case HSBloodDonationType_Blood:
            return [UIImage imageNamed: @"icon_blood_plan.png"];
        case HSBloodDonationType_Plasma:
            return [UIImage imageNamed: @"icon_plasma_plan.png"];
        case HSBloodDonationType_Platelets:
            return [UIImage imageNamed: @"icon_plateletes_plan.png"];
        case HSBloodDonationType_Granulocytes:
            return [UIImage imageNamed: @"icon_granulocytes_plan.png"];
        default:
            @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                           reason: @"Unknown blood donation type" userInfo: nil];
    }
}

-(UIImage *)imageForDoneBloodDonationType: (HSBloodDonationType)bloodDonationType {
    switch (bloodDonationType) {
        case HSBloodDonationType_Blood:
            return [UIImage imageNamed: @"icon_blood_check.png"];
        case HSBloodDonationType_Plasma:
            return [UIImage imageNamed: @"icon_plasma_check.png"];
        case HSBloodDonationType_Platelets:
            return [UIImage imageNamed: @"icon_plateletes_check.png"];
        case HSBloodDonationType_Granulocytes:
            return [UIImage imageNamed: @"icon_granulocytes_check.png"];
        default:
            @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                           reason: @"Unknown blood donation type" userInfo: nil];
    }
}

@end
