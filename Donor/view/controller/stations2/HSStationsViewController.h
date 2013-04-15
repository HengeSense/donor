//
//  HSStationsViewController.h
//  Donor
//
//  Created by Eugine Korobovsky on 03.04.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface HSStationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UISearchDisplayDelegate> {
    NSUInteger selectedCity;
    BOOL isSyncInProgress;
    BOOL isSearchBarShowed;
    CLLocationCoordinate2D curLocation;
    BOOL isCitySelectedByGeolocationOnceAtThisSession;
}

@property (nonatomic, strong) IBOutlet UITableView *stationsTable;
//@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
//@property (nonatomic, strong) IBOutlet UISearchDisplayController *searchController;
@property (nonatomic, strong) IBOutlet UILabel *curCityLabel;

@property (nonatomic, strong) NSMutableArray *stationsArray;
@property (nonatomic, strong) NSMutableDictionary *regionsDictionary;
@property (nonatomic, strong) NSMutableDictionary *stationsByDistance;

@property (nonatomic) NSInteger region_id;
@property (nonatomic) NSInteger district_id;

- (void)saveLastChoice;
- (void)requestCurrentRegionAreaWithRegionName:(NSString *)regionName;


@end
