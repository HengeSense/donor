//
//  HSItsBetaAchievementsViewController.m
//  Donor
//
//  Created by Alexander Trifonov on 4/3/13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSItsBetaAchievementsViewController.h"

#import "MBProgressHUD.h"

#import "ItsBeta.h"

@interface HSItsBetaAchievementsViewController () {
    MBProgressHUD* _progressHud;
    
    ItsBetaProject* _project;
    ItsBetaObjectTemplate* _objectTemplateInstall;
    ItsBetaObjectTemplate* _objectTemplateFirstBlood;
    ItsBetaObjectTemplate* _objectTemplateSecondBlood;
    NSMutableArray* _content;
    NSMutableArray* _contentExists;
    NSMutableArray* _contentAvailable;
}

@end

@implementation HSItsBetaAchievementsViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self != nil) {
        [self setTitle:@"Мои достижения"];
        
        _project = [ItsBeta projectByName:@"donor"];
        _objectTemplateInstall = [ItsBeta objectTemplateByName:@"donorfriend" byProject:_project];
        _objectTemplateFirstBlood = [ItsBeta objectTemplateByName:@"firstblood" byProject:_project];
        _objectTemplateSecondBlood = [ItsBeta objectTemplateByName:@"secondblood" byProject:_project];
        _content = [NSMutableArray array];
        _contentExists = [NSMutableArray array];
        [_content addObject:_contentExists];
        _contentAvailable = [NSMutableArray array];
        [_content addObject:_contentAvailable];
    }
    return self;
}

- (void) dealloc {
    _contentAvailable = nil;
    _contentExists = nil;
    _content = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willPlayerSynchronize:) name:ItsBetaWillPlayerSynchronize object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayerSynchronize:) name:ItsBetaDidPlayerSynchronize object:nil];
    
    [ItsBeta synchronizePlayerWithProject:_project];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:ItsBetaDidPlayerSynchronize];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:ItsBetaWillPlayerSynchronize];
    
    [self setTableView:nil];
    
    [super viewDidUnload];
}

#pragma mark - Notification

- (void) willPlayerSynchronize:(NSNotification*)notification {
    if(_progressHud == nil) {
        _progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    }

    [_contentExists removeAllObjects];
    [_contentAvailable removeAllObjects];
    [_contentAvailable addObject:_objectTemplateInstall];
    [_contentAvailable addObject:_objectTemplateFirstBlood];
    [_contentAvailable addObject:_objectTemplateSecondBlood];
    [_tableView reloadData];
}

- (void) didPlayerSynchronize:(NSNotification*)notification {
    [_contentAvailable removeAllObjects];
    if([[ItsBeta objectsWithObjectTemplate:_objectTemplateInstall] count] > 0) {
        [_contentExists addObject:_objectTemplateInstall];
    } else {
        [_contentAvailable addObject:_objectTemplateInstall];
    }
    if([[ItsBeta objectsWithObjectTemplate:_objectTemplateFirstBlood] count] > 0) {
        [_contentExists addObject:_objectTemplateFirstBlood];
    } else {
        [_contentAvailable addObject:_objectTemplateFirstBlood];
    }
    if([[ItsBeta objectsWithObjectTemplate:_objectTemplateSecondBlood] count] > 0) {
        [_contentExists addObject:_objectTemplateSecondBlood];
    } else {
        [_contentAvailable addObject:_objectTemplateSecondBlood];
    }
    
    [_tableView reloadData];
    
    if(_progressHud != nil) {
        [_progressHud hide:YES];
        _progressHud = nil;
    }
}

#pragma mark - Outlets

- (IBAction)openItsBetaWebSite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itsbeta.com"]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([_contentAvailable count] > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 0; // [[_content objectAtIndex:section] count];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    return nil;
}

@end
