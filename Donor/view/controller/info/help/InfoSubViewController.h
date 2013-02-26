//
//  InfoSubViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 30.07.12.
//  Updated by Sergey Seroshtan on 26.02.13.
//  Copyright (c) 2012 HintSolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IInfoSubViewListener <NSObject>

- (void) nextViewSelected:(int)viewId;

@end

@interface InfoSubViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *contactsScrollView;

@property (assign, nonatomic) id delegate;

- (IBAction)contraindicationListButtonPressed:(id)sender;
- (IBAction)recommendationsButtonPressed:(id)sender;

@end
