//
//  AdsSubViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 26.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol IAdsSelectListener <NSObject>

- (void) adSelected:(PFObject *)selectedAd;

@end


@interface AdsSubViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIView *indicatorView;
    NSArray *contentArray;
    NSMutableArray *stationTitleArray;
}

@property (nonatomic, retain) id delegate;

- (void)callbackWithResult:(NSArray *)result error:(NSError *)error;

@end
