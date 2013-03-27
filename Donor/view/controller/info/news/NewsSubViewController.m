//
//  NewsSubViewController.m
//  BloodDonor
//
//  Created by Vladimir Noskov on 26.07.12.
//  Updated by Sergey Seroshtan on 20.01.13
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "NewsSubViewController.h"

#import <Parse/Parse.h>
#import "MBProgressHUD.h"

#import "NewsCell.h"
#import "HSModelCommon.h"
#import "HSAlertViewController.h"


@interface NewsSubViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *contentArray;

@end

@implementation NewsSubViewController

#pragma mark - UITableViewDataSource protocol
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self.contentArray objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    NSDateFormatter *parsecomDateFormat = [[NSDateFormatter alloc] init] ;
    [parsecomDateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:sszzz"];
    
    static NSString *CellIdentifier = @"Cell";
    
    NewsCell *cell = (NewsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.newsTitleLabel.text = [object valueForKey:@"title"];
    cell.dateLabel.text = [dateFormat stringFromDate:[parsecomDateFormat dateFromString:
            [[NSString stringWithFormat:@"%@", [object objectForKey:@"created"]]
                    stringByReplacingCharactersInRange:NSMakeRange(22, 1) withString:@""]]];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate newSelected:[self.contentArray objectAtIndex:indexPath.row]];
    return indexPath;
}

#pragma mark - Lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [self loadData];
    });
}

#pragma mark - Private data loading
- (void)loadData {
    self.view.userInteractionEnabled = NO;
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"News"];
    [query orderByDescending:@"createdTimestamp"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [progressHud hide:YES];
        if (error == nil) {
            self.contentArray = objects;
            [(UITableView *)self.view reloadData];
        } else {
            [HSAlertViewController showWithTitle:@"Ошибка"
                                         message:[HSModelCommon localizedDescriptionForParseError:error]];
        }
        self.view.userInteractionEnabled = YES;
    }];
}

@end
