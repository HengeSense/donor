//
//  EnterNameViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IEnterNameListener <NSObject>

- (void) nameEntered:(NSString *)name; 

@end


@interface EnterNameViewController : UIViewController

@property(assign, nonatomic) id delegate;

- (IBAction)cancelClick:(id)sender;
- (IBAction)doneClick:(id)sender;

@end
