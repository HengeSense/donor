//
//  SelectSexViewControllerViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ISexListener <NSObject>

- (void)sexChanged:(NSString *)sex; 

@end

@interface SelectSexViewController : UIViewController

@property(assign, nonatomic) id delegate;

- (IBAction)cancelClick:(id)sender;
- (IBAction)doneClick:(id)sender;

@end
