//
//  HSCalendarInfoViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 15.08.12.
//  Changed by Sergey Seroshtan on 31.03.13.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSCalendarInfoViewController.h"
#import "UIView+HSLayoutManager.h"

@interface HSCalendarInfoViewController ()

@end

@implementation HSCalendarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Календарь";
    
    self.scrollView.contentSize = self.contentView.frame.size;
    [self.scrollView addSubview:self.contentView];
}

- (void)vieWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.scrollView adjustAsContentView];
}

@end
