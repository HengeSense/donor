//
//  HSStationsPickerViewController.m
//  Donor
//
//  Created by Sergey Seroshtan on 18.05.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSStationsPickerViewController.h"

@interface HSStationsPickerViewController ()

@property (nonatomic, copy) HSPickerCompletion completion;

@end

@implementation HSStationsPickerViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

-(void)viewWillDisappear:(BOOL)animated {
    if ([self.rootNavigationController.viewControllers indexOfObject:self] == NSNotFound) {
        if (self.completion) {
            self.completion(YES);
        }
    }
    [super viewWillDisappear:animated];
}

#pragma mark - UIPicker
- (void)showWithCompletion:(HSPickerCompletion)completion {
    self.completion = completion;
    [self.rootNavigationController pushViewController:self animated:YES];
}

- (void)hideWithDone:(BOOL)isDone {
    [self.rootNavigationController popViewControllerAnimated:YES];
    if (self.completion) {
        self.completion(isDone);
    }
}

#pragma mark - UITableViewDelegate overriding
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Prevent actions from super class
}

#pragma mark - Private
#pragma mark - Configuration
- (void)configureUI {
    self.title = @"Выбор станции";
    [self configureNavigationBar];
}

- (void)configureNavigationBar {
    self.navigationItem.rightBarButtonItem = nil;
}

@end
