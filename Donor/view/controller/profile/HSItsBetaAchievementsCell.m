//
//  HSItsBetaAchievementsCell.m
//  Donor
//
//  Created by Alexander Trifonov on 4/5/13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSItsBetaAchievementsCell.h"

#import "ItsBeta.h"

@implementation HSItsBetaAchievementsCell

- (void) setObjectTemplate:(ItsBetaObjectTemplate*)objectTemplate {
    if(objectTemplate != nil) {
        _objectTemplate = objectTemplate;
        
        [[self imageView] setImage:[[_objectTemplate image] data]];
        [[self nameLable] setText:[[_objectTemplate internal] valueAtName:@"display_name"]];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self == nil) {
    }
    return self;
}

@end
