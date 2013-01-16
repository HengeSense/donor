//
//  InfoViewController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsSubViewController.h"
#import "AdsSubViewController.h"
#import "InfoSubViewController.h"

@interface InfoViewController : UIViewController <UINavigationControllerDelegate, INewsSelectListener, IAdsSelectListener, IInfoSubViewListener>
{
    IBOutlet UIButton *adsButton;
    IBOutlet UIButton *newsButton;
    IBOutlet UIButton *infoButton;
    
    UIViewController *infoSubViewController;
    UIScrollView *infoSubView;
}

@property (nonatomic, retain, readwrite) IBOutlet UIScrollView *infoSubView;
@property (nonatomic, retain, readwrite) UIViewController *infoSubViewController;
@property (nonatomic, retain, readwrite) NSArray *segmentedViewControllers;

- (void)didChangeSegmentControl:(UIButton *)button;
- (void)selectTab:(int)index;
- (IBAction)tabSelected:(id)sender;
- (NSArray *)segmentedViewControllerContent;

@end
