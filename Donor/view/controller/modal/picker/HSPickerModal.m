//
//  HSPickerModal.m
//  Donor
//
//  Created by Sergey Seroshtan on 30.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSPickerModal.h"

@interface HSPickerModal ()

@property (nonatomic, copy) HSPickerCompletion completion;

@end

@implementation HSPickerModal

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
