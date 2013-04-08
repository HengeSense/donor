//
//  HSItsBetaAchievementsHeader.m
//  Donor
//
//  Created by Alexander Trifonov on 4/8/13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSItsBetaAchievementsHeader.h"

@implementation HSItsBetaAchievementsHeader

- (void) setTitle:(NSString*)title {
    if(_title != title) {
        _title = title;
        
        [[self titleView] setText:_title];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil) {
    }
    return self;
}

@end
