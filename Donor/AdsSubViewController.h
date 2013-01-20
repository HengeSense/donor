//
//  AdsSubViewController.h
//  BloodDonor
//
//  Created by Vladimir Noskov on 26.07.12.
//  Updated by Sergey Seroshtan on 17.01.13
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFObject;

@protocol IAdsSelectListener <NSObject>

- (void) adSelected:(PFObject *)selectedAd;

@end


@interface AdsSubViewController : UIViewController

@property (nonatomic, weak) id delegate;

@end
