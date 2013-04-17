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

@interface HSSocailShareViewController ()

@end

@implementation HSSocailShareViewController

#pragma mark - UI Actions
- (IBAction)shareVkontakte:(id)sender {
    CHECK_NOT_NIL_PRECONDITION(self.shareUrl);
    NSString *link = [NSString stringWithFormat:@"%@%@", VKONTAKTE_SHARE_URL, self.shareUrl];
    [self goToURL:[NSURL URLWithString:link]];
}

- (IBAction)shareTwitter:(id)sender {
    CHECK_NOT_NIL_PRECONDITION(self.shareUrl);
    NSString *link = [NSString stringWithFormat:@"%@%@", TWITTER_SHARE_URL, self.shareUrl];
    [self goToURL:[NSURL URLWithString:link]];
}

- (IBAction)shareFacebook:(id)sender {
    CHECK_NOT_NIL_PRECONDITION(self.shareUrl);
    NSString *link = [NSString stringWithFormat:@"%@%@", FACEBOOK_SHARE_URL, self.shareUrl];
    [self goToURL:[NSURL URLWithString:link]];
}

- (IBAction)cancel:(id)sender {
    [self hideModal];
}

#pragma mark - Utility
- (void)goToURL:(NSURL *)url {
    THROW_IF_ARGUMENT_NIL(url);
    [self hideModal];
    [[UIApplication sharedApplication] openURL:url];
}

@end
