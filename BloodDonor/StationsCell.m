//
//  StationsCell.m
//  BloodDonor
//
//  Created by Владимир Носков on 06.08.12.
//
//

#import <QuartzCore/QuartzCore.h>
#import "StationsCell.h"

@implementation StationsCell
@synthesize workAtSaturdayImageView, donorsForChildrenImageView, regionalRegistrationImageView, shadowSelectionView, indicatorView;
@synthesize addressLabel = _addressLabel;

- (void)dealloc
{
    [_addressLabel release];
    [regionalRegistrationImageView release];
    [workAtSaturdayImageView release];
    [donorsForChildrenImageView release];
    [shadowSelectionView release];
    [indicatorView release];
    [super dealloc];
}

@end
