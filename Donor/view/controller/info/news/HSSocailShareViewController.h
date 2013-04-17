//
//  HSSocailShareViewController.h
//  Donor
//
//  Created by Sergey Seroshtan on 17.02.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSModalViewController.h"

@interface HSSocailShareViewController : HSModalViewController

/// @name Configuration properties
@property (nonatomic, strong) NSString *shareUrl;

/// @name Actions
- (IBAction)shareVkontakte:(id)sender;
- (IBAction)shareTwitter:(id)sender;
- (IBAction)shareFacebook:(id)sender;

- (IBAction)cancel:(id)sender;
@end
