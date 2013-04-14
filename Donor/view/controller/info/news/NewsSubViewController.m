//
//  NewsSubViewController.m
//  BloodDonor
//
//  Created by Vladimir Noskov on 26.07.12.
//  Updated by Sergey Seroshtan on 20.01.13
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "NewsSubViewController.h"

#import "MWFeedParser.h"
#import "MBProgressHUD.h"

#import "NewsCell.h"
#import "HSModelCommon.h"
#import "HSAlertViewController.h"

static NSString * const kDonorNewsRSSLink = @"http://yadonor.ru/ru/news_rss/";

@interface NewsSubViewController () <UITableViewDataSource, UITableViewDelegate, MWFeedParserDelegate>

@property (nonatomic, strong) NSMutableArray *contentArray;

@end

@implementation NewsSubViewController

#pragma mark - UITableViewDataSource protocol
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    NewsCell *cell = (NewsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSInteger row = indexPath.row;
    if (row >= [self.contentArray count]) {
        return cell;
    }
    
    MWFeedItem *feedItem = [self.contentArray objectAtIndex:row];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
    [dateFormat setDateFormat:@"dd.MM.yyyy"];

    cell.newsTitleLabel.text = feedItem.title;
    cell.dateLabel.text = [dateFormat stringFromDate:feedItem.date];
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

#pragma mark - MWFeedParserDelegate
- (void)feedParserDidStart:(MWFeedParser *)parser {
    if (self.contentArray == nil) {
        self.contentArray = [[NSMutableArray alloc] init];
    } else {
        [self.contentArray removeAllObjects];
    }
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    self.view.userInteractionEnabled = YES;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [((UITableView *)self.view) reloadData];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [HSAlertViewController showWithMessage:@"Загрузка новостей завершилась с ошибкой."];
    NSLog(@"RSS news loading failed with error: %@", error);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    [self.contentArray addObject:item];
}


#pragma mark - Private
#pragma mark - Data loading
- (void)loadData {
    NSURL *feedURL = [NSURL URLWithString:kDonorNewsRSSLink];
    MWFeedParser *feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull;
    feedParser.connectionType = ConnectionTypeAsynchronously;
    
    self.view.userInteractionEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [feedParser parse];
}

@end
