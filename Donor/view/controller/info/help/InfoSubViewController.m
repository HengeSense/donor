//
//  InfoSubViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 30.07.12.
//  Updated by Sergey Seroshtan on 26.02.13.
//  Copyright (c) 2012 HintSolution. All rights reserved.
//

#import "InfoSubViewController.h"
#import "HSContactView.h"

#import "UIView+HSLayoutManager.h"

@implementation InfoSubViewController

#pragma mark Actions
- (IBAction)recommendationsButtonPressed:(id)sender {
    [self.delegate nextViewSelected:0];
}

- (IBAction)contraindicationListButtonPressed:(id)sender {
    [self.delegate nextViewSelected:1];
}

#pragma mark Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureContacts];
}

#pragma mark - UI configuration
- (void)configureContacts {
    NSArray *phones = @[@"8 800 333 33 30"];
    NSArray *emails = @[@"info@yadonor.ru"];
    NSString *site = @"http://yadonor.ru/";
    NSString *siteProject = @"www.donorapp.ru";
    
    CGFloat contentOffsetY = 0.0f;
    for (NSString *phone in phones) {
        HSContactView *contactView = [[HSContactView alloc] initWithContact:[self htmlFromPhone:phone]
                                                               contactTitle:@"Телефон"];
        [contactView moveFrameY:contentOffsetY];
        [self.contactsScrollView addSubview:contactView];
        
        contentOffsetY += contactView.frame.size.height;
    }
    
    for (NSString *email in emails) {
        HSContactView *contactView = [[HSContactView alloc] initWithContact:[self htmlFromEmail:email]
                                                               contactTitle:@"E-mail"];
        [contactView moveFrameY:contentOffsetY];
        [self.contactsScrollView addSubview:contactView];
        
        contentOffsetY += contactView.frame.size.height;
    }
    
    {
        HSContactView *contactView = [[HSContactView alloc] initWithContact:[self htmlFromSiteLink:site]
                                                               contactTitle:@"Сайт"];
        contactView.showFooterLine = NO;
        [contactView moveFrameY:contentOffsetY];
        [self.contactsScrollView addSubview:contactView];
        
        contentOffsetY += contactView.frame.size.height;
    }
    
    {
        HSContactView *contactView = [[HSContactView alloc] initWithContact:[self htmlFromSiteLink:siteProject]
                                                               contactTitle:@"Сайт проекта"];
        contactView.showFooterLine = YES;
        [contactView moveFrameY:contentOffsetY];
        [self.contactsScrollView addSubview:contactView];
        
        contentOffsetY += contactView.frame.size.height;
    }

    self.contactsScrollView.contentSize = CGSizeMake(self.contactsScrollView.bounds.size.width, contentOffsetY);
}

#pragma mark - HTML wrappers
- (NSString *)htmlFromPhone:(NSString *)phone {
    THROW_IF_ARGUMENT_NIL(phone, @"phone is not specified");
    
   return [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:1; padding:1; } p { color:#DF8D4B; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:right; text-decoration:none; } a { color:#DF8D4B; text-decoration:none; } </style></head><body><p>%@</p></body></html>", phone];
}
#pragma mark UI configuration
- (NSString *)htmlFromSiteLink:(NSString *)siteLink {
    THROW_IF_ARGUMENT_NIL(siteLink, @"siteLink is not specified");
    return [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:1; padding:1; } p { color:black; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:right; text-decoration:underline; } a { color:#0B8B99; text-decoration:none; }</style></head><body><p><a href='%@'>%@</a></p></body></html>", siteLink, siteLink];
}

- (NSString *)htmlFromEmail:(NSString *)email {
    THROW_IF_ARGUMENT_NIL(email, @"email is not specified");
    
    return [NSString stringWithFormat:@"<html><head><style type='text/css'>* { margin:1; padding:1; } p { color:#DF8D4B; font-family:Helvetica; font-size:12px; font-weight:bold; text-align:right; text-decoration:none; } a { color:#DF8D4B; text-decoration:none; } </style></head><body><p><a href='mailto:%@'>%@</a></p></body></html>", email, email];
}
@end
