//
//  NewsSubViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 26.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol INewsSelectListener <NSObject>

- (void) newSelected:(PFObject *)selectedNew;

@end

@interface NewsSubViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *contentArray;
    UIView *indicatorView;
}

@property (nonatomic, retain) id delegate;

- (void)callbackWithResult:(NSArray *)result error:(NSError *)error;

@end
