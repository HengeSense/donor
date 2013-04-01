//
//  HSBloodTypePicker.m
//  Donor
//
//  Created by Sergey Seroshtan on 30.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSBloodTypePicker.h"

@interface HSBloodTypePicker ()

@property (nonatomic, assign, readwrite) HSBloodGroupType bloodGroup;
@property (nonatomic, assign, readwrite) HSBloodRhType bloodRh;

@end

@implementation HSBloodTypePicker

#pragma mark - UI life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureUI];
}

#pragma mark - UI presentation
- (void)showWithBloodGroup:(HSBloodGroupType)bloodGroup bloodRh:(HSBloodRhType)bloodRh
                completion:(HSPickerCompletion)completion {
    self.bloodGroup = bloodGroup;
    self.bloodRh = bloodRh;
    [self showWithCompletion:completion];
}

#pragma mark - UI actions
- (IBAction)doneButtonClicked:(id)sender {
    [self hideWithDone:YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self hideWithDone:NO];
}

- (IBAction)bloodGroupButtonClicked:(id)sender {
    NSInteger bloodGroupTag = [sender tag];
    [self checkTagToBloodGroupConformation:bloodGroupTag];
    self.bloodGroup = bloodGroupTag;
    [self updateUIWithBloodGroup:self.bloodGroup];
}

- (IBAction)bloodRhButtonClicked:(id)sender {
    NSInteger bloodRhTag = [sender tag];
    [self checkTagToBloodRhConformation:bloodRhTag];
    self.bloodRh = bloodRhTag;
    [self updateUIWithBloodRh:self.bloodRh];
}

#pragma mark - Private
#pragma mark - UI configuration
- (void)configureUI {
    [self updateUIWithBloodGroup:self.bloodGroup];
    [self updateUIWithBloodRh:self.bloodRh];
}

- (void)updateUIWithBloodGroup:(HSBloodGroupType)bloodGroup {
    NSArray *bloodGroupButtons =
            @[self.buttonBloodGroupO, self.buttonBloodGroupA, self.buttonBloodGroupB, self.buttonBloodGroupAB];
    NSArray *bloodGroupLabels =
            @[self.labelBloodBloodGroupO, self.labelBloodGroupA, self.labelBloodGroupB, self.labelBloodGroupAB];
    
    if ([bloodGroupButtons count] != [bloodGroupLabels count]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                reason:@"Array of blood goup buttons and labels should be equal." userInfo:nil];
    }
    
    for (NSUInteger pos = 0; pos < [bloodGroupButtons count]; ++pos) {
        UIButton *groupButton = (UIButton *)bloodGroupButtons[pos];
        UILabel *groupLabel = (UILabel *)bloodGroupLabels[pos];
        BOOL selected = [groupButton tag] == bloodGroup;
        [self changeButton:groupButton toSelected:selected];
        [self changeLabel:groupLabel toSelected:selected];
    }
}

- (void)updateUIWithBloodRh:(HSBloodRhType)bloodRh {
    NSArray *bloodRhButtons = @[self.buttonBloodRhP, self.buttonBloodRhN];
    NSArray *bloodRhLabels = @[self.labelBloodRhP, self.labelBloodRhN];
    
    if ([bloodRhButtons count] != [bloodRhLabels count]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                reason:@"Array of blood Rh buttons and labels should be equal." userInfo:nil];
    }
    
    for (NSUInteger pos = 0; pos < [bloodRhButtons count]; ++pos) {
        UIButton *rhButton = (UIButton *)bloodRhButtons[pos];
        UILabel *rhLabel = (UILabel *)bloodRhLabels[pos];
        BOOL selected = [rhButton tag] == bloodRh;
        [self changeButton:rhButton toSelected:selected];
        [self changeLabel:rhLabel toSelected:selected];
    }
}

- (void)changeButton:(UIButton *)button toSelected:(BOOL)selected {
    button.selected = selected;
    if (selected) {
        [button setImage:[UIImage imageNamed:@"radioButtonSelected.png"] forState:UIControlStateHighlighted];
    } else {
        [button setImage:[UIImage imageNamed:@"radioButtonNotSelected.png"] forState:UIControlStateHighlighted];
    }

}

- (void)changeLabel:(UILabel *)label toSelected:(BOOL)selected {
    if (selected) {
        label.textColor = [UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1];
    } else {
        label.textColor = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1];
    }
}

#pragma mark - Precondition check
- (void)checkTagToBloodGroupConformation:(NSInteger)tag {
    switch (tag) {
        case HSBloodGroupType_O:
        case HSBloodGroupType_A:
        case HSBloodGroupType_B:
        case HSBloodGroupType_AB:
            break;
        default:
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                    reason:@"Specified tag is not conforms to HSBloodGroupType values set." userInfo:nil];
            break;
    }
}

- (void)checkTagToBloodRhConformation:(NSInteger)tag {
    switch (tag) {
        case HSBloodRhType_Positive:
        case HSBloodRhType_Negative:
            break;
        default:
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                    reason:@"Specified tag is not conforms to HSBloodRhType values set." userInfo:nil];
            break;
    }
}

@end
