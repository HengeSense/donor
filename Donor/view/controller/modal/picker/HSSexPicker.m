//
//  HSSexPicker.h
//  BloodDonor
//
//  Created by Sergey Seroshran on 30.03.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//


#import "HSSexPicker.h"
#import "Common.h"
#import <Parse/Parse.h>

@interface HSSexPicker ()

/// Button with tag 0 - HSSexType_Mail.
@property (nonatomic, weak) IBOutlet UIButton *maleButton;
/// Button with tag 1 - HSSexType_Femail.
@property (nonatomic, weak) IBOutlet UIButton *femaleButton;
/// Removing readonly restriction.
@property (nonatomic, assign, readwrite) HSSexType sex;
/// UI string representation of male sex.
@property (weak, nonatomic) IBOutlet UILabel *maleLabel;
/// UI string representation of female sex.
@property (weak, nonatomic) IBOutlet UILabel *femaleLabel;

@end

@implementation HSSexPicker

#pragma mark - UI lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureUI];
}

#pragma mark - UI presenter
- (void)showWithSex:(HSSexType)sex completion:(HSPickerCompletion)completion {
    self.sex = sex;
    [self showWithCompletion:completion];
}

#pragma mark - Action handlers
- (IBAction)doneButtonClicked:(id)sender {
    [self hideWithDone:YES];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self hideWithDone:NO];
}


- (IBAction)sexButtonClicked:(id)sender
{
    NSInteger sexTag = [sender tag];
    [self checkTagToSexConformation:sexTag];
    self.sex = sexTag;
    [self updateUIWithSex:self.sex];
}

#pragma - Private
#pragma - UI configuration
- (void)configureUI {
    [self updateUIWithSex:self.sex];
}

- (void)updateUIWithSex:(HSSexType)sex
{
    switch (sex) {
        case HSSexType_Mail:
            self.maleButton.selected = YES;
            self.femaleButton.selected = NO;
            [self.maleButton setImage:[UIImage imageNamed:@"radioButtonSelected.png"]
                             forState:UIControlStateHighlighted];
            [self.femaleButton setImage:[UIImage imageNamed:@"radioButtonNotSelected.png"]
                               forState:UIControlStateHighlighted];
            self.maleLabel.textColor = [UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1];
            self.femaleLabel.textColor = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1];
            break;
            
        case HSSexType_Femail:
            self.maleButton.selected = NO;
            self.femaleButton.selected = YES;
            [self.maleButton setImage:[UIImage imageNamed:@"radioButtonNotSelected.png"]
                             forState:UIControlStateHighlighted];
            [self.femaleButton setImage:[UIImage imageNamed:@"radioButtonSelected.png"]
                               forState:UIControlStateHighlighted];
            self.maleLabel.textColor = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1];
            self.femaleLabel.textColor = [UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1];
            break;
    }
}

#pragma mark - Precondition check
- (void)checkTagToSexConformation:(NSInteger)tag {
    switch (tag) {
        case HSSexType_Mail:
        case HSSexType_Femail:
            break;
        default:
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                    reason:@"Selected sex button tag is not conforms to HSSexType values set." userInfo:nil];
            break;
    }
}


@end
