//
//  HSNewsViewController.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 11.04.2013
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MWFeedItem;

@interface HSNewsViewController : UIViewController <UIWebViewDelegate>

/// @name Initialization
- (id)initWithNewsFeedItem:(MWFeedItem *)newsFeedItem;

/// @name UI properties
@property (nonatomic, weak) IBOutlet UIWebView *newsBodyWebView;

@end
