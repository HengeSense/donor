//
//  HSAbsoluteContraindicationsDataSource.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 04.12.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSAbsoluteContraindicationsDataSource.h"
#import "HSContraindication.h"
#import "HSContraindicationCell.h"

#import <Parse/Parse.h>

@implementation HSAbsoluteContraindicationsDataSource

#pragma mark - UITableViewDataSource protocol implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSContraindication *contraindication = [self contraindicationAtIndexPath:indexPath];
    NSUInteger indentation = contraindication.level.integerValue > 0 ? contraindication.level.integerValue - 1: 0;
    return [HSContraindicationCell calculateHightForTitle:contraindication.title
                                                  details:contraindication.rehabilitation
                                              indentation:indentation];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *background =
            [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contraindicationsSectionBackground"]] ;
    UIView *headerView = [[UIView alloc] initWithFrame:background.bounds];
    [headerView addSubview:background];
    
    HSContraindication *contraindication = [self.data objectAtIndex:section];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 320, 14)];
    headerLabel.text = contraindication.title;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
    headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [headerView addSubview:headerLabel];

    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self calculateNumberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * const kAbsoluteContraindicationCellIdentifier = @"HSContraindicationCell";
    HSContraindicationCell *cell =
            [tableView dequeueReusableCellWithIdentifier:kAbsoluteContraindicationCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HSContraindicationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    HSContraindication *contraindication = [self contraindicationAtIndexPath:indexPath];
    cell.title.text = contraindication.title;
    cell.details.text = contraindication.rehabilitation;
    NSUInteger indentation = contraindication.level.integerValue > 0 ? contraindication.level.integerValue - 1 : 0;
    cell.indentationLevel = indentation;
    return cell;
}

#pragma mark - Private interface implementation
- (NSInteger)calculateNumberOfRowsInSection:(NSInteger)section {
    if (section < self.data.count) {
        HSContraindication *contraindication = [self.data objectAtIndex:section];
        return [self countChildrenForContraindication:contraindication];
    }
    return 0;
}

- (NSArray *)childrenForContraindication:(HSContraindication *)contraindication {
    NSMutableArray *children = [[NSMutableArray alloc] init];
    for (HSContraindication *child in contraindication.children) {
        [self accumulateChildren:children forContraindication:child];
    }
    return children;
}

- (void)accumulateChildren:(NSMutableArray *)children forContraindication:(HSContraindication *)contraindication {
    [children addObject:contraindication];
    for (HSContraindication *child in contraindication.children) {
        [self accumulateChildren:children forContraindication:child];
    }
}

- (NSUInteger)countChildrenForContraindication:(HSContraindication *)contraindication {
    return [[self childrenForContraindication:contraindication] count];
}

- (HSContraindication *)contraindicationAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.data.count) {
        HSContraindication *parentContraindication = [self.data objectAtIndex:indexPath.section];
        NSArray *childContraindications = [self childrenForContraindication:parentContraindication];
        if (indexPath.row < childContraindications.count) {
            HSContraindication *childContraindication = [childContraindications objectAtIndex:indexPath.row];
            return childContraindication;
        }
    }
    return nil;
}

@end
