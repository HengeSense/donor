//
//  HSStationsViewController.h
//  Donor
//
//  Created by Eugine Korobovsky on 03.04.13.
//  Updated by Sergey Seroshtan on 24.05.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "HSStationInfo.h"

@interface HSStationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

/// @name UI properties
@property (nonatomic, strong) IBOutlet UITableView *stationsTable;
@property (nonatomic, strong) IBOutlet UILabel *curCityLabel;

@property (nonatomic, strong) NSArray *stations;
@property (nonatomic, strong) NSDictionary *regionsDictionary;

@property (nonatomic, strong) NSMutableDictionary *stationsByDistance;

@property (nonatomic, strong) HSStationInfo *selectedStationInfo;

@property (nonatomic) NSInteger region_id;
@property (nonatomic) NSInteger district_id;

- (void)saveLastChoice;
- (void)requestCurrentRegionAreaWithRegionName:(NSString *)regionName;

/**
 * Find and select station by specifed address.
 */
- (void)selectStationByAddress:(NSString *)address;

/// @name Protected
/// @name UI configuration
- (void)configureUI;
- (void)configureNavigationBar;
- (void)configureSearchBar;


@end
