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

@end

@implementation StationForDonorsViewController

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
    
    cell.descriptionLabel.frame = CGRectMake(cell.descriptionLabel.frame.origin.x, cell.descriptionLabel.frame.origin.y, cell.descriptionLabel.frame.size.width, [[descriptionLabelsHeights objectAtIndex:indexPath.row] floatValue]);
    
    switch (indexPath.row)
    {
        case 0:
            cell.titleLabel.text = @"Время приема:";
            cell.descriptionLabel.text = [station valueForKey:@"receiptTime"];
            break;
        case 1:
            cell.titleLabel.text = @"Проезд:";
            cell.descriptionLabel.text = [station valueForKey:@"transportation"];
            break;
        case 2:
            cell.titleLabel.text = @"Кровь сдается для:";
            cell.descriptionLabel.text = [station valueForKey:@"bloodFor"];
            break;
        case 3:
            cell.titleLabel.text = @"Вид кроводачи:";
            cell.descriptionLabel.text = [station valueForKey:@"giveType"];
            break;
        case 4:
            cell.titleLabel.text = @"Продолжительность:";
            cell.descriptionLabel.text = [station valueForKey:@"giveTime"];
            break;
        default:
            break;
    }
    
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 25.0f + [[descriptionLabelsHeights objectAtIndex:indexPath.row] floatValue];
    return rowHeight;
}

- (void)reloadTableData
{
    [contentTable reloadData];
    contentTable.frame = CGRectMake(contentTable.frame.origin.x, contentTable.frame.origin.y, contentTable.frame.size.width, contentTable.contentSize.height);
    contentScrollView.contentSize = CGSizeMake(320.0f, contentTable.frame.origin.y + contentTable.contentSize.height + 5.0f);
}

#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)object rate:(float)rate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        fullRate = rate;
        station = object;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Станции";
    
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
    
    descriptionLabelsHeights = [NSMutableArray new];
    CGSize maximumLabelSize = CGSizeMake(300.0f, 9999.0f);
    
    CGSize labelSize = [[station valueForKey:@"receiptTime"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    [descriptionLabelsHeights addObject:[NSNumber numberWithFloat:labelSize.height]];
    labelSize = [[station valueForKey:@"transportation"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    [descriptionLabelsHeights addObject:[NSNumber numberWithFloat:labelSize.height]];
    labelSize = [[station valueForKey:@"bloodFor"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    [descriptionLabelsHeights addObject:[NSNumber numberWithFloat:labelSize.height]];
    labelSize = [[station valueForKey:@"giveType"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    [descriptionLabelsHeights addObject:[NSNumber numberWithFloat:labelSize.height]];
    labelSize = [[station valueForKey:@"giveTime"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    [descriptionLabelsHeights addObject:[NSNumber numberWithFloat:labelSize.height]];
    [self reloadTableData];
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
    [descriptionLabelsHeights release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
