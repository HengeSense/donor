//
//  HSItsBetaAchievementsViewController.m
//  Donor
//
//  Created by Alexander Trifonov on 4/3/13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSItsBetaAchievementsViewController.h"
#import "ItsBeta.h"

@interface HSItsBetaAchievementsViewController () {
    ItsBetaProject* _project;
}

@end

@implementation HSItsBetaAchievementsViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self != nil) {
        [self setTitle:@"Мои достижения"];
        
        _project = [ItsBeta projectByName:@"donor"];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    return nil;
}


@end
