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
@synthesize workAtSaturdayImageView, donorsForChildrenImageView, regionalRegistrationImageView, shadowSelectionView, indicatorView, isEvent;
@synthesize addressLabel = _addressLabel;

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted == YES)
    {
        shadowSelectionView.alpha = 0.07f;
    }
    else
    {
        shadowSelectionView.alpha = 0.0f;
    }
    self.addressLabel.highlighted = highlighted;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    [super setSelected:selected animated:animated];
    if (isEvent)
    {
        if (selected == YES)
        {
            shadowSelectionView.alpha = 0.07f;
            self.addressLabel.highlighted = selected;
        }
        else
        {
            shadowSelectionView.alpha = 0.0f;
            self.addressLabel.highlighted = selected;
        }
    }
}

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
