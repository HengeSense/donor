//
//  HSTempContraindicationsDataSource.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 04.12.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSTempContraindicationsDataSource.h"
#import "HSContraindication.h"
#import "HSContraindicationCell.h"

@interface HSTempContraindicationsDataSource ()
@property (nonatomic, strong) NSArray *filteredData;
@end

@implementation HSTempContraindicationsDataSource

- (id)initWithData:(NSArray *)data {
    self = [super initWithData:data];
    if (self) {
        self.filteredData = [self allContraindications];
    }
    return self;
}

#pragma mark - UITableViewDataSource protocol implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.filteredData.count) {
        return 0.0f;
    }
    
    HSContraindication *contraindication = [self.filteredData objectAtIndex:indexPath.row];
    NSString *title = contraindication.title;
    NSString *rehabilitation = contraindication.rehabilitation;
    NSUInteger indentation = contraindication.level.integerValue > 0 ? contraindication.level.integerValue : 0;
    return [HSContraindicationCell calculateHightForTitle:title details:rehabilitation indentation:indentation];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * const kTempContraindicationCellId = @"HSContraindicationCell";
    HSContraindicationCell *cell = [tableView dequeueReusableCellWithIdentifier:kTempContraindicationCellId];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HSContraindicationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (indexPath.row < self.filteredData.count) {
        HSContraindication *contraindication = [self.filteredData objectAtIndex:indexPath.row];
        cell.title.text = contraindication.title;
        cell.details.text = contraindication.rehabilitation;
        NSUInteger indentation = contraindication.level.integerValue > 0 ? contraindication.level.integerValue : 0;
        cell.indentationLevel = indentation;

    }
    return cell;
}

- (NSArray *)allContraindications {
    NSMutableArray *children = [[NSMutableArray alloc] init];
    for (HSContraindication *parent in self.data) {
        [self accumulateChildren:children forContraindication:parent];
    }
    return children;
}

- (void)accumulateChildren:(NSMutableArray *)children forContraindication:(HSContraindication *)contraindication {
    [children addObject:contraindication];
    for (HSContraindication *child in contraindication.children) {
        [self accumulateChildren:children forContraindication:child];
    }
}
@end
