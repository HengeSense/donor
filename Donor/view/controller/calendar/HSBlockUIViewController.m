//
//  HSBlockUIViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 11.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSBlockUIViewController.h"

@interface HSBlockUIViewController ()
@property (weak, nonatomic) IBOutlet UILabel *blockMessageLabel;
@end

@implementation HSBlockUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.blockMessageLabel.text = self.blockMessage;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.blockMessageLabel.text = self.blockMessage;
}

@end
