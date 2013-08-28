//
//  AdViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 01.08.12.
//
//

#import "AdViewController.h"

#import "MBProgressHUD.h"
#import "UIView+HSLayoutManager.h"
#import "HSSocailShareViewController.h"

#import "HSStationsViewController.h"

static NSString * kShareBaseUrl_PodariZhizn = @"http://www.podari-zhizn.ru/main/node/";

@interface AdViewController ()

@property (nonatomic, strong) HSSocailShareViewController *socailShareViewController;

@end

@implementation AdViewController

#pragma mare Actions

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButtonPressed:(id)sender
{
    if (self.socailShareViewController == nil) {
        self.socailShareViewController =
                [[HSSocailShareViewController alloc] initWithNibName:@"HSSocailShareViewController" bundle:nil];
    }
    NSInteger newsId = [self.content valueForKey:@"station_nid"] ?
            [[self.content objectForKey:@"station_nid"] integerValue] :
            [[self.content objectForKey:@"nid"] integerValue];
    NSString *shareUrl = [NSString stringWithFormat:@"%@%d", kShareBaseUrl_PodariZhizn, newsId];
    self.socailShareViewController.shareUrl = shareUrl;
    [self.socailShareViewController showModal];
}

- (IBAction)showAtMapPressed:(id)sender
{
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    PFQuery *stations = [PFQuery queryWithClassName:@"Stations"];
    [stations getObjectInBackgroundWithId:[self.content valueForKey:@"station_id"]
                                    block:^(PFObject *object, NSError *error)
    {
        [progressHud hide:YES];
        if (object)
        {
            HSStationsViewController *controller = [[HSStationsViewController alloc]
                    initWithNibName:NSStringFromClass([HSStationsViewController class]) bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
}

#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{ 
    if ([self.content valueForKey:@"station_nid"])
    {
        if ([self.content valueForKey:@"station_id"])
        {
            self.adsView.frame = CGRectMake(0, self.newsBodyWebView.scrollView.contentSize.height + 20.0f, 320, 48);
            [self.newsBodyWebView.scrollView addSubview:self.adsView];
            CGSize newContentSize = self.newsBodyWebView.scrollView.contentSize;
            newContentSize.height += self.adsView.frame.size.height;
            self.newsBodyWebView.scrollView.contentSize = newContentSize;
        }
    }
    else
    {
        [self.newsBodyWebView.scrollView addSubview:self.newsView];
    }
    
    for (UIView* subView in [self.newsBodyWebView subviews])
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
        self.content = selectedNew;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Объявление";
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *shareImageNormal = [UIImage imageNamed:@"shareButtonNormal"];
    UIImage *shareImagePressed = [UIImage imageNamed:@"shareButtonPressed"];
    CGRect shareButtonFrame = CGRectMake(0, 0, shareImageNormal.size.width, shareImageNormal.size.height);
    [shareButton setImage:shareImageNormal forState:UIControlStateNormal];
    [shareButton setImage:shareImagePressed forState:UIControlStateHighlighted];
    shareButton.frame = shareButtonFrame;
    [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = shareBarButtonItem;
    
    NSString *htmlString1 = @"";
    
    int padding_top;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    NSDateFormatter *parsecomDateFormat = [[NSDateFormatter alloc] init];
    [parsecomDateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:sszzz"];
   
    //Ads
    if ([self.content valueForKey:@"station_nid"])
    {
        NSString *createString = [dateFormat stringFromDate:[parsecomDateFormat dateFromString:[[NSString stringWithFormat:@"%@", [self.content objectForKey:@"created"]] stringByReplacingCharactersInRange:NSMakeRange(22, 1) withString:@""]]];
        
        htmlString1 = [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:0; padding:0; } p { color:#847168; font-family:Helvetica; font-size:12px; font-weight:bold;  }</style></head><body><p>%@ <font color=\"#CBB2A3\">%@</font></p></body></html>", createString, [self.content valueForKey:@"title"]];
        padding_top = 1;
    }
    //News
    else
    {
        self.titleLabel.text = [self.content valueForKey:@"title"];
        padding_top = 1;
    }
    
    NSString *bodyString = [self stringByStrippingHTML:[self.content valueForKey:@"body"]];
     
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:0; padding-top:%d; padding-left:6; padding-right:6; } p { color:#847168; font-family:Helvetica; font-size:12px; font-weight:bold;  } a { color:#0B8B99; text-decoration:underline; } h1 { color:#CBB2A3; font-family:Helvetica; font-size:15px; font-weight:bold; }</style></head><body><p><br />%@</p></body></html>", padding_top, bodyString];
    
    [self.newsBodyWebView loadHTMLString:[NSString stringWithFormat:@"%@%@", htmlString1, htmlString] baseURL:nil];
}

- (NSString *)stringByStrippingHTML:(NSString *)inputString
{
    NSString *outString = nil;
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.newsBodyWebView adjustAsContentView];
}

@end
