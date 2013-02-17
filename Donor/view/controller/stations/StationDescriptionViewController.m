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
#import "STabBarController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface StationDescriptionViewController ()

@property (nonatomic, retain) StationsViewController *stationsViewController;

@end

@implementation StationDescriptionViewController

@synthesize stationsViewController;

#pragma mare Actions

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ratePressed:(id)sender
{
    StationRateViewController *controller = [[StationRateViewController alloc]
            initWithNibName:@"StationRateViewController" bundle:nil station:self.station rate:self.fullRate];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)forDonorsPressed:(id)sender
{
    StationForDonorsViewController *controller = [[StationForDonorsViewController alloc]
            initWithNibName:@"StationForDonorsViewController" bundle:nil station:self.station rate:self.fullRate];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)adsPressed:(id)sender
{
    [self.tabBarController setSelectedIndex:2];
}

- (IBAction)reviewsPressed:(id)sender
{
    StationReviewsViewController *controller = [[StationReviewsViewController alloc]
            initWithNibName:@"StationReviewsViewController" bundle:nil station:self.station rate:self.fullRate
            reviews:self.reviewsArrayList];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)showOnMapPressed:(id)sender
{
    [self.navigationController pushViewController:self.stationsViewController animated:YES];
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
        self.station = object;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stationsViewController = [[StationsViewController alloc] initWithNibName:@"StationsViewController" bundle:nil
                                                                          station:self.station];

    
    // Hides forDodonorsView (JIRA: DOI-65)
    [self.forDodonorsView removeFromSuperview];
    
    self.title = @"Станции";
    self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@"Назад" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    self.fullRate = 0.0f;
   
    PFQuery *ads = [PFQuery queryWithClassName:@"Ads"];
    self.adsLabel.text = [NSString stringWithFormat:@"(%d)", ads.countObjects];
    
    self.stationTitleLable.text = [self.station valueForKey:@"title"];
   
    CGSize maximumLabelSize = CGSizeMake(241.0f, 9999.0f);
    
    CGSize labelSize = [[self.station valueForKey:@"adress"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    
    self.self.addressLable.frame = CGRectMake(11.0f, 5.0f, self.addressLable.frame.size.width, labelSize.height);
    self.addressLable.text = [self.station valueForKey:@"adress"];
    
    NSString *phoneString = [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:1; padding:1; } a { color:#DF8D4B; text-align:left; font-family:Helvetica; font-size:15px; font-weight:bold; text-align:left; text-decoration:none; }</style></head><body><a>%@</a></body></html>", [self.station valueForKey:@"phone"]];
    self.phoneWebView.scrollView.scrollEnabled = NO;
    self.phoneWebView.frame = CGRectMake(self.phoneWebView.frame.origin.x, self.addressLable.frame.origin.y + self.addressLable.frame.size.height + 5.0f, self.phoneWebView.frame.size.width, self.phoneWebView.frame.size.height);
    [self.phoneWebView loadHTMLString:phoneString baseURL:nil];
    
    maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 9999.0f);
    //labelSize = [[station objectForKey:@"description"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    NSString *description = [self stringByStrippingHTML:[self.station objectForKey:@"description"]];
    NSString *descriptionString = [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:1; padding:1; } p { color:#847168; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:left; } a { color:#0B8B99; text-align:left; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:left; text-decoration:underline; }</style></head><body><p>%@</p></body></html>", description];
    //descriptionWebView.frame = CGRectMake(7.0f, phoneWebView.frame.origin.y + phoneWebView.frame.size.height + 5.0f, descriptionWebView.frame.size.width - 14.0f, labelSize.height);
    [self.descriptionWebView setDelegate:self];
    [self.descriptionWebView loadHTMLString:descriptionString baseURL:nil];
    self.descriptionWebView.scrollView.scrollEnabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    const CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (webView ==self.descriptionWebView)
    {
        self.descriptionWebView.frame = CGRectMake(7.0f, self.phoneWebView.frame.origin.y + self.phoneWebView.frame.size.height + 5.0f, self.descriptionWebView.frame.size.width, self.descriptionWebView.scrollView.contentSize.height + 10.0f);
        
        self.siteLinkWebView.frame = CGRectMake(self.siteLinkWebView.frame.origin.x, self.descriptionWebView.frame.origin.y + self.descriptionWebView.frame.size.height, self.siteLinkWebView.frame.size.width, self.siteLinkWebView.frame.size.height);
        
        NSString *htmlString = [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:1; padding:1; } p {color:#0B8B99; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:left; text-decoration:underline; } a { color:#0B8B99; text-align:left; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:left; text-decoration:underline; }</style></head><body><a>%@</a></body></html>", [self.station objectForKey:@"url"]];
        
        if (![self.station objectForKey:@"url"]) {
            self.siteLinkWebView.hidden = YES;
        } else {
            [self.siteLinkWebView loadHTMLString:htmlString baseURL:nil];
        }
        
        self.siteLinkWebView.scrollView.scrollEnabled = NO;
        
        self.infoView.frame  = CGRectMake(0.0f, self.infoView.frame.origin.y, screenWidth, self.siteLinkWebView.frame.origin.y + self.siteLinkWebView.frame.size.height + 5.0f);
        
        self.buttonsView.frame = CGRectMake(0.0f, self.infoView.frame.origin.y + self.infoView.frame.size.height + 5.0f, screenWidth, self.buttonsView.frame.size.height);
        
        self.contentScrollView.contentSize = CGSizeMake(screenWidth, self.infoView.frame.origin.y + self.infoView.frame.size.height + 2.0f*5.0f + self.buttonsView.frame.size.height/2.0f);
        
        if (([[self.station objectForKey:@"receiptTime"] isEqualToString:@""] || [self.station objectForKey:@"receiptTime"] == NULL)&&
            ([[self.station objectForKey:@"transportation"] isEqualToString:@""] || [self.station objectForKey:@"transportation"] == NULL) &&
            ([[self.station objectForKey:@"bloodFor"] isEqualToString:@""] || [self.station objectForKey:@"bloodFor"] == NULL) &&
            ([[self.station objectForKey:@"giveType"] isEqualToString:@""] || [self.station objectForKey:@"giveType"] == NULL) &&
            ([[self.station objectForKey:@"receiptTime"] isEqualToString:@""] || [self.station objectForKey:@"receiptTime"] == NULL))
        {
            self.forDodonorsView.hidden = YES;
        }
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    PFQuery *reviews = [PFQuery queryWithClassName:@"StationReviews"];
    [reviews whereKey:@"station_id" equalTo:[self.station valueForKey:@"objectId"]];
    [reviews findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self processStations:objects error:error];
        [progressHud hide:YES];
    }];
}

#pragma mark - Utility
- (void)processStations:(NSArray *)result error:(NSError *)error
{
    float rate = 0.0f;
    float reviewsNumber = 0.0f;
    
    if (result)
    {
        self.reviewsArrayList = [[NSArray alloc] initWithArray:result];
        
        for (int i = 0; i < self.reviewsArrayList.count; i++)
        {
            if ([[(PFObject *)[self.reviewsArrayList objectAtIndex:i] valueForKey:@"station_id"] isEqual:[self.station valueForKey:@"objectId"]])
            {
                reviewsNumber += 1.0f;
                rate += [[(PFObject *)[self.reviewsArrayList objectAtIndex:i] valueForKey:@"vote"] floatValue];
            }
        }
        
        self.fullRate = rate/reviewsNumber;
        if(self.fullRate <= 1.0f)
        {
            [self.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [self.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
            [self.ratedStar3 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
            [self.ratedStar4 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
            [self.ratedStar5 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
        }
        else if ((1.0f < self.fullRate) && (self.fullRate <= 2.0f))
        {
            [self.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [self.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [self.ratedStar3 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
            [self.ratedStar4 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
            [self.ratedStar5 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
        }
        else if ((2.0f < self.fullRate) && (self.fullRate <= 3.0f))
        {
            [self.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [self.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [self.ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [self.ratedStar4 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
            [self.ratedStar5 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
        }
        else if ((3.0f < self.fullRate) && (self.fullRate <= 4.0f))
        {
            [self.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [self.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [self.ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [self.ratedStar4 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [self.ratedStar5 setImage:[UIImage imageNamed:@"ratedStarEmpty"]];
        }
        else if (4.0f < self.fullRate)
        {
            [self.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [self.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [self.ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [self.ratedStar4 setImage:[UIImage imageNamed:@"ratedStarFill"]];
            [self.ratedStar5 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        }

        if (self.reviewsArrayList.count > 0)
        {
            self.reviewsLabel.hidden = NO;
            self.reviewsButton.hidden = NO;
            [self.reviewsButton setTitle:[NSString stringWithFormat:@"(%d)", self.reviewsArrayList.count] forState:UIControlStateNormal];
            [self.reviewsButton setTitle:[NSString stringWithFormat:@"(%d)", self.reviewsArrayList.count] forState:UIControlStateHighlighted];
        }
        else
        {
            self.reviewsLabel.hidden = YES;
            self.reviewsButton.hidden = YES;
        }
    }
}

- (NSString *)stringByStrippingHTML:(NSString *)inputString
{
    NSString *outString = nil;
    
    if (inputString)
    {
        outString = [[NSString alloc] initWithString:inputString];
        if ([inputString length] > 0)
        {
            NSArray *entities = [[NSArray alloc] initWithObjects:@" **", @"** ", @"_**", @"**_", @"**", @".**",nil];
            NSArray *plainText = [[NSArray alloc] initWithObjects:@" <i>",@"</i> ",@" <i>",@"</i> ", @"<i>",@".</i>", nil];
            
            int i = 0;
            for (NSString *entity in entities)
            {
                outString = [outString stringByReplacingOccurrencesOfString:[entities objectAtIndex:i] withString:[plainText objectAtIndex:i]];
                i++;
            }
            
            NSError *error = NULL;
            
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[inline\\|iid=(.+?)\\]" options:NSRegularExpressionCaseInsensitive error:&error];
            outString = [regex stringByReplacingMatchesInString:outString options:0 range:NSMakeRange(0, [outString length]) withTemplate:@" "];
            
            regex = [NSRegularExpression regularExpressionWithPattern:@"\\[(.+?)\\]\\((.+?)\\)" options:NSRegularExpressionCaseInsensitive error:&error];
            outString = [regex stringByReplacingMatchesInString:outString options:0 range:NSMakeRange(0, [outString length]) withTemplate:@"<a href=\"$2\">$1</a>"];
            
            regex = [NSRegularExpression regularExpressionWithPattern:@"\\<a href=\"/main/(.+?)\"\\>" options:NSRegularExpressionCaseInsensitive error:&error];
            outString = [regex stringByReplacingMatchesInString:outString options:0 range:NSMakeRange(0, [outString length]) withTemplate:@"<a href=\"http://www.podari-zhizn.ru/main/$1\">"];
            
        }
    }
    
    return outString;
}
@end
