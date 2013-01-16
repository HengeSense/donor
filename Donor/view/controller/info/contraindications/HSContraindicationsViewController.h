//
//  HSContraindicationsViewController.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 04.12.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSContraindicationsDataSource;

@interface HSContraindicationsViewController : UIViewController

/// @name Buttons
@property (weak, nonatomic) IBOutlet UIButton *absoluteButton;
@property (weak, nonatomic) IBOutlet UIButton *tempButton;

/// @name Views
@property (weak, nonatomic) IBOutlet UIView *searchViewContainer;
@property (weak, nonatomic) IBOutlet UITableView *contraindicationsTableView;

/// @name UI actions
- (IBAction)absoluteButtonClicked:(id)sender;
- (IBAction)tempButtonClicked:(id)sender;
@end
