//
//  AdsSubViewController.m
//  BloodDonor
//
//  Created by Vladimir Noskov on 26.07.12.
//  Updated by Sergey Seroshtan on 17.01.13
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "AdsSubViewController.h"

#import <Parse/Parse.h>
#import "MBProgressHUD.h"

#import "AdsCell.h"
#import "HSModelCommon.h"
#import "HSAlertViewController.h"

@interface AdsSubViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, strong) NSMutableArray *stationTitleArray;

@end

@implementation AdsSubViewController

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.stationTitleArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [self loadData];
    });
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self.contentArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    AdsCell *cell = (AdsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.stationLabel.text = [self.stationTitleArray objectAtIndex:indexPath.row];
    cell.adsTitleLabel.text = [object valueForKey:@"title"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
   [dateFormat setDateFormat:@"dd.MM.yyyy"];
    NSDateFormatter *parsecomDateFormat = [[NSDateFormatter alloc] init];
   [parsecomDateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:sszzz"];
    cell.dateLabel.text = [dateFormat stringFromDate:[parsecomDateFormat dateFromString:[[NSString stringWithFormat:@"%@", [object objectForKey:@"created"]] stringByReplacingCharactersInRange:NSMakeRange(22, 1) withString:@""]]];

    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate adSelected:[self.contentArray objectAtIndex:indexPath.row]];
    return indexPath;
}

#pragma mark - Private interface
- (void)loadData {
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.userInteractionEnabled = NO;
    PFQuery *ads = [PFQuery queryWithClassName:@"Ads"];
    [ads orderByDescending:@"createdTimestamp"];
    [ads findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            self.contentArray = [[NSArray alloc] initWithArray:objects];
            PFQuery *stations = [PFQuery queryWithClassName:@"Stations"];
            [stations findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (error == nil) {
                    [self.stationTitleArray  removeAllObjects];
                    for (int i = 0; i < self.contentArray.count; ++i) {
                        PFObject *object = [self.contentArray objectAtIndex:i];
                        for (int j = 0; j < objects.count; ++j) {
                            if ([[(PFObject *)[objects objectAtIndex:j] valueForKey:@"objectId"]
                                 isEqual:[object valueForKey:@"station_id"]])
                                [self.stationTitleArray addObject:[(PFObject *)[objects objectAtIndex:j]
                                                                   valueForKey:@"title"]];
                        }
                        if (i != (self.stationTitleArray.count - 1)) {
                            [self.stationTitleArray addObject:@""];
                        }
                    }
                    [(UITableView *)self.view reloadData];
                } else {
                    [HSAlertViewController showWithTitle:@"Ошибка" message:localizedDescriptionForParseError(error)];
                }
                [progressHud hide:YES];
                self.view.userInteractionEnabled = YES;
             }];
        } else {
            [progressHud hide:YES];
            self.view.userInteractionEnabled = YES;
            [HSAlertViewController showWithTitle:@"Ошибка" message:localizedDescriptionForParseError(error)];
        }
    }];
}

@end
