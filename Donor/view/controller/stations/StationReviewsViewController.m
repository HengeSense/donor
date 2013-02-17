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

@property (nonatomic, strong) NSArray *reviewsArray;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) PFObject *station;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) CGFloat selectedRowHeight;
@property (nonatomic, assign) float fullRate;

@end

@implementation StationReviewsViewController

#pragma mare Actions

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ratePressed:(id)sender
{
    StationRateViewController *controller = [[StationRateViewController alloc] initWithNibName:@"StationRateViewController" bundle:nil station:self.station rate:self.fullRate];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [self.contentArray objectAtIndex:indexPath.row];
    
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
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    
    cell.nameLabel.text = [object valueForKey:@"username"];
    cell.dateLabel.text = [dateFormat stringFromDate:[object valueForKey:@"updatedAt"]];
    cell.reviewLabel.text = [object valueForKey:@"body"];
   
    if (self.selectedRow == indexPath.row)
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
    self.selectedRow = indexPath.row;
    ReviewsCell *cell = (ReviewsCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.reviewLabel.hidden = NO;
    self.selectedRowHeight = cell.contentSize.height;
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
  
    return indexPath;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    if (indexPath.row == self.selectedRow)
        return self.selectedRowHeight;
    else
        return 35;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    ReviewsCell *cell = (ReviewsCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.reviewLabel.hidden = YES;
    self.selectedRow = self.contentArray.count;
    return indexPath;
}

#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)object rate:(float)rate reviews:(NSArray *)arrayList
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.station = object;
        self.fullRate = rate;
        self.reviewsArray = [[NSArray alloc] initWithArray:arrayList];
        //NSLog(@"%@",arrayList);
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Станции";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
        style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    if(self.fullRate <= 1.0f)
        [self.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    else if ((1.0f < self.fullRate) && (self.fullRate <= 2.0f))
    {
        [self.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    else if ((2.0f < self.fullRate) && (self.fullRate <= 3.0f))
    {
        [self.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    else if ((3.0f < self.fullRate) && (self.fullRate <= 4.0f))
    {
        [self.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar4 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    else if (4.0f < self.fullRate)
    {
        [self.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar4 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar5 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    self.stationTitleLable.text = [self.station objectForKey:@"title"];
    
    self.contentArray = [NSMutableArray new];
    
    for (int i = 0; self.reviewsArray.count > i; i++)
    {
        if ([[(PFObject *)[self.reviewsArray objectAtIndex:i] valueForKey:@"station_id"] isEqual:[self.station valueForKey:@"objectId"]])
            [self.contentArray addObject:[self.reviewsArray objectAtIndex:i]];
    }
    self.selectedRow = self.contentArray.count;
}

@end
