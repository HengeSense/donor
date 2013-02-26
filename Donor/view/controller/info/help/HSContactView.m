//
//  HSContactView.m
//  Donor
//
//  Created by Sergey Seroshtan on 26.02.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSContactView.h"

@interface HSContactView () <UIWebViewDelegate>

/// @name UI properties
@property (weak, nonatomic) IBOutlet UILabel *contactTitleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *contactWebView;
@property (weak, nonatomic) IBOutlet UIImageView *footerLinemageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerLineImageView;

@end

@implementation HSContactView

- (id)initWithContact:(NSString *)contact contactTitle:(NSString *)contactTitle {
    self = [[[NSBundle mainBundle] loadNibNamed:@"HSContactView" owner:self options:nil] lastObject];
    if (self) {
        self.contact = contact;
        self.contactTile = contactTitle;
        self.showHeaderLine = YES;
        self.showFooterLine = NO;
        self.contactWebView.delegate = self;
        self.contactWebView.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews {
    self.contactTitleLabel.text = self.contactTile;

    [self.contactWebView loadHTMLString:self.contact baseURL:nil];
    self.contactWebView.scrollView.scrollEnabled = NO;
    
    self.headerLineImageView.hidden = !self.showHeaderLine;
    self.footerLinemageView.hidden = !self.showFooterLine;
    
    [super layoutSubviews];
}

#pragma mark UIWebViewDelegate
-(BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
        navigationType:(UIWebViewNavigationType)navigationType {
    NSURL* url = [request URL];
    if (UIWebViewNavigationTypeLinkClicked == navigationType) {
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }
    return YES;
}

@end
