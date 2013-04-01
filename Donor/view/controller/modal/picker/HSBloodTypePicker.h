//
//  HSBloodTypePicker.h
//  Donor
//
//  Created by Sergey Seroshtan on 30.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSPicker.h"
#import "HSBloodType.h"

@interface HSBloodTypePicker : HSPicker

/// @name UI properties
@property (nonatomic, weak) IBOutlet UIButton *buttonBloodGroupO;
@property (nonatomic, weak) IBOutlet UIButton *buttonBloodGroupA;
@property (nonatomic, weak) IBOutlet UIButton *buttonBloodGroupB;
@property (nonatomic, weak) IBOutlet UIButton *buttonBloodGroupAB;
@property (nonatomic, weak) IBOutlet UIButton *buttonBloodRhN;
@property (nonatomic, weak) IBOutlet UIButton *buttonBloodRhP;

@property (nonatomic, weak) IBOutlet UILabel *labelBloodBloodGroupO;
@property (nonatomic, weak) IBOutlet UILabel *labelBloodGroupA;
@property (nonatomic, weak) IBOutlet UILabel *labelBloodGroupB;
@property (nonatomic, weak) IBOutlet UILabel *labelBloodGroupAB;
@property (nonatomic, weak) IBOutlet UILabel *labelBloodRhN;
@property (nonatomic, weak) IBOutlet UILabel *labelBloodRhP;

/// @name Selection properties
@property (nonatomic, assign, readonly) HSBloodGroupType bloodGroup;
@property (nonatomic, assign, readonly) HSBloodRhType bloodRh;

/// @name UI actions
- (IBAction)doneButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)bloodGroupButtonClicked:(id)sender;
- (IBAction)bloodRhButtonClicked:(id)sender;

/// @name UI presentation
- (void)showWithBloodGroup:(HSBloodGroupType)bloodGroup bloodRh:(HSBloodRhType)bloodRh
        completion:(HSPickerCompletion)completion;

@end
