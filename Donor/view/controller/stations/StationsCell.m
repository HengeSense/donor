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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted == YES)
    {
        self.shadowSelectionView.alpha = 0.07f;
    }
    else
    {
        self.shadowSelectionView.alpha = 0.0f;
    }
    self.addressLabel.highlighted = highlighted;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    [super setSelected:selected animated:animated];
    if (self.isEvent)
    {
        if (selected == YES)
        {
            self.shadowSelectionView.alpha = 0.07f;
            self.addressLabel.highlighted = selected;
        }
        else
        {
            self.shadowSelectionView.alpha = 0.0f;
            self.addressLabel.highlighted = selected;
        }
    }
}

@end
