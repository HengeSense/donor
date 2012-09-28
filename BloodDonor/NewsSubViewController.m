//
//  NewsSubViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 26.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsSubViewController.h"
#import "NewsCell.h"

@implementation NewsSubViewController

@synthesize delegate;

#pragma mark TableView
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contentArray.count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [contentArray objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    
    static NSString *CellIdentifier = @"Cell";
    
    NewsCell *cell = (NewsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.newsTitleLabel.text = [object valueForKey:@"title"];
    cell.dateLabel.text = [dateFormat stringFromDate:[object valueForKey:@"updatedAt"]];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate newSelected:[contentArray objectAtIndex:indexPath.row]];
    return indexPath;
}

#pragma mark Lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];
    [indicatorView removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ((UITableView *)self.view).scrollsToTop = YES;
    
    indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    indicatorView.backgroundColor = [UIColor blackColor];
    indicatorView.alpha = 0.5f;
    UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    indicator.frame = CGRectMake(160 - indicator.frame.size.width / 2.0f,
                                 160 - indicator.frame.size.height / 2.0f,
                                 indicator.frame.size.width,
                                 indicator.frame.size.height);
    
    [indicatorView addSubview:indicator];
    [indicator startAnimating];
    // didAppear
    [(UITableView *)self.view scrollToRowAtIndexPath:0 atScrollPosition:UITableViewScrollPositionTop animated:YES];
    ((UITableView *)self.view).userInteractionEnabled = NO;
    
    PFQuery *query = [PFQuery queryWithClassName:@"News"];
    [query orderByDescending:@"updatedAt"];
    
    [self.view addSubview:indicatorView];
    
    [query findObjectsInBackgroundWithTarget:self selector:@selector(callbackWithResult:error:)];
}

- (void)callbackWithResult:(NSArray *)result error:(NSError *)error
{
    if (result)
    {
        if (contentArray)
            [contentArray release];
        
        contentArray = [[NSArray alloc] initWithArray:result];
        [(UITableView *)self.view reloadData];
    }
    [indicatorView removeFromSuperview];
    ((UITableView *)self.view).userInteractionEnabled = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [indicatorView release];
    [contentArray release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
