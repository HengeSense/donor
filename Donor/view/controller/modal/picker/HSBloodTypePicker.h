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
@property (weak, nonatomic) IBOutlet UIButton *buttonBloodGroupUnknown;

@property (nonatomic, weak) IBOutlet UIButton *buttonBloodRhN;
@property (nonatomic, weak) IBOutlet UIButton *buttonBloodRhP;
@property (weak, nonatomic) IBOutlet UIButton *buttonBloodRhUnknown;

@property (weak, nonatomic) IBOutlet UILabel *labelBloodGroup;
@property (nonatomic, weak) IBOutlet UILabel *labelBloodGroupO;
@property (nonatomic, weak) IBOutlet UILabel *labelBloodGroupA;
@property (nonatomic, weak) IBOutlet UILabel *labelBloodGroupB;
@property (nonatomic, weak) IBOutlet UILabel *labelBloodGroupAB;
@property (weak, nonatomic) IBOutlet UILabel *labelBloodGroupUnknown;

@property (nonatomic, weak) IBOutlet UILabel *labelBloodRh;
@property (nonatomic, weak) IBOutlet UILabel *labelBloodRhN;
@property (nonatomic, weak) IBOutlet UILabel *labelBloodRhP;
@property (weak, nonatomic) IBOutlet UILabel *labelBloodRhUnknown;

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
