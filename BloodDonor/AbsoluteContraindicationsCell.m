//
//  AbsoluteContraindicationsCell.m
//  BloodDonor
//
//  Created by Владимир Носков on 14.08.12.
//
//

#import "AbsoluteContraindicationsCell.h"

@implementation AbsoluteContraindicationsCell

@synthesize illnessLabel;

- (void)dealloc
{
    [illnessLabel release];
    [super dealloc];
}

@end
