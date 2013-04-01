//
//  HSModalWithCompletionViewController.m
//  Donor
//
//  Created by Sergey Seroshtan on 30.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSPicker.h"

@interface HSPicker ()

@property (nonatomic, copy) HSPickerCompletion completion;

@end

@implementation HSPicker

- (void)showWithCompletion:(HSPickerCompletion)completion {
    self.completion = completion;
    [self showModal];
}

- (void)hideWithDone:(BOOL)isDone {
    if (self.completion != nil) {
        self.completion(isDone);
        self.completion = nil;
    }
    [self hideModal];
}

@end
