//
//  StationForDonorsViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 07.08.12.
//
//

#import "StationForDonorsViewController.h"
#import "StationRateViewController.h"
#import "ForDonorsCell.h"

@interface StationForDonorsViewController ()

@property (nonatomic, strong) PFObject *station;
@property (nonatomic, assign) float fullRate;
@property (nonatomic, strong) NSMutableArray *descriptionLabelsHeights;

@end

@implementation StationForDonorsViewController

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


#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ForDonorsCell *cell = (ForDonorsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ForDonorsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.descriptionLabel.frame = CGRectMake(cell.descriptionLabel.frame.origin.x, cell.descriptionLabel.frame.origin.y, cell.descriptionLabel.frame.size.width, [[self.descriptionLabelsHeights objectAtIndex:indexPath.row] floatValue]);
    
    switch (indexPath.row)
    {
        case 0:
            cell.titleLabel.text = @"Время приема:";
            cell.descriptionLabel.text = [self.station valueForKey:@"receiptTime"];
            break;
        case 1:
            cell.titleLabel.text = @"Проезд:";
            cell.descriptionLabel.text = [self.station valueForKey:@"transportation"];
            break;
        case 2:
            cell.titleLabel.text = @"Кровь сдается для:";
            cell.descriptionLabel.text = [self.station valueForKey:@"bloodFor"];
            break;
        case 3:
            cell.titleLabel.text = @"Вид кроводачи:";
            cell.descriptionLabel.text = [self.station valueForKey:@"giveType"];
            break;
        case 4:
            cell.titleLabel.text = @"Продолжительность:";
            cell.descriptionLabel.text = [self.station valueForKey:@"giveTime"];
            break;
        default:
            break;
    }
    
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 25.0f + [[self.descriptionLabelsHeights objectAtIndex:indexPath.row] floatValue];
    return rowHeight;
}

- (void)reloadTableData
{
    [self.contentTable reloadData];
    self.contentTable.frame = CGRectMake(self.contentTable.frame.origin.x, self.contentTable.frame.origin.y, self.contentTable.frame.size.width, self.contentTable.contentSize.height);
    self.contentScrollView.contentSize = CGSizeMake(320.0f, self.contentTable.frame.origin.y + self.contentTable.contentSize.height + 5.0f);
}

#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)object rate:(float)rate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.fullRate = rate;
        self.station = object;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Станции";
    
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
    
    self.descriptionLabelsHeights = [NSMutableArray new];
    CGSize maximumLabelSize = CGSizeMake(300.0f, 9999.0f);
    
    CGSize labelSize = [[self.station valueForKey:@"receiptTime"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    [self.descriptionLabelsHeights addObject:[NSNumber numberWithFloat:labelSize.height]];
    labelSize = [[self.station valueForKey:@"transportation"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    [self.descriptionLabelsHeights addObject:[NSNumber numberWithFloat:labelSize.height]];
    labelSize = [[self.station valueForKey:@"bloodFor"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    [self.descriptionLabelsHeights addObject:[NSNumber numberWithFloat:labelSize.height]];
    labelSize = [[self.station valueForKey:@"giveType"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    [self.descriptionLabelsHeights addObject:[NSNumber numberWithFloat:labelSize.height]];
    labelSize = [[self.station valueForKey:@"giveTime"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    [self.descriptionLabelsHeights addObject:[NSNumber numberWithFloat:labelSize.height]];
    [self reloadTableData];
}

@end
