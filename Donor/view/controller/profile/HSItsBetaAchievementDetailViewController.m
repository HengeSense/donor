//
//  HSItsBetaAchievementDetailViewController.m
//  Donor
//
//  Created by Alexander Trifonov on 4/9/13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSItsBetaAchievementDetailViewController.h"

#import "MBProgressHUD.h"

#import "ItsBeta.h"

@interface HSItsBetaAchievementDetailViewController () {
    MBProgressHUD* _progressHud;
}

- (void)refresh;

@end

@implementation HSItsBetaAchievementDetailViewController

- (void)setObjectID:(NSString *)objectID {
    if(_objectID != objectID) {
        _objectID = objectID;
        
        ItsBetaProject* project = [ItsBeta projectByName:@"donor"];
        [ItsBeta synchronizePlayerWithProject:project];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willPlayerSynchronize:) name:ItsBetaWillPlayerSynchronize object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayerSynchronize:) name:ItsBetaDidPlayerSynchronize object:nil];
    }
    return self;
}

- (void) willPlayerSynchronize:(NSNotification*)notification {
    if(_progressHud == nil) {
        _progressHud = [MBProgressHUD showHUDAddedTo:[self view] animated:YES];
    }
}

- (void) didPlayerSynchronize:(NSNotification*)notification {
    [self refresh];
    if(_progressHud != nil) {
        [_progressHud hide:YES];
        _progressHud = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setNameLabel:nil];
    [self setBadgeView:nil];
    [super viewDidUnload];
}

- (void)refresh {
    ItsBetaObject* object = [ItsBeta objectById:_objectID];
    ItsBetaProject* project = [ItsBeta projectByName:@"donor"];
    ItsBetaObjectTemplate* objectTemplate = [ItsBeta objectTemplateById:[object objectTemplateId] byProject:project];
    [[self nameLabel] setText:[[objectTemplate internal] valueAtName:@"display_name"]];
    [[self badgeView] setImage:[[objectTemplate image] data]];
}

- (IBAction)onVisitItsBetaWeb:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itsbeta.com"]];
}

@end
