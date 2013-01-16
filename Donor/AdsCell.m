//
//  AdsCell.m
//  BloodDonor
//
//  Created by Владимир Носков on 27.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdsCell.h"

@implementation AdsCell

@synthesize dateLabel, adsTitleLabel, stationLabel;

- (void)dealloc
{
    [dateLabel release];
    [adsTitleLabel release];
    [stationLabel release];
    [super dealloc];
}

@end
