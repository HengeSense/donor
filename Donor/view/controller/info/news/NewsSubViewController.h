//
//  NewsSubViewController.h
//  BloodDonor
//
//  Created by Vladimir Noskov on 26.07.12.
//  Updated by Sergey Seroshtan on 20.01.13
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MWFeedItem;

@protocol INewsSelectListener <NSObject>

- (void) newSelected:(MWFeedItem *)selectedNews;

@end

@interface NewsSubViewController : UIViewController

@property (nonatomic, weak) id<INewsSelectListener> delegate;

@end
