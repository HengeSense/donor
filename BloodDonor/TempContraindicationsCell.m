//
//  TempContraindicationsCell.m
//  BloodDonor
//
//  Created by Владимир Носков on 05.08.12.
//
//

#import "TempContraindicationsCell.h"

@implementation TempContraindicationsCell

@synthesize illnessLabel, timeAllotmentLabel, verticalDottedLine;

- (void)dealloc
{
    [illnessLabel release];
    [timeAllotmentLabel release];
    [verticalDottedLine release];
    [super dealloc];
}

@end
