//
//  HSItsBetaAchievementsViewController.m
//  Donor
//
//  Created by Alexander Trifonov on 4/3/13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSItsBetaAchievementsViewController.h"
#import "HSItsBetaAchievementsCell.h"

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

- (void)refresh;
- (UITableViewCell*)createTableViewCellWithNibName:(NSString*)nibName withClass:(Class)class;

@end

@implementation HSItsBetaAchievementsViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self != nil) {
        [self setTitle:@"Мои достижения"];
        
        _project = [ItsBeta projectByName:@"donor"];
        _objectTemplateInstall = [ItsBeta objectTemplateByName:@"donorfriend" byProject:_project];
        _objectTemplateFirstBlood = [ItsBeta objectTemplateByName:@"first_blood" byProject:_project];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willPlayerSynchronize:) name:ItsBetaWillPlayerSynchronize object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayerSynchronize:) name:ItsBetaDidPlayerSynchronize object:nil];
    
    [ItsBeta synchronizePlayerWithProject:_project];

    [self refresh];
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
}

- (void) didPlayerSynchronize:(NSNotification*)notification {
    [self refresh];
    if(_progressHud != nil) {
        [_progressHud hide:YES];
        _progressHud = nil;
    }
}

- (void)refresh {
    [_contentExists removeAllObjects];
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
}

- (UITableViewCell*)createTableViewCellWithNibName:(NSString*)nibName withClass:(Class)class {
    UINib* nib = [UINib nibWithNibName:nibName bundle:nil];
    if(nib != nil) {
        NSArray* content = [nib instantiateWithOwner:nil options:nil];
        for(id item in content) {
            if([item isKindOfClass:class] == YES) {
                return item;
            }
        }
    }
    return nil;
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
    return [[_content objectAtIndex:section] count];
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString* CellIdentifier = @"ItsBetaAchievementsCell";
    HSItsBetaAchievementsCell* cell = (HSItsBetaAchievementsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = (HSItsBetaAchievementsCell*)[self createTableViewCellWithNibName:@"HSItsBetaAchievementsCell" withClass:[HSItsBetaAchievementsCell class]];
    }
    NSArray* section = [_content objectAtIndex:[indexPath section]];
    if(section != nil) {
        [cell setObjectTemplate:[section objectAtIndex:[indexPath row]]];
        [cell setIsExists:(section == _contentExists)];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 120;
}

@end
