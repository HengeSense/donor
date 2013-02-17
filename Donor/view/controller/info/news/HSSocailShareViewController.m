//
//  HSSocailShareViewController.m
//  Donor
//
//  Created by Sergey Seroshtan on 17.02.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSSocailShareViewController.h"

static NSString * FACEBOOK_SHARE_URL = @"http://www.facebook.com/sharer.php?u=";
static NSString * TWITTER_SHARE_URL = @"https://twitter.com/share?url=";
static NSString * VKONTAKTE_SHARE_URL = @"http://vkontakte.ru/share.php?url=";

static NSString * PODARI_ZHIZN_NEWS_URL = @"http://www.podari-zhizn.ru/main/node/";

@interface HSSocailShareViewController ()

@end

@implementation HSSocailShareViewController

#pragma mark - UI Actions
- (IBAction)shareVkontakte:(id)sender {
    NSString *link = [NSString stringWithFormat:@"%@%@%d", VKONTAKTE_SHARE_URL, PODARI_ZHIZN_NEWS_URL, self.newsId];
    [self goToURL:[NSURL URLWithString:link]];
}

- (IBAction)shareTwitter:(id)sender {
    NSString *link = [NSString stringWithFormat:@"%@%@%d", TWITTER_SHARE_URL, PODARI_ZHIZN_NEWS_URL, self.newsId];
    [self goToURL:[NSURL URLWithString:link]];
}

- (IBAction)shareFacebook:(id)sender {
    NSString *link = [NSString stringWithFormat:@"%@%@%d", FACEBOOK_SHARE_URL, PODARI_ZHIZN_NEWS_URL, self.newsId];
    [self goToURL:[NSURL URLWithString:link]];
}

- (IBAction)cancel:(id)sender {
    [self hideModal];
}

#pragma mark - Utility
- (void)goToURL:(NSURL *)url {
    THROW_IF_ARGUMENT_NIL(url, @"url is new specified");
    [self hideModal];
    [[UIApplication sharedApplication] openURL:url];
}

@end
