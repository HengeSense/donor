//
//  StationReviewsViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 07.08.12.
//
//

#import "StationReviewsViewController.h"
#import "StationRateViewController.h"
#import "ReviewsCell.h"

@interface StationReviewsViewController ()

@end

@implementation StationReviewsViewController

#pragma mare Actions

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ratePressed:(id)sender
{
    StationRateViewController *controller = [[[StationRateViewController alloc] initWithNibName:@"StationRateViewController" bundle:nil station:station rate:fullRate] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [contentArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    ReviewsCell *cell = (ReviewsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if([[object valueForKey:@"vote"] intValue] <= 1)
        [cell.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    else if ((1 < [[object valueForKey:@"vote"] intValue]) && ([[object valueForKey:@"vote"] intValue] <= 2))
    {
        [cell.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [cell.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    else if ((2 < [[object valueForKey:@"vote"] intValue]) && ([[object valueForKey:@"vote"] intValue] <= 3))
    {
        [cell.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [cell.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [cell.ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    else if ((3 < [[object valueForKey:@"vote"] intValue]) && ([[object valueForKey:@"vote"] intValue] <= 4))
    {
        [cell.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [cell.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [cell.ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [cell.ratedStar4 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    else if (4 < [[object valueForKey:@"vote"] intValue])
    {
        [cell.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [cell.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [cell.ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [cell.ratedStar4 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [cell.ratedStar5 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    
    cell.nameLabel.text = [object valueForKey:@"username"];
    cell.dateLabel.text = [dateFormat stringFromDate:[object valueForKey:@"updatedAt"]];
    cell.reviewLabel.text = [object valueForKey:@"body"];
   
    if (selectedRow == indexPath.row)
        cell.reviewLabel.hidden = NO;
    else
        cell.reviewLabel.hidden = YES;
    
    CGSize maximumLabelSize = CGSizeMake(320.0f, 9999.0f);
    
    CGSize htmlString1Size = [cell.reviewLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    cell.reviewLabel.frame = CGRectMake( 13.0f,  45.0f, 300.0f, htmlString1Size.height + 10.0f);
    
    cell.contentSize = CGSizeMake(cell.frame.size.width, 35.0f + cell.reviewLabel.frame.size.height + 10.0f);

    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    ReviewsCell *cell = (ReviewsCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.reviewLabel.hidden = NO;
    selectedRowHeight = cell.contentSize.height;
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
  
    return indexPath;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    if (indexPath.row == selectedRow)
        return selectedRowHeight;
    else
        return 35;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    ReviewsCell *cell = (ReviewsCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.reviewLabel.hidden = YES;
    selectedRow = contentArray.count;
    return indexPath;
}

#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)object rate:(float)rate reviews:(NSArray *)arrayList
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        station = object;
        fullRate = rate;
        reviewsArray = [[NSArray alloc] initWithArray:arrayList];
        //NSLog(@"%@",arrayList);
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Станции";
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];
    
    if(fullRate <= 1.0f)
        [ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    else if ((1.0f < fullRate) && (fullRate <= 2.0f))
    {
        [ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    else if ((2.0f < fullRate) && (fullRate <= 3.0f))
    {
        [ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    else if ((3.0f < fullRate) && (fullRate <= 4.0f))
    {
        [ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar4 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    else if (4.0f < fullRate)
    {
        [ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar4 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar5 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    stationTitleLable.text = [station objectForKey:@"title"];
    
    contentArray = [NSMutableArray new];
    
    for (int i = 0; reviewsArray.count > i; i++)
    {
        if ([[(PFObject *)[reviewsArray objectAtIndex:i] valueForKey:@"station_id"] isEqual:[station valueForKey:@"objectId"]])
            [contentArray addObject:[reviewsArray objectAtIndex:i]];
    }
    selectedRow = contentArray.count;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [contentArray release];
    [reviewsArray release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
