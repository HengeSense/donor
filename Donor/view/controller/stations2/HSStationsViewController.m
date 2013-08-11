//
//  HSStationsViewController.m
//  Donor
//
//  Created by Eugine Korobovsky on 03.04.13.
//  Updated by Sergey Seroshtan on 24.05.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSStationsViewController.h"
#import "HSStationsSelectCityViewController.h"
#import "HSStationCardViewController.h"
#import "HSStationsMapViewController.h"

#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "HSHTTPControl.h"
#import "StationsDefs.h"

#pragma mark - UI labels
static NSString * const kLabelTitle_UnknownRegion = @"Неизвестный регион";

#pragma mark - User defaults keys
static NSString * const kUserDefaultsKey_LastSelectedRegion = @"lastSelectedRegion";
static NSString * const kUserDefaultsKey_LastSelectedDistrict = @"lastSelectedDistrict";

#pragma mark - Stations filtering by distance keys
static NSString * const kStationsFilteringByDistanceKey_LessThan1 = @"lessThan1";
static NSString * const kStationsFilteringByDistanceKey_LessThan3 = @"lessThan3";
static NSString * const kStationsFilteringByDistanceKey_LessThan5 = @"lessThan5";
static NSString * const kStationsFilteringByDistanceKey_LessThan10 = @"lessThan10";
static NSString * const kStationsFilteringByDistanceKey_LessThan15 = @"lessThan15";
static NSString * const kStationsFilteringByDistanceKey_MoreThan15 = @"moreThan15";

#pragma mark - UI tags
static const NSUInteger kCellRegionLabelTag = 10;
static const NSUInteger kCellSeparatorViewTag = 11;

#pragma mark - Region constants
static const NSUInteger kRegions_UndefinedId = -1;

#pragma mark - District constants
static const NSUInteger kDistrict_UndefinedId = -1;

#pragma mark - Stations database
static const NSUInteger kStationsDatabase_FullSyncPeriod = 31;
static NSString * const kStationsDatabase_FullSyncLastDate = @"kStationsDatabase_FullSyncLastDate";
static NSString * const kStationsDatabase_SyncLastDate = @"latestStationsChangedDate";
static NSString * const kStationsDatabase_CurrentVersionKey = @"kStationsDatabase_CurrentVersionKey";

@interface HSStationsViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UISearchDisplayDelegate>

@property (nonatomic, assign) NSUInteger selectedCity;
@property (nonatomic, assign) BOOL isSyncInProgress;
@property (nonatomic, assign) BOOL isSearchBarShown;
@property (nonatomic, assign) CLLocationCoordinate2D curLocation;
@property (nonatomic, assign) BOOL isCitySelectedByGeolocationOnceAtThisSession;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL blockDidScrollDelegateCall;

@property (nonatomic, strong) HSStationsMapViewController *mapController;

@property (nonatomic, strong) NSMutableDictionary *filteredDictionary;

@end


@implementation HSStationsViewController

#pragma mark - View's lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isSyncInProgress = NO;
        self.isCitySelectedByGeolocationOnceAtThisSession = NO;
        
        NSMutableArray *lessThan1 = [[NSMutableArray alloc] init];
        NSMutableArray *lessThan3 = [[NSMutableArray alloc] init];
        NSMutableArray *lessThan5 = [[NSMutableArray alloc] init];
        NSMutableArray *lessThan10 = [[NSMutableArray alloc] init];
        NSMutableArray *lessThan15 = [[NSMutableArray alloc] init];
        NSMutableArray *moreThan15 = [[NSMutableArray alloc] init];
        self.stationsByDistance = [[NSMutableDictionary alloc] init];
        [self.stationsByDistance setObject:lessThan1 forKey:kStationsFilteringByDistanceKey_LessThan1];
        [self.stationsByDistance setObject:lessThan3 forKey:kStationsFilteringByDistanceKey_LessThan3];
        [self.stationsByDistance setObject:lessThan5 forKey:kStationsFilteringByDistanceKey_LessThan5];
        [self.stationsByDistance setObject:lessThan10 forKey:kStationsFilteringByDistanceKey_LessThan10];
        [self.stationsByDistance setObject:lessThan15 forKey:kStationsFilteringByDistanceKey_LessThan15];
        [self.stationsByDistance setObject:moreThan15 forKey:kStationsFilteringByDistanceKey_MoreThan15];
        
        NSMutableArray *lessThan1filter = [[NSMutableArray alloc] init];
        NSMutableArray *lessThan3filter = [[NSMutableArray alloc] init];
        NSMutableArray *lessThan5filter = [[NSMutableArray alloc] init];
        NSMutableArray *lessThan10filter = [[NSMutableArray alloc] init];
        NSMutableArray *lessThan15filter = [[NSMutableArray alloc] init];
        NSMutableArray *moreThan15filter = [[NSMutableArray alloc] init];
        self.filteredDictionary = [[NSMutableDictionary alloc] init];
        [self.filteredDictionary setObject:lessThan1filter forKey:kStationsFilteringByDistanceKey_LessThan1];
        [self.filteredDictionary setObject:lessThan3filter forKey:kStationsFilteringByDistanceKey_LessThan3];
        [self.filteredDictionary setObject:lessThan5filter forKey:kStationsFilteringByDistanceKey_LessThan5];
        [self.filteredDictionary setObject:lessThan10filter forKey:kStationsFilteringByDistanceKey_LessThan10];
        [self.filteredDictionary setObject:lessThan15filter forKey:kStationsFilteringByDistanceKey_LessThan15];
        [self.filteredDictionary setObject:moreThan15filter forKey:kStationsFilteringByDistanceKey_MoreThan15];
        
        self.selectedCity = 0;
        self.curLocation = CLLocationCoordinate2DMake(0, 0);
        self.isSearchBarShown = NO;

        self.mapController = [[HSStationsMapViewController alloc] initWithStations:self.stations];
        
        self.blockDidScrollDelegateCall = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    [self loadStations];
    [self reloadMapViewController];
    [self loadLastChoice];
}

- (void)configureUI {
    self.title = @"Cтанции";
    [self configureNavigationBar];
    [self configureSearchBar];
}

- (void)configureNavigationBar {
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarBtn.frame = CGRectMake(0.0, 0.0, 33.0, 30.0);
    [rightBarBtn setImage:[UIImage imageNamed:@"DonorStations_navBarMapBtn_norm"] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@"DonorStations_navBarMapBtn_press"] forState:UIControlStateHighlighted];
    [rightBarBtn addTarget:self action:@selector(onShowMap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)configureSearchBar {
    UIImage *searchBarImage = [UIImage imageNamed:@"DonorStations_searchBarBackground"];
    [self.searchDisplayController.searchBar setBackgroundImage:searchBarImage];
    [self.searchDisplayController.searchBar setImage:[UIImage imageNamed:@"DonorStations_searchBarSearchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchDisplayController.searchBar setImage:[UIImage imageNamed:@"DonorStations_searchBarClearIcon"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    self.searchDisplayController.searchBar.tintColor = DONOR_RED_COLOR;
    
    UIImage *searchFieldImage = [[UIImage imageNamed:@"DonorStations_searchBarFieldBackground"] stretchableImageWithLeftCapWidth:20 topCapHeight:4];
    [self.searchDisplayController.searchBar setSearchFieldBackgroundImage:searchFieldImage
            forState:UIControlStateNormal];
    for (UIView *oneView in self.searchDisplayController.searchBar.subviews) {
        if ([oneView isKindOfClass:[UITextField class]]) {
            ((UITextField *)oneView).textColor = DONOR_SEARCH_FIELD_TEXT_COLOR;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestUserLocation];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.locationManager) {
        [self.locationManager stopUpdatingLocation];
    }
}

#pragma mark - View Controller's routines
- (void)saveLastChoice {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInt:self.region_id] forKey:kUserDefaultsKey_LastSelectedRegion];
    [userDefaults setObject:[NSNumber numberWithInt:self.district_id] forKey:kUserDefaultsKey_LastSelectedDistrict];
    [userDefaults synchronize];
}

- (void)loadLastChoice {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *regionId = [userDefaults objectForKey:kUserDefaultsKey_LastSelectedRegion];
    self.region_id = regionId != nil ? [regionId integerValue] : kRegions_UndefinedId;
    
    NSNumber *districtId = [userDefaults objectForKey:kUserDefaultsKey_LastSelectedDistrict];
    self.district_id = districtId != nil ? [districtId integerValue] : kDistrict_UndefinedId;
}

- (void)selectStationByAddress:(NSString *)address {
    THROW_IF_ARGUMENT_NIL(address);
    
    [self updateStations];

    NSPredicate *addressPredicate =
            [NSPredicate predicateWithFormat:@"(address like[cd] %@) OR (shortaddress like[cd] %@)", address, address];
    NSArray *stationsWithAddress = [self.stations filteredArrayUsingPredicate:addressPredicate];
    if (stationsWithAddress.count == 0) {
        return;
    }
    
    NSIndexPath *stationInfoIndexPath =
            [self indexPathForStationInfo:stationsWithAddress[0] forTableView:self.stationsTable];
    if (stationInfoIndexPath != nil) {
        self.selectedStationInfo = stationsWithAddress[0];
        [self.stationsTable selectRowAtIndexPath:stationInfoIndexPath animated:NO
                scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)updateStations {
    if (self.isSyncInProgress) {
        [self performSelector:@selector(updateStations) withObject:nil afterDelay:0.25f];
        return;
    }
    
    BOOL isSomeProgressHudVisible = [MBProgressHUD HUDForView:self.view] != nil;
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:!isSomeProgressHudVisible];
    
    int totalDistricts = 0;
    for (NSMutableDictionary *oneRegion in [[self.regionsDictionary objectEnumerator] allObjects]) {
        totalDistricts += ([[[oneRegion objectEnumerator] allObjects] count] - 1);
    }
    NSLog(@"UPDATING VIEW. TOTAL RECORDS: %d, REGIONS: %d DISTRICTS: %d",
            [self.stations count], [[[self.regionsDictionary objectEnumerator] allObjects] count], totalDistricts);
    
    //@"До 1 км";
    //@"До 3 км";
    //@"До 5 км";
    //@"До 10 км";
    //@"До 15 км";
    //@"Более 15 км";
    NSMutableArray *lessThan1 = [self.stationsByDistance objectForKey:kStationsFilteringByDistanceKey_LessThan1];
    NSMutableArray *lessThan3 = [self.stationsByDistance objectForKey:kStationsFilteringByDistanceKey_LessThan3];
    NSMutableArray *lessThan5 = [self.stationsByDistance objectForKey:kStationsFilteringByDistanceKey_LessThan5];
    NSMutableArray *lessThan10 = [self.stationsByDistance objectForKey:kStationsFilteringByDistanceKey_LessThan10];
    NSMutableArray *lessThan15 = [self.stationsByDistance objectForKey:kStationsFilteringByDistanceKey_LessThan15];
    NSMutableArray *moreThan15 = [self.stationsByDistance objectForKey:kStationsFilteringByDistanceKey_MoreThan15];
    
    [lessThan1 removeAllObjects];
    [lessThan3 removeAllObjects];
    [lessThan5 removeAllObjects];
    [lessThan10 removeAllObjects];
    [lessThan15 removeAllObjects];
    [moreThan15 removeAllObjects];
    
    for (HSStationInfo *stationInfo in self.stations) {
        if (self.region_id >= 0) {
            if ([stationInfo.region_id integerValue] != self.region_id) continue;
        }
        
        if (self.district_id >= 0) {
            if ([stationInfo.district_id integerValue] != self.district_id) continue;
        }
        
        if (stationInfo.distance == nil) {
            [moreThan15 addObject:stationInfo];
            continue;
        }
        
        double distance = [stationInfo.distance doubleValue];
        if (distance < 1000) {
            [lessThan1 addObject:stationInfo];
        } else if (distance < 3000) {
            [lessThan3 addObject:stationInfo];
        } else if (distance < 5000) {
            [lessThan5 addObject:stationInfo];
        } else if (distance < 10000) {
            [lessThan10 addObject:stationInfo];
        } else if (distance < 15000) {
            [lessThan15 addObject:stationInfo];
        } else{
            [moreThan15 addObject:stationInfo];
        }
    }
    
    [lessThan1 sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        HSStationInfo *first = (HSStationInfo *)obj1;
        HSStationInfo *second = (HSStationInfo *)obj2;
        double firstDistance = [first.distance doubleValue];
        double secondDistance = [second.distance doubleValue];
        if (firstDistance > secondDistance) return NSOrderedAscending;
        if (firstDistance < secondDistance) return NSOrderedDescending;
        return NSOrderedSame;
    }];
    
    [self updateRegionLabel];
    
    [self reloadStationsTableViewWithSavedSelection];
    
    BOOL isAnotherProgressHudsVisible = [[MBProgressHUD allHUDsForView:self.view] count] > 1;
    [progressHud hide:!isAnotherProgressHudsVisible];
}

- (IBAction)onPressChangeCity:(id)sender {
    HSStationsSelectCityViewController *selectCityViewController = [[HSStationsSelectCityViewController alloc] initWithNibName:@"HSStationsSelectCityViewController" bundle:nil];
    selectCityViewController.delegate = self;
    selectCityViewController.regionId = self.region_id;
    selectCityViewController.districtId = self.district_id;
    [self.navigationController presentModalViewController:selectCityViewController animated:YES];
}

- (void)updateRegionLabel {
    if (self.region_id > 0) {
        NSDictionary *region = [self.regionsDictionary objectForKey:[NSNumber numberWithInt:self.region_id]];;
        if (region) {
            self.curCityLabel.text = [region objectForKey:@"region_name"];
        } else {
            self.curCityLabel.text = kLabelTitle_UnknownRegion;
        }
        return;
    }
    if (self.district_id > 0) {
        for (id regionId in [[self.regionsDictionary keyEnumerator] allObjects]) {
            NSDictionary *region = [self.regionsDictionary objectForKey:regionId];
            
            for (id oneDistrictId in [[region keyEnumerator] allObjects]) {
                if ([oneDistrictId isKindOfClass:[NSString class]] && [oneDistrictId isEqualToString:@"region_name"]) continue;
                
                if ([oneDistrictId isKindOfClass:[NSNumber class]] && [oneDistrictId integerValue] == self.district_id) {
                    self.curCityLabel.text = [region objectForKey:oneDistrictId];
                    return;
                }
            }
        }
        return;
    }
    
    self.curCityLabel.text = kLabelTitle_UnknownRegion;
    return;
}

- (void)onShowMap:(id)sender {
    if (self.mapController == nil) {
        self.mapController = [[HSStationsMapViewController alloc] initWithStations:self.stations];
        [self.mapController reloadMapPoints];
    }
    self.mapController.center = self.curLocation;
    self.mapController.span = MKCoordinateSpanMake(0.2, 0.2);
    [self.mapController updateMapPosition];
    [self.navigationController pushViewController:self.mapController animated:YES];
}

#pragma mark - Synchronization with Parse
- (void)loadStations {
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([self needStationFullSync]) {
        [self forceStationFullSync];
    }

    self.stations = [self retriveStations];
    self.regionsDictionary = [self retriveRegions];
    
    if (self.stations == nil || self.regionsDictionary == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kStationsDatabase_SyncLastDate];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self syncLocalDatabaseCompletion:^{
        [progressHud hide:YES];
    }];
}

- (void)syncLocalDatabaseCompletion:(void(^)(void))completion {
    const NSUInteger kStationsRequestLimit = 1000;
    
    PFQuery *stationsQuery = [PFQuery queryWithClassName:@"YAStations"];
    stationsQuery.limit = kStationsRequestLimit;
    
    NSDate *latestChangeDateLocal = [[NSUserDefaults standardUserDefaults] objectForKey:kStationsDatabase_SyncLastDate];
    if (latestChangeDateLocal != nil) {
        [stationsQuery whereKey:@"updatedAt" greaterThan:latestChangeDateLocal];
    }
        
    [stationsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Cannot connected to Parse");
            if (completion) {
                completion();
            }
        } else if (objects.count > 0) {
            NSLog(@"Stations: need to update, updating...");
            [self updateLocalDatabaseWithStations:objects completion:^{
                [self reloadMapViewController];
                [self updateUserLocationIfNeeded];
                if (completion) {
                    completion();
                }
            }];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kStationsDatabase_SyncLastDate];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (completion) {
                completion();
            }
        }
    }];
}

- (void)updateLocalDatabaseWithStations:(NSArray *)stations completion:(void(^)(void))completion{
    NSLog(@"Local database will be updated with %d entities.", [stations count]);
    
    self.isSyncInProgress = YES;

    [self updateStationsWithStations:stations];
    [self updateRegionsWithStations:self.stations];
    [self saveDatabase];

    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kStationsDatabase_SyncLastDate];
    if ([self needStationFullSync]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kStationsDatabase_FullSyncLastDate];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.isSyncInProgress = NO;
    
    if (completion) {
        completion();
    }
}

- (NSInteger *)indexOfStationById:(PFObject *)station inStationsInfo:(NSArray *)stationsInfo {
    THROW_IF_ARGUMENT_NIL(station);
    THROW_IF_ARGUMENT_NIL(stationsInfo);
    for (HSStationInfo *stationInfo in stationsInfo) {
        if ([station.objectId isEqualToString:stationInfo.objectId]) {
            return [stationsInfo indexOfObject:stationInfo];
        }
    }
    return NSNotFound;
}

- (void)updateStationsWithStations:(NSArray *)stations {
    THROW_IF_ARGUMENT_NIL(stations);
    NSMutableArray *updatedStations = [[NSMutableArray alloc] initWithArray:self.stations];
    for (PFObject *station in stations) {
        NSUInteger updateIndex = [self indexOfStationById:station inStationsInfo:updatedStations];
        if (updateIndex == NSNotFound) {
            [updatedStations addObject:[[HSStationInfo alloc] initWithRemoteStation:station]];
        } else {
            HSStationInfo *updatedStationInfo = updatedStations[updateIndex];
            [updatedStationInfo updateWithRemoteStation:station];
        }
    }
    
    self.stations = updatedStations;
}

- (void)updateRegionsWithStations:(NSArray *)stations {
    NSMutableDictionary *newRegionsDictionary = [[NSMutableDictionary alloc] init];
    for (HSStationInfo *stationInfo in stations) {
        if (stationInfo.region_id != nil && stationInfo.region_name != nil) {
            NSMutableDictionary *region = [newRegionsDictionary objectForKey:stationInfo.region_id];
            if (region == nil) {
                region = [[NSMutableDictionary alloc] init];
                [region setObject:stationInfo.region_name forKey:@"region_name"];
                [newRegionsDictionary setObject:region forKey:stationInfo.region_id];
            }
            if (stationInfo.district_id != nil && stationInfo.district_name != nil) {
                [region setObject:stationInfo.district_name forKey:stationInfo.district_id];
            }
        }
    }
    
    self.regionsDictionary = newRegionsDictionary;
}

- (void)reloadMapViewController {
    if (self.mapController) {
        self.mapController.stations = self.stations;
        [self.mapController reloadMapPoints];
    }
}

- (void)updateUserLocationIfNeeded {
    if ((self.region_id == kRegions_UndefinedId && self.district_id == kDistrict_UndefinedId) ||
            [self.curCityLabel.text isEqualToString:kLabelTitle_UnknownRegion]) {
        [self requestUserLocation];
    }
}

#pragma mark - Current location determine method

- (void)requestUserLocation {
    if ([CLLocationManager locationServicesEnabled] == YES) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.distanceFilter = 100;
        [self.locationManager startUpdatingLocation];
    } else {
        self.locationManager = nil;
        [self updateStations];
    }
}

- (CLLocationDistance)distanceBetweenPoint:(CLLocationCoordinate2D)from toPoint:(CLLocationCoordinate2D)to{
    CLLocation *locationFrom = [[CLLocation alloc] initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *locationTo = [[CLLocation alloc] initWithLatitude:to.latitude longitude:to.longitude];
    return [locationTo distanceFromLocation:locationFrom];
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error {
    NSLog(@"Cannot determine current location! Error: %@", [error localizedDescription]);
    self.curLocation = CLLocationCoordinate2DMake(0, 0);
    [self selectCityByLocation:[[CLLocation alloc] initWithLatitude:0 longitude:0]];
}

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations {
    CLLocation *location = [locations lastObject];
    self.curLocation = location.coordinate;
    if (self.mapController) self.mapController.center = self.curLocation;
    
    
    NSLog(@"Location determined (IOS 6): %.7f, %.7f", self.curLocation.latitude, self.curLocation.longitude);
    [self selectCityByLocation:location];
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation
        fromLocation:(CLLocation*)oldLocation {
    self.curLocation  = newLocation.coordinate;
    if (self.mapController) self.mapController.center = self.curLocation;
    
    NSLog(@"Location determined (IOS 5): %.7f, %.7f", self.curLocation.latitude, self.curLocation.longitude);
    [self selectCityByLocation:newLocation];
    [manager stopUpdatingLocation];
}

- (void)selectCityByLocation:(CLLocation *)location{
    [self updateStationsByDistanceFromLocation:location.coordinate];
    
    if (self.isCitySelectedByGeolocationOnceAtThisSession) {
        [self updateStations];
        return;
    }
    
    CLLocationCoordinate2D coord = [location coordinate];
    NSString *url = [NSString stringWithFormat:
            @"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@&language=ru&sensor=true",
            [NSString stringWithFormat:@"%f,%f", coord.latitude, coord.longitude]];
    HSSingleReqest *request = [[HSSingleReqest alloc] initWithURL:url andDelegate:self
            andCallbackFunction:@selector(regionWasDetermined:data:)
            andErrorCallBackFunction:@selector(regionCannotBeDetermined:data:)];
    request.method = HSHTTPMethodGET;
    request.url = url;
    [request sendRequest];
}

- (void)updateStationsByDistanceFromLocation:(CLLocationCoordinate2D)curPoint{
    for (HSStationInfo *stationInfo in self.stations) {
        CLLocationCoordinate2D stationPoint =
                CLLocationCoordinate2DMake([stationInfo.lat doubleValue], [stationInfo.lon doubleValue]);
        double distance = [self distanceBetweenPoint:curPoint toPoint:stationPoint];
        stationInfo.distance = [NSNumber numberWithDouble:distance];
    }
}

- (void)regionWasDetermined:(HSSingleReqest*)request data:(NSData*)data {
    BOOL isFoundedRegion = NO;
    BOOL noLocality = NO, noArea1 = NO, noArea2 = NO;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString* name;
    if ([json isKindOfClass:[NSDictionary class]]) {
        NSString* status = [json objectForKey:@"status"];
        if ([status isEqualToString:@"OK"]) {
            NSArray* results = [json objectForKey:@"results"];
            if ([results count] > 0) {
                NSDictionary* first = [results objectAtIndex:0];
                NSArray* addressComponents = [first objectForKey:@"address_components"];
                for (NSDictionary * item in addressComponents) {
                    
                    NSArray *types = [item objectForKey:@"types"];
                    NSString *type = types.count > 0 ? [types objectAtIndex:0] : nil;
                    if (!noLocality && !noArea1 && !noArea2 && [type isEqualToString:@"locality"] == YES) {
                        name = [item objectForKey:@"long_name"];
                        if ([name isKindOfClass:[NSString class]] == YES) {
                            if ([self tryToSetRegionWithStr:name]) {
                                isFoundedRegion = YES;
                                break;
                            }
                            noLocality = YES;
                        }
                    }
                    if (noLocality && !noArea1 && !noArea2 && [type isEqualToString:@"administrative_area_level_1"] == YES) {
                        name = [item objectForKey:@"long_name"];
                        if ([name isKindOfClass:[NSString class]] == YES) {
                            if ([self tryToSetRegionWithStr:name]) {
                                isFoundedRegion = YES;
                                break;
                            }
                            noArea1 = YES;
                        }
                    }
                    if (noLocality && noArea1 && !noArea2 && [type isEqualToString:@"administrative_area_level_1"] == YES) {
                        name = [item objectForKey:@"long_name"];
                        if ([name isKindOfClass:[NSString class]] == YES) {
                            if ([self tryToSetRegionWithStr:name]) {
                                isFoundedRegion = YES;
                                break;
                            }
                            noArea2 = YES;
                        }
                    }
                }
            }
        }
    }
    
    
    
    if (!isFoundedRegion) {
        NSString* resultStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Cannot determine current region! Reply from geocoder: %@", resultStr);
        [self loadLastChoice];
    }else{
        self.isCitySelectedByGeolocationOnceAtThisSession = YES;
    }
    
    [self updateStations];
}


- (void)regionCannotBeDetermined:(HSSingleReqest*)request data:(NSError *)error{
    NSLog(@"Cannot determine region name throught google! Message: %@", [error localizedDescription]);

    [self loadLastChoice];
    [self updateStations];
}

- (void)requestCurrentRegionAreaWithRegionName:(NSString *)regionName{
    if (regionName) {
        NSString* url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&language=ru&sensor=true", regionName];
        HSSingleReqest *request = [[HSSingleReqest alloc] initWithURL:url andDelegate:self andCallbackFunction:@selector(regionAreaWasDetermined:data:) andErrorCallBackFunction:@selector(regionAreaCannotBeDetermined:data:)];
        request.method = HSHTTPMethodGET;
        request.url = url;
        [request sendRequest];
    }
}

- (void)regionAreaWasDetermined:(HSSingleReqest*)request data:(NSData*)data{
    self.mapController.center = CLLocationCoordinate2DMake(0, 0);
    self.mapController.span = MKCoordinateSpanMake(0, 0);
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if ([json isKindOfClass:[NSDictionary class]]) {
        NSString *status = [json objectForKey:@"status"];
        if ([status isEqualToString:@"OK"] == YES) {
            NSArray *results = [json objectForKey:@"results"];
            if ([results count] > 0) {
                NSDictionary *first = [results objectAtIndex:0];
                NSDictionary *geometry = [first objectForKey:@"geometry"];
                if (geometry) {
                    CLLocationCoordinate2D curCardCenter;
                    curCardCenter.latitude = [[[geometry objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
                    curCardCenter.longitude = [[[geometry objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
                    self.mapController.center = curCardCenter;
                    NSDictionary *southWest = [[geometry objectForKey:@"viewport"] objectForKey:@"southwest"];
                    NSDictionary *northEast = [[geometry objectForKey:@"viewport"] objectForKey:@"northeast"];
                    if (southWest && northEast) {
                        MKCoordinateSpan curRegionSpan;
                        curRegionSpan.latitudeDelta = fabs([[southWest objectForKey:@"lat"] doubleValue] - [[northEast objectForKey:@"lat"] doubleValue])/2.0;
                        curRegionSpan.longitudeDelta = fabs([[southWest objectForKey:@"lng"] doubleValue] - [[northEast objectForKey:@"lng"] doubleValue])/2.0;
                        self.mapController.span = curRegionSpan;
                    }
                }
            }
        }
    }
}

- (void)regionAreaCannotBeDetermined:(HSSingleReqest*)request data:(NSError *)error{
    NSLog(@"Cannot determine region area throught google! Message: %@", [error localizedDescription]);
}

- (BOOL)isRegion:(NSString *)region1 equalToRegion:(NSString *)region2{
    NSRange containsRange = [region1 rangeOfString:region2];
    if (containsRange.location!=NSNotFound) {
        return YES;
    }else{
        containsRange = [region2 rangeOfString:region1];
        if (containsRange.location!=NSNotFound) {
            return YES;
        }
    }

    return NO;
}

- (BOOL)tryToSetRegionWithStr:(NSString *)regionStr{
    if (regionStr && self.regionsDictionary && [self.regionsDictionary count]>0) {
        NSLog(@"Region: %@", regionStr);
        
        BOOL isFounded = NO;
        for (id oneRegionId in [[self.regionsDictionary keyEnumerator] allObjects]) {
            NSDictionary *curRegion = [self.regionsDictionary objectForKey:oneRegionId];
            NSString *curRegionName = [curRegion objectForKey:@"region_name"];
            
            if ([self isRegion:curRegionName equalToRegion:regionStr]) {
                isFounded = YES;
                self.region_id = [oneRegionId integerValue];
                self.district_id = kDistrict_UndefinedId;
                break;
            }
            
            for (id oneDistrictId in [[curRegion keyEnumerator] allObjects]) {
                if ([oneDistrictId isKindOfClass:[NSString class]] && [oneDistrictId isEqualToString:@"region_name"]) continue;
                
                NSString *curDistrictName = [curRegion objectForKey:oneDistrictId];
                if ([self isRegion:curDistrictName equalToRegion:regionStr]) {
                    isFounded = YES;
                    self.region_id = kRegions_UndefinedId;
                    self.district_id = [oneDistrictId integerValue];
                    break;
                }
            }
        }
        
        return isFounded;
    }
    
    return NO;
}

- (void)updateListWithRegion:(NSString *)regionStr{
    [self tryToSetRegionWithStr:regionStr];
    
    [self updateStations];
}

#pragma mark - Table view delegate routines

- (BOOL)isSearchModeForTable:(UITableView *)tableView{
    return tableView==self.searchDisplayController.searchResultsTableView ? YES : NO;
}

- (NSIndexPath *)indexPathForStationInfo:(HSStationInfo *)stationInfo forTableView:(UITableView *)tableView {
    NSMutableDictionary *currentStationsDictionary =
            [self isSearchModeForTable:tableView] ? self.filteredDictionary : self.stationsByDistance;
 
    NSArray *lessThan1 = [currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_LessThan1];
    if ([lessThan1 containsObject:stationInfo]) {
        return [NSIndexPath indexPathForRow:[lessThan1 indexOfObject:stationInfo] inSection:0];
    }
    
    NSArray *lessThan3 = [currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_LessThan3];
    if ([lessThan3 containsObject:stationInfo]) {
        return [NSIndexPath indexPathForRow:[lessThan3 indexOfObject:stationInfo] inSection:1];
    }

    NSArray *lessThan5 = [currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_LessThan5];
    if ([lessThan5 containsObject:stationInfo]) {
        return [NSIndexPath indexPathForRow:[lessThan5 indexOfObject:stationInfo] inSection:2];
    }

    NSArray *lessThan10 = [currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_LessThan10];
    if ([lessThan10 containsObject:stationInfo]) {
        return [NSIndexPath indexPathForRow:[lessThan10 indexOfObject:stationInfo] inSection:3];
    }

    NSArray *lessThan15 = [currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_LessThan15];
    if ([lessThan15 containsObject:stationInfo]) {
        return [NSIndexPath indexPathForRow:[lessThan15 indexOfObject:stationInfo] inSection:4];
    }

    NSArray *moreThan15 = [currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_MoreThan15];
    if ([moreThan15 containsObject:stationInfo]) {
        return [NSIndexPath indexPathForRow:[moreThan15 indexOfObject:stationInfo] inSection:5];
    }
   
    return nil;
}

- (HSStationInfo *)stationInfoForTable:(UITableView *)tableView forStationKeyPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *currentStationsDictionary =
            [self isSearchModeForTable:tableView] ? self.filteredDictionary : self.stationsByDistance;
    NSArray *curSectionArray = nil;
    
    switch ([indexPath section]) {
        case 0:
            curSectionArray = [currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_LessThan1];
            break;
        case 1:
            curSectionArray = [currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_LessThan3];
            break;
        case 2:
            curSectionArray = [currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_LessThan5];
            break;
        case 3:
            curSectionArray = [currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_LessThan10];
            break;
        case 4:
            curSectionArray = [currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_LessThan15];
            break;
        case 5:
            curSectionArray = [currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_MoreThan15];
            break;
    }
    if (curSectionArray==nil || [curSectionArray count]<=[indexPath row]) {
        return nil;
    }
    
    if (indexPath.row < curSectionArray.count) {
        return [curSectionArray objectAtIndex:indexPath.row];
    } else {
        NSLog(@"Requested missing station info for table row: %ld", indexPath.row);
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSMutableDictionary *currentStationsDictionary = [self isSearchModeForTable:tableView] ?
            self.filteredDictionary : self.stationsByDistance;

    return [[[currentStationsDictionary keyEnumerator] allObjects] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableDictionary *currentStationsDictionary = [self isSearchModeForTable:tableView] ?
            self.filteredDictionary : self.stationsByDistance;

    switch (section) {
        case 0:
            return [[currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_LessThan1] count];
            break;
        case 1:
            return [[currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_LessThan3] count];
            break;
        case 2:
            return [[currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_LessThan5] count];
            break;
        case 3:
            return [[currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_LessThan10] count];
            break;
        case 4:
            return [[currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_LessThan15] count];
            break;
        case 5:
            return [[currentStationsDictionary objectForKey:kStationsFilteringByDistanceKey_MoreThan15] count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSInteger elementsConnt = [self tableView:tableView numberOfRowsInSection:section];
    return elementsConnt > 0 ? 30.0f : 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HSStationInfo *stationInfo = [self stationInfoForTable:tableView forStationKeyPath:indexPath];
    if (stationInfo == nil) {
        return 0.0f;
    }
    
    NSString *address = stationInfo.shortaddress != nil ? stationInfo.shortaddress : stationInfo.address;
    NSString *label = [NSString stringWithFormat:@"%@\n%@",
            (stationInfo.name != nil ? stationInfo.name : @""), (address != nil ? address : @"")];
    CGSize labelSize = [label sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]
            constrainedToSize:CGSizeMake(300, 100500) lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize.height + 10.0f;
 }


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    float headerHeight = [self tableView:tableView heightForHeaderInSection:section];
    if (headerHeight<=0) return nil;
    
    NSString *headerStr = nil;
    switch (section) {
        case 0:
            headerStr = @"До 1 км";
            break;
        case 1:
            headerStr = @"До 3 км";
            break;
        case 2:
            headerStr = @"До 5 км";
            break;
        case 3:
            headerStr = @"До 10 км";
            break;
        case 4:
            headerStr = @"До 15 км";
            break;
        case 5:
            headerStr = @"Более 15 км";
            break;
            
        default:
            headerStr = @"";
            break;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, headerHeight)];
    headerView.clipsToBounds = NO;
    UIImageView *headerBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DonorStations_tableHeaderBackground"]];
    [headerView addSubview:headerBackground];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
    headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    headerLabel.textColor = DONOR_STATIONS_SEPARATOR_TEXT_COLOR;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.text = headerStr;
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * const cellID = @"StationsCellID";
    
    float cellHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, cellHeight-10)];
        regionLabel.tag = kCellRegionLabelTag;
        regionLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        regionLabel.textColor = DONOR_TEXT_COLOR;
        regionLabel.highlightedTextColor = DONOR_RED_COLOR;
        regionLabel.backgroundColor = [UIColor clearColor];
        regionLabel.textAlignment = NSTextAlignmentLeft;
        regionLabel.numberOfLines = 100500;
        [cell addSubview:regionLabel];
        
        CGRect backgroundSelectedFrame = CGRectMake(10, 10, 10, cellHeight);
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:backgroundSelectedFrame];
        cell.selectedBackgroundView.clipsToBounds = YES;
        cell.selectedBackgroundView.alpha = 1.0;
        cell.selectedBackgroundView.backgroundColor = RGBA_COLOR(0, 0, 0.0, 0.1);
        
        UIImageView *separatorView =
                [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DonorStations_tableCellSeparator"]];
        separatorView.tag = kCellSeparatorViewTag;
        [cell addSubview:separatorView];
    }
        
    HSStationInfo *stationInfo = [self stationInfoForTable:tableView forStationKeyPath:indexPath];
    BOOL cellIsSelected = stationInfo == self.selectedStationInfo;
    cell.selected = cellIsSelected;
    cell.highlighted = cellIsSelected;
    
    NSString *name = stationInfo.name;
    NSString *address = stationInfo.shortaddress != nil ? stationInfo.shortaddress : stationInfo.address;
    
    UILabel *regionLabel = (UILabel *)[cell viewWithTag:kCellRegionLabelTag];
    regionLabel.text = [NSString stringWithFormat:@"%@\n%@",
            (name != nil ? name : @""), (address != nil ? address : @"")];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:regionLabel.text];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:DONOR_TEXT_COLOR
                range:NSMakeRange(0, [name length])];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:DONOR_GREEN_COLOR
                range:NSMakeRange([name length] + 1, [address length])];
        regionLabel.attributedText = attributedStr;
    }
    CGRect regionLabelFrame = regionLabel.frame;
    regionLabelFrame.size.height = cellHeight - 10;
    regionLabel.frame = regionLabelFrame;
    
    UIView *separatorView = [cell viewWithTag:kCellSeparatorViewTag];
    CGRect separatorFrame = separatorView.frame;
    separatorFrame.origin = CGPointMake(12, cellHeight - 3);
    separatorView.frame = separatorFrame;
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedStationInfo = [self stationInfoForTable:tableView forStationKeyPath:indexPath];
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HSStationInfo *stationInfo = [self stationInfoForTable:tableView forStationKeyPath:indexPath];
    if (stationInfo) {
        HSStationCardViewController *cardViewController = [[HSStationCardViewController alloc]
                initWithStationInfo:stationInfo];
        [self.navigationController pushViewController:cardViewController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
        forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.backgroundColor = [UIColor clearColor];
}


#pragma mark - Supporting for sliding search-bar

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.blockDidScrollDelegateCall || self.searchDisplayController.isActive) return;
    
    float offset = scrollView.contentOffset.y;
    UIView *searchBar = (UIView *)self.searchDisplayController.searchBar;
    if (offset<0) {
        self.isSearchBarShown = ((-offset)>searchBar.frame.size.height) ? YES : NO;
    }else{
        self.isSearchBarShown = NO;
    }
    
    CGRect searchBarRect = searchBar.frame;
    float barOffset = self.isSearchBarShown ? searchBar.frame.size.height : (-offset);
    searchBarRect.origin.y = scrollView.frame.origin.y - searchBar.frame.size.height + barOffset;
    searchBar.frame = searchBarRect;
    
    scrollView.contentInset = UIEdgeInsetsMake(barOffset>0 ? barOffset : 0, 0, 0, 0);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.blockDidScrollDelegateCall = NO;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (targetContentOffset->y < 0) {
        //NSLog(@"END DRAGGING: offset: %.0f->%.0f; %@ bar", scrollView.contentOffset.y, targetContentOffset->y, self.isSearchBarShown ? @"SHOW" : @"HIDE");
        UIView *searchBar = (UIView *)self.searchDisplayController.searchBar;
        if (self.isSearchBarShown) {
            [UIView animateWithDuration:0.5 animations:^{
                scrollView.contentInset = UIEdgeInsetsMake(searchBar.bounds.size.height, 0, 0, 0);
                CGRect searchBarRect = searchBar.frame;
                searchBarRect.origin.y = scrollView.frame.origin.y;
                searchBar.frame = searchBarRect;
            }];
        }else{
            self.blockDidScrollDelegateCall = YES;
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                CGRect searchBarRect = searchBar.frame;
                searchBarRect.origin.y = scrollView.frame.origin.y - searchBarRect.size.height;
                searchBar.frame = searchBarRect;
            } completion:^(BOOL finished) {
                self.blockDidScrollDelegateCall = NO;
            }];
        }
    }
}



#pragma mark - UISearchDisplayController Delegate Methods

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
    for (UIView *oneView in self.searchDisplayController.searchBar.subviews) {
        if ([oneView isKindOfClass:[UIButton class]]) {
            [(UIButton *)oneView setTitle:@"Отменить" forState:UIControlStateNormal];
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
        shouldReloadTableForSearchString:(NSString *)searchString {

	NSString *str;
    NSRange substringRange;
    BOOL isResults = NO;
    
	for (NSString *oneKey in [[self.stationsByDistance keyEnumerator] allObjects]) {
        NSMutableArray *curDistArray = [self.stationsByDistance objectForKey:oneKey];
        NSMutableArray *curDistArrayFiltered = [self.filteredDictionary objectForKey:oneKey];
        [curDistArrayFiltered removeAllObjects];
        
        for (HSStationInfo *stationInfo in curDistArray) {
            str = stationInfo.name;
            substringRange = [str rangeOfString:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [str length])];
            if (substringRange.location != NSNotFound) {
                [curDistArrayFiltered addObject:stationInfo];
                isResults = YES;
                continue;
            } else {
                str = stationInfo.address;
                substringRange = [str rangeOfString:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [str length])];
                if (substringRange.location != NSNotFound) {
                    [curDistArrayFiltered addObject:stationInfo];
                    isResults = YES;
                    continue;
                }
            }
        }
	}
    
    if (!isResults) {
        double delayInSeconds = 0.001;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            for (UIView *oneView in self.searchDisplayController.searchResultsTableView.subviews) {
                if ([oneView isKindOfClass:[UILabel class]]) {
                    [(UILabel *)oneView setText:@"Не найдено"];
                }
            }
        });
    }
    
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller
        didShowSearchResultsTableView:(UITableView *)tableView {
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.stationsTable.hidden = YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller
        willHideSearchResultsTableView:(UITableView *)tableView {
    self.stationsTable.hidden = NO;
}

#pragma mark - Private
#pragma mark - Table view utlity
- (void)reloadStationsTableViewWithSavedSelection {
    [self.stationsTable reloadData];

    NSIndexPath *selectedIndexPath = nil;
    if (self.selectedStationInfo != nil) {
        selectedIndexPath = [self indexPathForStationInfo:self.selectedStationInfo forTableView:self.stationsTable];
    }

    if (selectedIndexPath != nil) {
        [self.stationsTable selectRowAtIndexPath:selectedIndexPath animated:NO
                scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - Local database management
- (NSString *)databaseDirectoryPath {
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Caches"];
}

- (NSString *)stationsDatabaseFilePath {
    return [NSString stringWithFormat:@"%@/%@", [self databaseDirectoryPath], @"stations.dat"];
}

- (NSString *)regionsDatabaseFilePath {
    return [NSString stringWithFormat:@"%@/%@", [self databaseDirectoryPath], @"regions.dat"];
}

- (void)saveDatabase{
    [self saveStations:self.stations];
    [self saveRegions:self.regionsDictionary];
    [self saveDatabaseCurrentVersion];
    [self updateStations];
}

- (void)saveStations:(NSArray *)stations {
    NSFileManager *fileMananager = [NSFileManager defaultManager];
    
    if ([fileMananager fileExistsAtPath:[self stationsDatabaseFilePath]]) {
        [fileMananager removeItemAtPath:[self stationsDatabaseFilePath] error:nil];
    }
    
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:stations];
    [fileMananager createFileAtPath:[self stationsDatabaseFilePath] contents:arrayData attributes:nil];
}

- (void)saveRegions:(NSDictionary *)regions {
    NSFileManager *fileMananager = [NSFileManager defaultManager];
    
    if ([fileMananager fileExistsAtPath:[self regionsDatabaseFilePath]]) {
        [fileMananager removeItemAtPath:[self regionsDatabaseFilePath] error:nil];
    }
    
    NSData *dictionaryData = [NSKeyedArchiver archivedDataWithRootObject:self.regionsDictionary];
    [fileMananager createFileAtPath:[self regionsDatabaseFilePath] contents:dictionaryData attributes:nil];
}

- (NSArray *)retriveStations {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *stationsDatabaseFilePath = [self stationsDatabaseFilePath];
    
    if (![self isSavedDatabaseSupported]) {
        if ([fileManager fileExistsAtPath:stationsDatabaseFilePath]) {
            [fileManager removeItemAtPath:stationsDatabaseFilePath error:nil];
        }
        return nil;
    }
    
    if (![fileManager fileExistsAtPath:stationsDatabaseFilePath]) {
        return nil;
    }
    
    NSData *stationsData = [[NSData alloc] initWithContentsOfFile:stationsDatabaseFilePath];
    return [NSKeyedUnarchiver unarchiveObjectWithData:stationsData];
}

- (NSDictionary *)retriveRegions {
    if (![self isSavedDatabaseSupported]) {
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *regionsDatabaseFilePath = [self regionsDatabaseFilePath];
    if (![fileManager fileExistsAtPath:regionsDatabaseFilePath]) {
        return nil;
    }
    
    NSData *regionsData = [[NSData alloc] initWithContentsOfFile:regionsDatabaseFilePath];
    return [NSKeyedUnarchiver unarchiveObjectWithData:regionsData];
}

- (BOOL)saveDatabaseCurrentVersion {
    [[NSUserDefaults standardUserDefaults] setObject:[self databaseCurrentSavedVersion]
            forKey:kStationsDatabase_CurrentVersionKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSNumber *)retriveDatabaseCurrentVersion {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kStationsDatabase_CurrentVersionKey];
}

- (NSNumber *)databaseSupportedMinorVersion {
    return @1.0;
}

- (NSNumber *)databaseCurrentSavedVersion {
    return @1.0;
}

- (BOOL)isSavedDatabaseSupported {
    NSNumber *currentDatabaseVersion = [self retriveDatabaseCurrentVersion];
    if (currentDatabaseVersion == nil ||
            [currentDatabaseVersion compare:[self databaseSupportedMinorVersion]] == NSOrderedAscending) {
        return NO;
    }
    return YES;
}

- (BOOL)needStationFullSync {
    NSDate *fullSyncLastDate = [[NSUserDefaults standardUserDefaults] objectForKey:kStationsDatabase_FullSyncLastDate];
    if (fullSyncLastDate == nil) {
        return YES;
    }
    NSTimeInterval daysPast = labs([fullSyncLastDate timeIntervalSinceNow] / 60 / 60 / 24);
    return daysPast > kStationsDatabase_FullSyncPeriod;
}

- (void)forceStationFullSync {
    // Unversionized database will be removed during next launch.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kStationsDatabase_CurrentVersionKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kStationsDatabase_SyncLastDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
