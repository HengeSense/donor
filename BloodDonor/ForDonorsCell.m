//
//  ForDonorsCell.m
//  BloodDonor
//
//  Created by Vladimir Noskov on 12.10.12.
//
//

#import "ForDonorsCell.h"

@implementation ForDonorsCell

@synthesize titleLabel, descriptionLabel;

- (void)dealloc
{
    [titleLabel release];
    [descriptionLabel release];
    [super dealloc];
}

@end
