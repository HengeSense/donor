//
//  HSContraindicationsViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 04.12.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSContraindicationsViewController.h"

#import "HSContraindicationsLoader.h"
#import "HSAbsoluteContraindicationsDataSource.h"
#import "HSTempContraindicationsDataSource.h"
#import "UIView+HSLayoutManager.h"

#import "MBProgressHUD.h"


@interface HSContraindicationsViewController ()
@property (strong, nonatomic) HSAbsoluteContraindicationsDataSource *absoluteContraindicationsDataSource;
@property (strong, nonatomic) HSTempContraindicationsDataSource *tempContraindicationsDataSource;
@end

@implementation HSContraindicationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.absoluteContraindicationsDataSource = [[HSAbsoluteContraindicationsDataSource alloc] init];
        self.tempContraindicationsDataSource = [[HSTempContraindicationsDataSource alloc] init];
    }
    return self;
}

- (void)configureUI {
    self.title = @"Противопоказания";
}

- (void)loadContraindicationsDataSources {
    HSContraindicationsLoader *dataLoader = [[HSContraindicationsLoader alloc] init];
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [dataLoader loadDataWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            self.absoluteContraindicationsDataSource =
                    [[HSAbsoluteContraindicationsDataSource alloc] initWithData: dataLoader.absolute];
            self.tempContraindicationsDataSource =
                    [[HSTempContraindicationsDataSource alloc] initWithData: dataLoader.temporary];
        }
        [progressHud hide:YES];
        [self absoluteButtonClicked:self.absoluteButton];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    [self loadContraindicationsDataSources];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.contraindicationsTableView adjustAsContentViewIncludeAdditionalNavigationBar:self.topTabBarView];
}

- (IBAction)absoluteButtonClicked:(id)sender {
    self.contraindicationsTableView.dataSource = self.absoluteContraindicationsDataSource;
    self.contraindicationsTableView.delegate = self.absoluteContraindicationsDataSource;
    self.absoluteButton.selected = YES;
    self.tempButton.selected = NO;
    [self.contraindicationsTableView reloadData];
}

- (IBAction)tempButtonClicked:(id)sender {
    self.contraindicationsTableView.dataSource = self.tempContraindicationsDataSource;
    self.contraindicationsTableView.delegate = self.tempContraindicationsDataSource;
    self.absoluteButton.selected = NO;
    self.tempButton.selected = YES;
    [self.contraindicationsTableView reloadData];
}

- (void)viewDidUnload {
    [self setTopTabBarView:nil];
    [super viewDidUnload];
}
@end
