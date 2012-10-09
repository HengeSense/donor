//
//  NewsViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 01.08.12.
//
//

#import "NewsViewController.h"
#import <Foundation/Foundation.h>
//#import "SHK.h"
#import "StationsViewController.h"

@interface NewsViewController ()

@end

static NSString * FACEBOOK_SHARE_URL = @"http://www.facebook.com/sharer.php?u=";
static NSString * TWITTER_SHARE_URL = @"https://twitter.com/share?url=";
static NSString * VKONTAKTE_SHARE_URL = @"http://vkontakte.ru/share.php?url=";

static NSString * PODARI_ZHIZN_NEWS_URL = @"http://www.podari-zhizn.ru/main/node/";

@implementation NewsViewController

#pragma mare Actions

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButtonPressed:(id)sender
{
    [self.navigationController.tabBarController.view addSubview:sharingView];
}

- (IBAction)shareButtonSelected:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *htmlString = @"";
    int nid;
    
    if ([content valueForKey:@"station_nid"])
        nid = [[content objectForKey:@"station_nid"] intValue];
    else
        nid = [[content objectForKey:@"nid"] intValue];
        
    switch (button.tag)
    {
        case 0:
            htmlString = [NSString stringWithFormat:@"%@%@%d", VKONTAKTE_SHARE_URL, PODARI_ZHIZN_NEWS_URL, nid];
            break;
            
        case 1:
            htmlString = [NSString stringWithFormat:@"%@%@%d", TWITTER_SHARE_URL, PODARI_ZHIZN_NEWS_URL, nid];
            break;
            
        case 2:
            htmlString = [NSString stringWithFormat:@"%@%@%d", FACEBOOK_SHARE_URL, PODARI_ZHIZN_NEWS_URL, nid];
            break;
            
        default:
            break;
    }
    [sharingView removeFromSuperview];
    
    if (![htmlString isEqualToString:@""])
    {
        NSURL *url = [NSURL URLWithString:htmlString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (IBAction)showAtMapPressed:(id)sender
{
    UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 331)];
    indicatorView.backgroundColor = [UIColor blackColor];
    indicatorView.alpha = 0.5f;
    UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    indicator.frame = CGRectMake(160 - indicator.frame.size.width / 2.0f,
                                 240 - indicator.frame.size.height / 2.0f,
                                 indicator.frame.size.width,
                                 indicator.frame.size.height);
    
    [indicatorView addSubview:indicator];
    [indicator startAnimating];
    [self.navigationController.tabBarController.view addSubview:indicatorView];
    
    PFQuery *stations = [PFQuery queryWithClassName:@"Stations"];
    [stations getObjectInBackgroundWithId:[content valueForKey:@"station_id"] block:^(PFObject *object, NSError *error)
    {
        if (object)
        {
            StationsViewController *controller = [[[StationsViewController alloc] initWithNibName:@"StationsViewController" bundle:nil station:object] autorelease];
            //[controller showOnMap:object];
            [self.navigationController pushViewController:controller animated:YES];
        }
        [indicatorView removeFromSuperview];
        [indicatorView release];
    }];
    
}

#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{ 
    if ([content valueForKey:@"station_nid"])
    {
        if ([content valueForKey:@"station_id"])
        {
            adsView.frame = CGRectMake(0, newBodyWebView.scrollView.contentSize.height + 20.0f, 320, 48);
            [newBodyWebView.scrollView addSubview:adsView];
            CGSize newContentSize = newBodyWebView.scrollView.contentSize;
            newContentSize.height += adsView.frame.size.height;
            newBodyWebView.scrollView.contentSize = newContentSize;
        }
        
    }
    else
    {
        [newBodyWebView.scrollView addSubview:newsView];
    }
    
    for (UIView* subView in [newBodyWebView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            for (UIView* shadowView in [subView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]])
                {
                    [shadowView setHidden:YES];
                }
            }
        }
    }
}

-(BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedNew:(PFObject *)selectedNew
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        content = selectedNew;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Новости";
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *shareImageNormal = [UIImage imageNamed:@"shareButtonNormal"];
    UIImage *shareImagePressed = [UIImage imageNamed:@"shareButtonPressed"];
    CGRect shareButtonFrame = CGRectMake(0, 0, shareImageNormal.size.width, shareImageNormal.size.height);
    [shareButton setImage:shareImageNormal forState:UIControlStateNormal];
    [shareButton setImage:shareImagePressed forState:UIControlStateHighlighted];
    shareButton.frame = shareButtonFrame;
    [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shareBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:shareButton] autorelease];
    self.navigationItem.rightBarButtonItem = shareBarButtonItem;
    
    CGSize contentSize;
    CGSize maximumLabelSize = CGSizeMake(320, 9999);
    NSString *htmlString1 = @"";
    
    int padding_top;
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    NSDateFormatter *parsecomDateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [parsecomDateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:sszzz"];
   
    //Ads
    if ([content valueForKey:@"station_nid"])
    {
        NSString *createString = [dateFormat stringFromDate:[parsecomDateFormat dateFromString:[[NSString stringWithFormat:@"%@", [content objectForKey:@"created"]] stringByReplacingCharactersInRange:NSMakeRange(22, 1) withString:@""]]];
        
        htmlString1 = [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:0; padding:0; } p { color:#847168; font-family:Helvetica; font-size:12px; font-weight:bold;  }</style></head><body><p>%@ <font color=\"#CBB2A3\">%@</font></p></body></html>", createString, [content valueForKey:@"title"]];
        padding_top = 7;
        
        CGSize htmlString1Size = [[NSString stringWithFormat:@"%@ %@", createString, [content valueForKey:@"title"]] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
        contentSize = htmlString1Size;
    }
    //News
    else
    {
        titleLabel.text = [content valueForKey:@"title"];
        padding_top = 19;
    }
    
    NSString *bodyString = [self stringByStrippingHTML:[content valueForKey:@"body"]];
     
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:0; padding-top:%d; padding-left:6; padding-right:6; } p { color:#847168; font-family:Helvetica; font-size:12px; font-weight:bold;  } a { color:#0B8B99; text-decoration:underline; } h1 { color:#CBB2A3; font-family:Helvetica; font-size:15px; font-weight:bold; }</style></head><body><p><br />%@</p></body></html>", padding_top, bodyString];
    
    CGSize htmlStringSize = [[NSString stringWithFormat:@"%@", bodyString] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:24] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    
    contentSize.height += htmlStringSize.height + 25.0f;
    
    [newBodyWebView loadHTMLString:[NSString stringWithFormat:@"%@%@", htmlString1, htmlString] baseURL:nil];
    
    newBodyWebView.scrollView.contentSize = contentSize;
}

- (NSString *)stringByStrippingHTML:(NSString *)inputString
{
    NSString *outString;
    
    if (inputString)
    {
        outString = [[NSString alloc] initWithString:inputString];
        
        if ([inputString length] > 0)
        {
            NSArray *entities = [[NSArray alloc] initWithObjects:@" **", @"** ", @"_**", @"**_", @"**", @".**", nil];
            NSArray *plainText = [[NSArray alloc] initWithObjects:@" <i>",@"</i> ", @" <i>",@"</i> ", @"<i>",@".</i>", nil];
            
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

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [super dealloc];
}

@end
