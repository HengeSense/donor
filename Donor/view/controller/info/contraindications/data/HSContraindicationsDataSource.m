//
//  HSContraindicationsDataSource.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 04.12.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSContraindicationsDataSource.h"

#import <Parse/Parse.h>

@interface HSContraindicationsDataSource ()
@property (strong, nonatomic) NSArray *data;
@end

@implementation HSContraindicationsDataSource

#pragma mark - Initialization
- (id)initWithData:(NSArray *)data {
    self = [super init];
    if (self) {
        self.data = data;
    }
    return self;
}

#pragma mark - Data filtering
- (void)filterDataByValue:(NSString *)filter {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Should be implemented in subclasses" userInfo:nil];
}

- (void)clearFilter {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Should be implemented in subclasses" userInfo:nil];
}

@end
