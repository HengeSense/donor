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
    
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.sTabBarController selectTab];
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
    
    // Hides forDodonorsView (JIRA: DOI-65)
    [forDodonorsView removeFromSuperview];
    
    self.title = @"Станции";
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];
    
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
    //labelSize = [[station objectForKey:@"description"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    NSString *description = [self stringByStrippingHTML:[station objectForKey:@"description"]];
    NSString *descriptionString = [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:1; padding:1; } p { color:#847168; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:left; } a { color:#0B8B99; text-align:left; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:left; text-decoration:underline; }</style></head><body><p>%@</p></body></html>", description];
    //descriptionWebView.frame = CGRectMake(7.0f, phoneWebView.frame.origin.y + phoneWebView.frame.size.height + 5.0f, descriptionWebView.frame.size.width - 14.0f, labelSize.height);
    [descriptionWebView setDelegate:self];
    [descriptionWebView loadHTMLString:descriptionString baseURL:nil];
    descriptionWebView.scrollView.scrollEnabled = NO;
    
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView == descriptionWebView)
    {
        descriptionWebView.frame = CGRectMake(7.0f, phoneWebView.frame.origin.y + phoneWebView.frame.size.height + 5.0f, descriptionWebView.frame.size.width, descriptionWebView.scrollView.contentSize.height + 10.0f);
        
        siteLinkWebView.frame = CGRectMake(siteLinkWebView.frame.origin.x, descriptionWebView.frame.origin.y + descriptionWebView.frame.size.height, siteLinkWebView.frame.size.width, siteLinkWebView.frame.size.height);
        
        NSString *htmlString = [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:1; padding:1; } p {color:#0B8B99; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:left; text-decoration:underline; } a { color:#0B8B99; text-align:left; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:left; text-decoration:underline; }</style></head><body><a>%@</a></body></html>", [station objectForKey:@"url"]];
        
        if (![station objectForKey:@"url"])
            siteLinkWebView.hidden = YES;
        else
            [siteLinkWebView loadHTMLString:htmlString baseURL:nil];
        
        siteLinkWebView.scrollView.scrollEnabled = NO;
        
        infoView.frame  = CGRectMake(0.0f, infoView.frame.origin.y, 320.0f, siteLinkWebView.frame.origin.y + siteLinkWebView.frame.size.height + 5.0f);
        
        buttonsView.frame = CGRectMake(0.0f, infoView.frame.origin.y + infoView.frame.size.height + 5.0f, 320.0f, buttonsView.frame.size.height);
        
        contentScrollView.contentSize = CGSizeMake(320.0f, infoView.frame.origin.y + infoView.frame.size.height + 2.0f*5.0f + buttonsView.frame.size.height/2.0f);
        
        /*if (![station objectForKey:@"receiptTime"] && ![station objectForKey:@"transportation"] && ![station objectForKey:@"bloodFor"] && ![station objectForKey:@"giveType"] && ![station objectForKey:@"receiptTime"])
         {
         forDodonorsView.hidden = YES;
         }*/
        
        if (([[station objectForKey:@"receiptTime"] isEqualToString:@""] || [station objectForKey:@"receiptTime"] == NULL)&&
            ([[station objectForKey:@"transportation"] isEqualToString:@""] || [station objectForKey:@"transportation"] == NULL) &&
            ([[station objectForKey:@"bloodFor"] isEqualToString:@""] || [station objectForKey:@"bloodFor"] == NULL) &&
            ([[station objectForKey:@"giveType"] isEqualToString:@""] || [station objectForKey:@"giveType"] == NULL) &&
            ([[station objectForKey:@"receiptTime"] isEqualToString:@""] || [station objectForKey:@"receiptTime"] == NULL))
        {
            forDodonorsView.hidden = YES;
        }
        
    }
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

        if (reviewsArrayList.count > 0)
        {
            reviewsLabel.hidden = NO;
            reviewsButton.hidden = NO;
            [reviewsButton setTitle:[NSString stringWithFormat:@"(%d)", reviewsArrayList.count] forState:UIControlStateNormal];
            [reviewsButton setTitle:[NSString stringWithFormat:@"(%d)", reviewsArrayList.count] forState:UIControlStateHighlighted];
        }
        else
        {
            reviewsLabel.hidden = YES;
            reviewsButton.hidden = YES;
        }
    }
    [indicatorView removeFromSuperview];
}

- (NSString *)stringByStrippingHTML:(NSString *)inputString
{
    NSString *outString;
    
    if (inputString)
    {
        outString = [[NSString alloc] initWithString:inputString];
        NSLog(@"%@", outString);
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
