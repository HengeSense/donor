//
//  HSRecommendationsViewController.m
//  Donor
//
//  Created by Sergey Seroshtan on 20.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSRecommendationsViewController.h"

#import "MBProgressHUD.h"

#import "HSRecommendation.h"
#import "HSRecommendationsLoader.h"
#import "HSContraindicationCell.h"

@interface HSRecommendationsViewController ()

@property (nonatomic, strong) NSArray *recommendations;

@end

@implementation HSRecommendationsViewController

#pragma mark - Lifecycle
- (void)configureUI {
    self.title = @"Рекомендации";
}

- (void)loadRecommendations {
    HSRecommendationsLoader *dataLoader = [[HSRecommendationsLoader alloc] init];
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [dataLoader loadDataWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            self.recommendations = dataLoader.recommendations;
        } else {
            NSLog(@"Error was occured during loading blood donation recommendations.");
        }
        [progressHud hide:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    [self loadRecommendations];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.recommendationsTableView.frame = [self defineContentFrame];
}


#pragma mark - UITableViewDataSource protocol implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.recommendations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *recommendation = [self recommendationAtIndexPath:indexPath];
    return [HSContraindicationCell calculateHightForTitle:recommendation
                                                  details:nil
                                              indentation:0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *background =
            [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contraindicationsSectionBackground"]] ;
    UIView *headerView = [[UIView alloc] initWithFrame:background.bounds];
    
    [headerView addSubview:background];
    
    HSRecommendation *recommendation = [self.recommendations objectAtIndex:section];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 320, 14)];
    headerLabel.text = recommendation.title;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
    headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    headerLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self calculateNumberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * const kAbsoluterecommendationCellIdentifier = @"HSContraindicationCell";
    HSContraindicationCell *cell =
            [tableView dequeueReusableCellWithIdentifier:kAbsoluterecommendationCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HSContraindicationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSString *recommendation = [self recommendationAtIndexPath:indexPath];
    cell.title.text = recommendation;
    cell.details.text = nil;
    return cell;
}

- (NSString *)recommendationAtIndexPath:(NSIndexPath *)path {
    if (path.section < self.recommendations.count) {
        HSRecommendation *recommendation = [self.recommendations objectAtIndex:path.section];
        if (path.row < recommendation.recommendations.count) {
            return [recommendation.recommendations objectAtIndex:path.row];
        }
    }
    return nil;
}

- (NSUInteger)calculateNumberOfRowsInSection:(NSInteger)section {
    if (section < self.recommendations.count) {
        HSRecommendation *recommendation = [self.recommendations objectAtIndex:section];
        return recommendation.recommendations.count;
    }
    return 0;
}

#pragma mark - Private utils
- (CGRect)defineContentFrame {
    const NSUInteger paddingFromNavigationBar = 3;
    const NSUInteger bottomTabBarHeight = 55;
    
    NSUInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSUInteger screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSUInteger navigationBarHeight = self.navigationController.navigationBar.bounds.size.height;
    
    CGRect contentViewFrame = CGRectZero;
    contentViewFrame.origin.x = 0;
    contentViewFrame.origin.y = paddingFromNavigationBar;
    contentViewFrame.size.height = screenHeight - navigationBarHeight - paddingFromNavigationBar - bottomTabBarHeight;
    contentViewFrame.size.width = screenWidth;
    return contentViewFrame;
}

@end
