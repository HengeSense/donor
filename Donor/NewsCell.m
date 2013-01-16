//
//  NewsCell.m
//  BloodDonor
//
//  Created by Владимир Носков on 26.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

@synthesize dateLabel, newsTitleLabel;

- (void)dealloc
{
    [dateLabel release];
    [newsTitleLabel release];
    [super dealloc];
}

@end
