//
//  StationForDonorsViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 07.08.12.
//
//

#import "StationForDonorsViewController.h"
#import "StationRateViewController.h"

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
    
    contentScrollView.contentSize = CGSizeMake(320, contentScrollView.frame.size.height + 1.0f);
    
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
    
    receiptTimeLabel.text = [station valueForKey:@"receiptTime"];
    passageLabel.text = [station valueForKey:@"transportation"];
    bloodDonateForLabel = [station valueForKey:@"bloodFor"];
    bloodDonateTypeLabel = [station valueForKey:@"giveType"];
    durationLabel = [station valueForKey:@"receiptTime"];

    stationTitleLable.text = [station objectForKey:@"title"];
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
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
