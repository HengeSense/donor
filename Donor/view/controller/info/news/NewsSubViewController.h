//
//  NewsSubViewController.h
//  BloodDonor
//
//  Created by Vladimir Noskov on 26.07.12.
//  Updated by Sergey Seroshtan on 20.01.13
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol INewsSelectListener <NSObject>

- (void) newSelected:(PFObject *)selectedNew;

@end

@interface NewsSubViewController : UIViewController

@property (nonatomic, weak) id delegate;

@end
