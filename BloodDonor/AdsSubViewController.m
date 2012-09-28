//
//  AdsSubViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 26.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdsSubViewController.h"
#import "AdsCell.h"
#import <Parse/Parse.h>

@implementation AdsSubViewController

@synthesize delegate;

#pragma mark TableView
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (contentArray.count != 0)
        return contentArray.count;
    else
        return 0;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [contentArray objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    
    static NSString *CellIdentifier = @"Cell";
    
    AdsCell *cell = (AdsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.stationLabel.text = [stationTitleArray objectAtIndex:indexPath.row];
    cell.adsTitleLabel.text = [object valueForKey:@"title"];
    cell.dateLabel.text = [dateFormat stringFromDate:[object valueForKey:@"updatedAt"]];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate adSelected:[contentArray objectAtIndex:indexPath.row]];
    return indexPath;
}
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
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

- (void)callbackWithResult:(NSArray *)result error:(NSError *)error
{
    if (stationTitleArray)
        [stationTitleArray release];
    stationTitleArray = [NSMutableArray new];
    
    if (result)
    {
        if (contentArray)
            [contentArray release];
        contentArray = [[NSArray alloc] initWithArray:result];
        PFQuery *stations = [PFQuery queryWithClassName:@"Stations"];
        
        [stations findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
        {
            if (objects)
            {
                [stationTitleArray  removeAllObjects];
                for (int i = 0; i < contentArray.count; i++)
                {
                    PFObject *object = [contentArray objectAtIndex:i];
                    
                    for (int j = 0; j < objects.count; j++)
                    {
                        if ([[(PFObject *)[objects objectAtIndex:j] valueForKey:@"objectId"] isEqual:[object valueForKey:@"station_id"]])
                            [stationTitleArray addObject:[(PFObject *)[objects objectAtIndex:j] valueForKey:@"title"]];
                    }
                    
                    if (i != (stationTitleArray.count - 1))
                        [stationTitleArray addObject:@""];
                }
                NSLog(@"station %d ads %d", stationTitleArray.count, contentArray.count);
                [(UITableView *)self.view reloadData];
            }
            [indicatorView removeFromSuperview];
            ((UITableView *)self.view).userInteractionEnabled = YES;
            ((UITableView *)self.view).scrollEnabled = YES;
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ((UITableView *)self.view).scrollsToTop = YES;
    
    indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    indicatorView.backgroundColor = [UIColor blackColor];
    indicatorView.alpha = 0.5f;
    UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    indicator.frame = CGRectMake(160 - indicator.frame.size.width / 2.0f,
                                 160 - indicator.frame.size.height / 2.0f,
                                 indicator.frame.size.width,
                                 indicator.frame.size.height);
    // didAppear
    [indicatorView addSubview:indicator];
    [indicator startAnimating];
    ((UITableView *)self.view).userInteractionEnabled = NO;
    ((UITableView *)self.view).scrollEnabled = NO;
    
    PFQuery *ads = [PFQuery queryWithClassName:@"Ads"];
    [ads orderByDescending:@"updatedAt"];
    
    [self.view addSubview:indicatorView];
    [ads findObjectsInBackgroundWithTarget:self selector:@selector(callbackWithResult:error:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [indicatorView release];
    [contentArray release];
    [stationTitleArray release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
