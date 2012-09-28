//
//  SelectBloodGroupViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IBloodGroupListener <NSObject>

- (void) bloodGroupChanged:(NSString *)bloodGroup; 

@end

@interface SelectBloodGroupViewController : UIViewController
{
    IBOutlet UIButton *buttonOI;
    IBOutlet UIButton *buttonAII;
    IBOutlet UIButton *buttonBIII;
    IBOutlet UIButton *buttonABIV;
    IBOutlet UIButton *buttonRhN;
    IBOutlet UIButton *buttonRhP;
    
    IBOutlet UILabel *labelOI;
    IBOutlet UILabel *labelAII;
    IBOutlet UILabel *labelBIII;
    IBOutlet UILabel *labelABIV;
    IBOutlet UILabel *labelRhN;
    IBOutlet UILabel *labelRhP;
    
    NSMutableArray *bloodGroupButtonsArray;
    NSMutableArray *bloodGroupLablesArray;
    
    NSString *group;
    NSString *rh;
    
    int bloodGroupInt;
    int bloodRHInt;
}

@property(assign, nonatomic) id delegate;

- (IBAction)cancelClick:(id)sender;
- (IBAction)doneClick:(id)sender;
- (IBAction)bloodGroupSelected:(id)sender;
- (IBAction)rhSelected:(id)sender;

- (void)setSelectedBloodGroupButton:(UIButton *)button;
- (void)setSelectedBloodRhButton:(UIButton *)button;

@end
