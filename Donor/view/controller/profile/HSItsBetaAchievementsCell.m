//
//  HSItsBetaAchievementsCell.m
//  Donor
//
//  Created by Alexander Trifonov on 4/5/13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSItsBetaAchievementsCell.h"
#import  <QuartzCore/CALayer.h>

#import "ItsBeta.h"

UIImage* convertImageToGrayScale(UIImage* image) {
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGContextDrawImage(context, imageRect, [image CGImage]);
    CGImageRef grayImage = CGBitmapContextCreateImage(context);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, nil, kCGImageAlphaOnly);
    CGContextDrawImage(context, imageRect, [image CGImage]);
    CGImageRef mask = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *grayScaleImage = [UIImage imageWithCGImage:CGImageCreateWithMask(grayImage, mask) scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(grayImage);
    CGImageRelease(mask);
    return grayScaleImage;
}

UIImage* createImageThumbnail(UIImage* image, CGSize size) {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
    UIImage* thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbnail;
}

@implementation HSItsBetaAchievementsCell

- (void) setObjectTemplate:(ItsBetaObjectTemplate*)objectTemplate {
    if(_objectTemplate != objectTemplate) {
        _objectTemplate = objectTemplate;
        
        CGRect bound = [[self imageView] bounds];
        [[self imageView] setImage:createImageThumbnail([[_objectTemplate image] data], bound.size)];
        [[self nameLable] setText:[[_objectTemplate internal] valueAtName:@"display_name"]];
    }
}

- (void) setIsExists:(BOOL)isExists {
    if(_isExists != isExists) {
        _isExists = isExists;
    }
    if(_isExists == NO) {
        [[self imageView] setImage:convertImageToGrayScale([[self imageView] image])];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self == nil) {
    }
    return self;
}

@end
