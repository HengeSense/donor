//
//  HSNewsViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 11.04.2013
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSNewsViewController.h"

#import "UIView+HSLayoutManager.h"

#import "MWFeedItem.h"

#pragma mark - Html content constants
static NSString * const kNewsHtml_FileName = @"news_template";
static NSString * const kNewsHtml_FileType = @"html";
static NSString * const kNewsHtmlContentPlaceholder_HeaderDate = @"{HEADER_DATE_PLACEHOLDER}";
static NSString * const kNewsHtmlContentPlaceholder_HeaderTitle = @"{HEADER_TITLE_PLACEHOLDER}";
static NSString * const kNewsHtmlContentPlaceholder_Body = @"{BODY_PACEHOLDER}";
static NSString * const kNewsHtmlContentPlaceholder_FutherReadingLink = @"{FUTHER_READING_LINK_PLACEHOLDER}";
static NSString * const kNewsHtmlContentPlaceholder_FutherReadingText = @"{FUTHER_READING_TEXT_PLACEHOLDER}";

@interface HSNewsViewController ()

@property (nonatomic, strong) MWFeedItem *newsFeedItem;

@end

@implementation HSNewsViewController

#pragma mark - UIWebViewDelegate
-(BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
        navigationType:(UIWebViewNavigationType)navigationType {
    NSURL* url = [request URL];
    if (UIWebViewNavigationTypeLinkClicked == navigationType)
    {
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }
    
    return YES;
}

#pragma mark - Initialization
- (id)initWithNewsFeedItem:(MWFeedItem *)newsFeedItem {
    THROW_IF_ARGUMENT_NIL(newsFeedItem);
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if (self) {
        self.newsFeedItem = newsFeedItem;
    }
    return self;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self loadContent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.newsBodyWebView adjustAsContentView];
}

#pragma mark - Private
#pragma mark - UI cnfiguration
- (void)configureNavigationBar {
    self.title = @"Новости";
}

#pragma mark - Content management
- (void)loadContent {
    // Read HTML template from file
    NSError *readingFileError = nil;
    NSString *newsHtmlFilePath = [[NSBundle mainBundle] pathForResource:kNewsHtml_FileName
            ofType:kNewsHtml_FileType];
    NSMutableString *newsHtmlTemplate = [NSMutableString stringWithContentsOfFile:newsHtmlFilePath
            encoding:NSUTF8StringEncoding error:&readingFileError];
    if (readingFileError) {
        THROW_REQUIRED_RESOURCE_NOT_FOUND(kNewsHtml_FileName, readingFileError);
    }
    
    // Parse HTML template
    NSDateFormatter *newsDateFormatter = [[NSDateFormatter alloc] init];
    [newsDateFormatter setDateStyle:NSDateFormatterShortStyle];
    [newsDateFormatter setDateFormat:@"dd.MM.yyyy"];
    [newsHtmlTemplate replaceOccurrencesOfString:kNewsHtmlContentPlaceholder_HeaderDate
            withString:self.newsFeedItem.date != nil ? [newsDateFormatter stringFromDate:self.newsFeedItem.date] : @""
            options:NSCaseInsensitiveSearch range:NSMakeRange(0, [newsHtmlTemplate length])];
    
    [newsHtmlTemplate replaceOccurrencesOfString:kNewsHtmlContentPlaceholder_HeaderTitle
            withString:self.newsFeedItem.title != nil ? self.newsFeedItem.title : @""
            options:NSCaseInsensitiveSearch range:NSMakeRange(0, [newsHtmlTemplate length])];
    
    [newsHtmlTemplate replaceOccurrencesOfString:kNewsHtmlContentPlaceholder_Body
            withString:self.newsFeedItem.summary != nil ? self.newsFeedItem.summary : @""
            options:NSCaseInsensitiveSearch range:NSMakeRange(0, [newsHtmlTemplate length])];
    
    [newsHtmlTemplate replaceOccurrencesOfString:kNewsHtmlContentPlaceholder_FutherReadingLink
            withString:self.newsFeedItem.link != nil ? self.newsFeedItem.link : @""
            options:NSCaseInsensitiveSearch range:NSMakeRange(0, [newsHtmlTemplate length])];
    
    [newsHtmlTemplate replaceOccurrencesOfString:kNewsHtmlContentPlaceholder_FutherReadingText
            withString:@"Читать дальше..."
            options:NSCaseInsensitiveSearch range:NSMakeRange(0, [newsHtmlTemplate length])];
    
    [self.newsBodyWebView loadHTMLString:newsHtmlTemplate baseURL:nil];
}

@end
