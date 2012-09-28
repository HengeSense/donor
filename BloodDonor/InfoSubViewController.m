//
//  InfoSubViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 30.07.12.
//
//

#import "InfoSubViewController.h"

@implementation InfoSubViewController

@synthesize delegate;

#pragma mark Actions

- (IBAction)recommendationsButtonPressed:(id)sender
{
    [delegate nextViewSelected:0];
}

- (IBAction)contraindicationListButtonPressed:(id)sender
{
    [delegate nextViewSelected:1];
}

#pragma mark UIWebViewDelegate

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:1; padding:1; } p { color:black; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:right; text-decoration:underline; } a { color:#0B8B99; text-decoration:none; }</style></head><body><p>%@</p></body></html>", @"http://www.podari-zhizn.ru"];
    siteLinkWebView.scrollView.scrollEnabled = NO;
    [siteLinkWebView loadHTMLString:htmlString baseURL:nil];
    
    NSString *phoneString = [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:1; padding:1; } p { color:#DF8D4B; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:right; text-decoration:none; } a { color:#DF8D4B; text-decoration:none; } </style></head><body><p>%@</p></body></html>", @"+7 (495) 471-17-36"];
    phoneLinkWebView.scrollView.scrollEnabled = NO;
    [phoneLinkWebView loadHTMLString:phoneString baseURL:nil];
    
    NSString *emailString = [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:1; padding:1; } p { color:#DF8D4B; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:right; text-decoration:none; } a { color:#DF8D4B; text-decoration:none; } </style></head><body><p>%@</p></body></html>", @"info@donors.ru"];
    emailLinkWebView.scrollView.scrollEnabled = NO;
    [emailLinkWebView loadHTMLString:emailString baseURL:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
