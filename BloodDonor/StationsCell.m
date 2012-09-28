//
//  StationsCell.m
//  BloodDonor
//
//  Created by Владимир Носков on 06.08.12.
//
//

#import "StationsCell.h"

@implementation StationsCell
@synthesize addressLabel, workAtSaturdayImageView, donorsForChildrenImageView, regionalRegistrationImageView, shadowSelectionView;

- (void)dealloc
{
    [addressLabel release];
    [regionalRegistrationImageView release];
    [workAtSaturdayImageView release];
    [donorsForChildrenImageView release];
    [shadowSelectionView release];
    [super dealloc];
}

@end
