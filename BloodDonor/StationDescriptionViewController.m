//
//  StationDescriptionViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 07.08.12.
//
//
#import "StationsViewController.h"
#import "StationDescriptionViewController.h"
#import "StationForDonorsViewController.h"
#import "StationRateViewController.h"
#import "StationReviewsViewController.h"
#import "InfoViewController.h"

@interface StationDescriptionViewController ()

@end

@implementation StationDescriptionViewController

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

- (IBAction)forDonorsPressed:(id)sender
{
    StationForDonorsViewController *controller = [[[StationForDonorsViewController alloc] initWithNibName:@"StationForDonorsViewController" bundle:nil station:station rate:fullRate] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)adsPressed:(id)sender
{
    UINavigationController *infoNavigationController = [self.tabBarController.viewControllers objectAtIndex:2];
    InfoViewController *infoViewController = [infoNavigationController.viewControllers objectAtIndex:0];
    [infoViewController selectTab:0];
    [self.tabBarController setSelectedIndex:2];
}

- (IBAction)reviewsPressed:(id)sender
{
    StationReviewsViewController *controller = [[[StationReviewsViewController alloc] initWithNibName:@"StationReviewsViewController" bundle:nil station:station rate:fullRate reviews:reviewsArrayList] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)showOnMapPressed:(id)sender
{
    StationsViewController *controller = [[[StationsViewController alloc] initWithNibName:@"StationsViewController" bundle:nil station:station] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL* url = [request URL];
    if (UIWebViewNavigationTypeLinkClicked == navigationType)
    {
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }
    return YES;
}

#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)object
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        station = object;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Станции";
    
    fullRate = 0.0f;
   
    PFQuery *ads = [PFQuery queryWithClassName:@"Ads"];
    adsLabel.text = [NSString stringWithFormat:@"(%d)", ads.countObjects];
    
    stationTitleLable.text = [station valueForKey:@"title"];
   
    CGSize maximumLabelSize = CGSizeMake(241.0f, 9999.0f);
    
    CGSize labelSize = [[station valueForKey:@"adress"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    
    addressLable.frame = CGRectMake(11.0f, 5.0f, addressLable.frame.size.width, labelSize.height);
    addressLable.text = [station valueForKey:@"adress"];
    
    NSString *phoneString = [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:1; padding:1; } a { color:#DF8D4B; text-align:left; font-family:Helvetica; font-size:15px; font-weight:bold; text-align:left; text-decoration:none; }</style></head><body><a>%@</a></body></html>", [station valueForKey:@"phone"]];
    phoneWebView.scrollView.scrollEnabled = NO;
    phoneWebView.frame = CGRectMake(phoneWebView.frame.origin.x, addressLable.frame.origin.y + addressLable.frame.size.height + 5.0f, phoneWebView.frame.size.width, phoneWebView.frame.size.height);
    [phoneWebView loadHTMLString:phoneString baseURL:nil];
    
    maximumLabelSize = CGSizeMake(320.0f, 9999.0f);
    labelSize = [[station objectForKey:@"description"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap]; 
    NSString *descriptionString = [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:1; padding:1; } p { color:#847168; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:left; } a { color:#0B8B99; text-align:left; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:left; text-decoration:underline; }</style></head><body><p>%@</p></body></html>", [station objectForKey:@"description"]];
    descriptionWebView.frame = CGRectMake(9.0f, phoneWebView.frame.origin.y + phoneWebView.frame.size.height + 5.0f, descriptionWebView.frame.size.width - 9.0f, labelSize.height);
    [descriptionWebView loadHTMLString:descriptionString baseURL:nil];
    descriptionWebView.scrollView.scrollEnabled = NO;
    
    siteLinkWebView.frame = CGRectMake(siteLinkWebView.frame.origin.x, descriptionWebView.frame.origin.y + descriptionWebView.frame.size.height, siteLinkWebView.frame.size.width, siteLinkWebView.frame.size.height);
    
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:1; padding:1; } p {color:#0B8B99; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:left; text-decoration:underline; } a { color:#0B8B99; text-align:left; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:left; text-decoration:underline; }</style></head><body><a>%@</a></body></html>", [station objectForKey:@"url"]];
    
    if (![station objectForKey:@"url"])
        siteLinkWebView.hidden = YES;
    
    siteLinkWebView.scrollView.scrollEnabled = NO;
    
    infoView.frame  = CGRectMake(0.0f, infoView.frame.origin.y, 320.0f, addressLable.frame.size.height + phoneWebView.frame.size.height + descriptionWebView.frame.size.height + siteLinkWebView.frame.size.height);
    
    buttonsView.frame = CGRectMake(0.0f, infoView.frame.origin.y + infoView.frame.size.height + 5.0f, 320.0f, buttonsView.frame.size.height);
    
    contentScrollView.contentSize = CGSizeMake(320.0f, infoView.frame.origin.y + infoView.frame.size.height + 2.0f*5.0f + buttonsView.frame.size.height);
    
    [siteLinkWebView loadHTMLString:htmlString baseURL:nil];
    
    indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    indicatorView.backgroundColor = [UIColor blackColor];
    indicatorView.alpha = 0.5f;
    UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    indicator.frame = CGRectMake(160 - indicator.frame.size.width / 2.0f,
                                 240 - indicator.frame.size.height / 2.0f,
                                 indicator.frame.size.width,
                                 indicator.frame.size.height);
    
    [indicatorView addSubview:indicator];
    [indicator startAnimating];
    
}

- (void)callbackWithResult:(NSArray *)result error:(NSError *)error
{
    float rate = 0.0f;
    float reviewsNumber = 0.0f;
    
    if (result)
    {
        if (reviewsArrayList)
            [reviewsArrayList release];
        
        reviewsArrayList = [[NSArray alloc] initWithArray:result];
        
        for (int i = 0; i < reviewsArrayList.count; i++)
        {
            if ([[(PFObject *)[reviewsArrayList objectAtIndex:i] valueForKey:@"station_id"] isEqual:[station valueForKey:@"objectId"]])
            {
                reviewsNumber += 1.0f;
                rate += [[(PFObject *)[reviewsArrayList objectAtIndex:i] valueForKey:@"vote"] floatValue];
            }
        }
        
        fullRate = rate/reviewsNumber;
        if(fullRate <= 1.0f)
        {
            [ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [ratedStar2 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
            [ratedStar3 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
            [ratedStar4 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
            [ratedStar5 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
        }
        else if ((1.0f < fullRate) && (fullRate <= 2.0f))
        {
            [ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [ratedStar3 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
            [ratedStar4 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
            [ratedStar5 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
        }
        else if ((2.0f < fullRate) && (fullRate <= 3.0f))
        {
            [ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [ratedStar4 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
            [ratedStar5 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
        }
        else if ((3.0f < fullRate) && (fullRate <= 4.0f))
        {
            [ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [ratedStar4 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [ratedStar5 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
        }
        else if (4.0f < fullRate)
        {
            [ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [ratedStar4 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [ratedStar5 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        }

        [reviewsButton setTitle:[NSString stringWithFormat:@"(%d)", reviewsArrayList.count] forState:UIControlStateNormal];
        [reviewsButton setTitle:[NSString stringWithFormat:@"(%d)", reviewsArrayList.count] forState:UIControlStateHighlighted];
    }
    [indicatorView removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.tabBarController.view addSubview:indicatorView];
    
    PFQuery *reviews = [PFQuery queryWithClassName:@"StationReviews"];
    [reviews whereKey:@"station_id" equalTo:[station valueForKey:@"objectId"]];
    [reviews findObjectsInBackgroundWithTarget:self selector:@selector(callbackWithResult: error:)];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [indicatorView release];
    [reviewsArrayList release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
