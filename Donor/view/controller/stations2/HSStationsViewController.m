//
//  HSStationsViewController.m
//  Donor
//
//  Created by Eugine Korobovsky on 03.04.13.
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

#define USER_DEFAULTS_LAST_SYNC_DATE_ID @"latestStationsChangedDate"
#define USER_DEFAULTS_LAST_SELECTED_REGION_ID @"lastSelectedRegion"
#define USER_DEFAULTS_LAST_SELECTED_DISTRICT_ID @"lastSelectedDistrict"
//#define STATION_ROW_HEIGHT 48




@interface HSStationsViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) BOOL blockDidScrollDelegateCall;

@property (nonatomic, strong) HSStationsMapViewController *mapController;

@property (nonatomic, strong) NSMutableDictionary *filteredDictionary;

@end


@implementation HSStationsViewController

#pragma mark - View's lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isSyncInProgress = NO;
        NSFileManager *fileMan = [NSFileManager defaultManager];
        NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
        NSString *baseDir = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Caches"];
        NSString *stationsFilePath = [NSString stringWithFormat:@"%@/%@", baseDir, @"stations.dat"];
        if([fileMan fileExistsAtPath:stationsFilePath]){
            NSData *stationsData = [[NSData alloc] initWithContentsOfFile:stationsFilePath];
            _stationsArray = [NSKeyedUnarchiver unarchiveObjectWithData:stationsData];
            NSString *regionsFilePath = [NSString stringWithFormat:@"%@/%@", baseDir, @"regions.dat"];
            if([fileMan fileExistsAtPath:regionsFilePath]){
                NSData *regionsData = [[NSData alloc] initWithContentsOfFile:regionsFilePath];
                _regionsDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:regionsData];
            }else{
                _regionsDictionary = [[NSMutableDictionary alloc] init];
                [userDefs removeObjectForKey:USER_DEFAULTS_LAST_SYNC_DATE_ID];
                [userDefs synchronize];
            };
        }else{
            _stationsArray = [[NSMutableArray alloc] init];
            _regionsDictionary = [[NSMutableDictionary alloc] init];
            [userDefs removeObjectForKey:USER_DEFAULTS_LAST_SYNC_DATE_ID];
            [userDefs synchronize];
        };
        isCitySelectedByGeolocationOnceAtThisSession = NO;
        [self updateLocalDatabase];
        
        
        NSMutableArray *lessThan1 = [[NSMutableArray alloc] init];
        NSMutableArray *lessThan3 = [[NSMutableArray alloc] init];
        NSMutableArray *lessThan5 = [[NSMutableArray alloc] init];
        NSMutableArray *lessThan10 = [[NSMutableArray alloc] init];
        NSMutableArray *lessThan15 = [[NSMutableArray alloc] init];
        NSMutableArray *moreThan15 = [[NSMutableArray alloc] init];
        _stationsByDistance = [[NSMutableDictionary alloc] init];
        [_stationsByDistance setObject:lessThan1 forKey:@"lessThan1"];
        [_stationsByDistance setObject:lessThan3 forKey:@"lessThan3"];
        [_stationsByDistance setObject:lessThan5 forKey:@"lessThan5"];
        [_stationsByDistance setObject:lessThan10 forKey:@"lessThan10"];
        [_stationsByDistance setObject:lessThan15 forKey:@"lessThan15"];
        [_stationsByDistance setObject:moreThan15 forKey:@"moreThan15"];
        
        NSMutableArray *lessThan1filter = [[NSMutableArray alloc] init];
        NSMutableArray *lessThan3filter = [[NSMutableArray alloc] init];
        NSMutableArray *lessThan5filter = [[NSMutableArray alloc] init];
        NSMutableArray *lessThan10filter = [[NSMutableArray alloc] init];
        NSMutableArray *lessThan15filter = [[NSMutableArray alloc] init];
        NSMutableArray *moreThan15filter = [[NSMutableArray alloc] init];
        _filteredDictionary = [[NSMutableDictionary alloc] init];
        [_filteredDictionary setObject:lessThan1filter forKey:@"lessThan1"];
        [_filteredDictionary setObject:lessThan3filter forKey:@"lessThan3"];
        [_filteredDictionary setObject:lessThan5filter forKey:@"lessThan5"];
        [_filteredDictionary setObject:lessThan10filter forKey:@"lessThan10"];
        [_filteredDictionary setObject:lessThan15filter forKey:@"lessThan15"];
        [_filteredDictionary setObject:moreThan15filter forKey:@"moreThan15"];
        
        selectedCity = 0;
        curLocation = CLLocationCoordinate2DMake(0, 0);
        isSearchBarShowed = NO;

        _mapController = [[HSStationsMapViewController alloc] initWithNibName:@"HSStationsMapViewController" bundle:nil];
        _mapController.stationsArray = _stationsArray;
        [_mapController reloadMapPoints];
        
        _blockDidScrollDelegateCall = NO;
    };
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Cтанции";
    
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarBtn.frame = CGRectMake(0.0, 0.0, 33.0, 30.0);
    [rightBarBtn setImage:[UIImage imageNamed:@"DonorStations_navBarMapBtn_norm"] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@"DonorStations_navBarMapBtn_press"] forState:UIControlStateHighlighted];
    [rightBarBtn addTarget:self action:@selector(onShowMap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIImage *searchBarImage = [UIImage imageNamed:@"DonorStations_searchBarBackground"];
    [self.searchDisplayController.searchBar setBackgroundImage:searchBarImage];
    [self.searchDisplayController.searchBar setImage:[UIImage imageNamed:@"DonorStations_searchBarSearchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchDisplayController.searchBar setImage:[UIImage imageNamed:@"DonorStations_searchBarClearIcon"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    self.searchDisplayController.searchBar.tintColor = DONOR_RED_COLOR;
    
    UIImage *searchFieldImage = [[UIImage imageNamed:@"DonorStations_searchBarFieldBackground"] stretchableImageWithLeftCapWidth:20 topCapHeight:4];
    [self.searchDisplayController.searchBar setSearchFieldBackgroundImage:searchFieldImage forState:UIControlStateNormal];
    for(UIView *oneView in self.searchDisplayController.searchBar.subviews){
        if([oneView isKindOfClass:[UITextField class]]){
            ((UITextField *)oneView).textColor = DONOR_SEARCH_FIELD_TEXT_COLOR;
        };
    };
    
    
    
};

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self requestUserLocation];
};

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
};

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
};

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if(self.locationManager){
        [self.locationManager stopUpdatingLocation];
    };
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
};

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
};

#pragma mark - View Controller's routines

- (void)saveLastChoice{
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    [userDefs setObject:[NSNumber numberWithInt:_region_id] forKey:USER_DEFAULTS_LAST_SELECTED_REGION_ID];
    [userDefs setObject:[NSNumber numberWithInt:_district_id] forKey:USER_DEFAULTS_LAST_SELECTED_DISTRICT_ID];
    [userDefs synchronize];
};

- (void)loadLastChoice{
    NSNumber *userDefsObj = nil;
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    userDefsObj = [userDefs objectForKey:USER_DEFAULTS_LAST_SELECTED_REGION_ID];
    _region_id = userDefsObj ? [userDefsObj integerValue] : -1;
    userDefsObj = [userDefs objectForKey:USER_DEFAULTS_LAST_SELECTED_DISTRICT_ID];
    _district_id = userDefsObj ? [userDefsObj integerValue] : -1;
    
    //NSLog(@"Loading last choice: region = %d, district = %d", _region_id, _district_id);
}

- (void)updateStations{
    if(isSyncInProgress){
        [self performSelector:@selector(updateStations) withObject:nil afterDelay:0.25f];
        return;
    };
    
    int totalDistrics = 0;
    for(NSMutableDictionary *oneRegion in [[_regionsDictionary objectEnumerator] allObjects]){
        
        totalDistrics += ([[[oneRegion objectEnumerator] allObjects] count]-1);
    };
    NSLog(@"UPDATING VIEW. TOTAL RECORDS: %d, REGIONS: %d DISTRICTS: %d", [_stationsArray count], [[[_regionsDictionary objectEnumerator] allObjects] count], totalDistrics);
    
    //@"До 1 км";
    //@"До 3 км";
    //@"До 5 км";
    //@"До 10 км";
    //@"До 15 км";
    //@"Более 15 км";
    NSMutableArray *lessThan1 = [_stationsByDistance objectForKey:@"lessThan1"];
    NSMutableArray *lessThan3 = [_stationsByDistance objectForKey:@"lessThan3"];
    NSMutableArray *lessThan5 = [_stationsByDistance objectForKey:@"lessThan5"];
    NSMutableArray *lessThan10 = [_stationsByDistance objectForKey:@"lessThan10"];
    NSMutableArray *lessThan15 = [_stationsByDistance objectForKey:@"lessThan15"];
    NSMutableArray *moreThan15 = [_stationsByDistance objectForKey:@"moreThan15"];
    
    [lessThan1 removeAllObjects];
    [lessThan3 removeAllObjects];
    [lessThan5 removeAllObjects];
    [lessThan10 removeAllObjects];
    [lessThan15 removeAllObjects];
    [moreThan15 removeAllObjects];
    
    for(NSDictionary *oneStation in _stationsArray){
        if(_region_id>=0){
            if([[oneStation objectForKey:@"region_id"] integerValue] != _region_id) continue;
        };
        if(_district_id>=0){
            if([[oneStation objectForKey:@"district_id"] integerValue] != _district_id) continue;
        };
        
        if([oneStation objectForKey:@"_distance"]==nil){
            [moreThan15 addObject:oneStation];
            continue;
        };
        
        double curDist = [[oneStation objectForKey:@"_distance"] doubleValue];
        if(curDist<1000){
            [lessThan1 addObject:oneStation];
        }else if(curDist<3000){
            [lessThan3 addObject:oneStation];
        }else if(curDist<5000){
            [lessThan5 addObject:oneStation];
        }else if(curDist<10000){
            [lessThan10 addObject:oneStation];
        }else if(curDist<15000){
            [lessThan15 addObject:oneStation];
        }else{
            [moreThan15 addObject:oneStation];
        };
    };
    
    [lessThan1 sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
        double dist1 = [[obj1 objectForKey:@"_distance"] doubleValue];
        double dist2 = [[obj2 objectForKey:@"_distance"] doubleValue];
        if(dist1>dist2) return NSOrderedAscending;
        if(dist1<dist2) return NSOrderedDescending;
        return NSOrderedSame;
    }];
    
    [self updateRegionLabel];
    
    
    [_stationsTable reloadData];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
};

- (IBAction)onPressChangeCity:(id)sender{
    HSStationsSelectCityViewController *selCity = [[HSStationsSelectCityViewController alloc] initWithNibName:@"HSStationsSelectCityViewController" bundle:nil];
    selCity.delegate = self;
    selCity.regionId = _region_id;
    selCity.districtId = _district_id;
    [self.navigationController presentModalViewController:selCity animated:YES];
    
    //id myNav = self.navigationController;
    //NSLog(@"Navigation bar class: %@", [[myNav class] description]);
};

- (void)updateRegionLabel{
    if(_region_id>0){
        NSDictionary *curRegion = [_regionsDictionary objectForKey:[NSNumber numberWithInt:_region_id]];;
        if(curRegion){
            _curCityLabel.text = [curRegion objectForKey:@"region_name"];
        }else{
            _curCityLabel.text = @"Неизвестный регион";
        };
        return;
    };
    if(_district_id>0){
        for(id oneRegionId in [[_regionsDictionary keyEnumerator] allObjects]){
            NSDictionary *curRegion = [_regionsDictionary objectForKey:oneRegionId];
            
            for(id oneDistrictId in [[curRegion keyEnumerator] allObjects]){
                if([oneDistrictId isKindOfClass:[NSString class]] && [oneDistrictId isEqualToString:@"region_name"]) continue;
                
                if([oneDistrictId isKindOfClass:[NSNumber class]] && [oneDistrictId integerValue]==_district_id){
                    _curCityLabel.text = [curRegion objectForKey:oneDistrictId];
                    return;
                };
            };
        };
        
        return;
    };
    
    _curCityLabel.text = @"Неизвестный регион";
    return;
};

- (void)onShowMap:(id)sender{
    if(_mapController==nil){
        _mapController = [[HSStationsMapViewController alloc] initWithNibName:@"HSStationsMapViewController" bundle:nil];
        _mapController.stationsArray = _stationsArray;
        [_mapController reloadMapPoints];
    };
    _mapController.center = curLocation;
    _mapController.span = MKCoordinateSpanMake(0.2, 0.2);
    [_mapController updateMapPosition];
    [self.navigationController pushViewController:_mapController animated:YES];
};

#pragma mark - Synchronization with Parse

- (void)updateLocalDatabase{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *stationsQuery = [PFQuery queryWithClassName:@"YAStations"];
    stationsQuery.limit = 1000;
    
    NSDate *latestChangeDateLocal = [[NSUserDefaults standardUserDefaults] objectForKey:@"latestStationsChangedDate"];
    if(latestChangeDateLocal){
        [stationsQuery whereKey:@"updatedAt" greaterThan:latestChangeDateLocal];
    };
    
    [stationsQuery findObjectsInBackgroundWithTarget:self selector:@selector(isNewRecorsdInServer:error:)];
};

- (void)isNewRecorsdInServer:(NSArray *)result error:(NSError *)error{
    if(error){
        NSLog(@"Cannot connected to Parse");
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        return;
    };
    
    if([result count]>0){
        NSLog(@"Stations: need to update, updating...", [result count]);
        
        isSyncInProgress = YES;
        PFQuery *stationsQuery = [PFQuery queryWithClassName:@"YAStations"];
        stationsQuery.limit = 1000;
        [stationsQuery findObjectsInBackgroundWithTarget:self selector:@selector(processDataFromServer:error:)];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:USER_DEFAULTS_LAST_SYNC_DATE_ID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    };
};

- (void)processDataFromServer:(NSArray *)result error:(NSError *)error{
    if(error){
        NSLog(@"Cannot connected to Parse");
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isSyncInProgress = NO;
        return;
    };
    
    NSLog(@"Received %d records from Parse!", [result count]);
    
    NSMutableArray *newRecords = [[NSMutableArray alloc] init];
    PFObject *oneObj = nil;
    NSMutableDictionary *oneRecDic = nil;
    for(oneObj in result){
        oneRecDic = [[NSMutableDictionary alloc] init];
        for(NSString *oneKey in [oneObj allKeys]){
            [oneRecDic setObject:[oneObj objectForKey:oneKey] forKey:oneKey];
        };
        [newRecords addObject:oneRecDic];
        
        
        // Form regions dictionary
        if([oneObj objectForKey:@"region_id"] && [oneObj objectForKey:@"region_name"]){
            NSMutableDictionary *curRegion = [_regionsDictionary objectForKey:[oneObj objectForKey:@"region_id"]];
            if(curRegion==nil){
                curRegion = [[NSMutableDictionary alloc] init];
                [curRegion setObject:[oneObj objectForKey:@"region_name"] forKey:@"region_name"];
                [_regionsDictionary setObject:curRegion forKey:[oneObj objectForKey:@"region_id"]];
            };
            if([oneObj objectForKey:@"district_name"] && [oneObj objectForKey:@"district_id"]){
                [curRegion setObject:[oneObj objectForKey:@"district_name"] forKey:[oneObj objectForKey:@"district_id"]];
            };
        };
    };
    
    [_stationsArray removeAllObjects];
    [_stationsArray addObjectsFromArray:newRecords];
    isSyncInProgress = NO;
    // Saving to local file
    [self saveDatabase];
    
    if(_mapController){
        _mapController.stationsArray = _stationsArray;
        [_mapController reloadMapPoints];
    };
    
    if((_region_id==-1 && _district_id==-1) || [_curCityLabel.text isEqualToString:@"Неизвестный регион"]){
        [self requestUserLocation];
    };
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:USER_DEFAULTS_LAST_SYNC_DATE_ID];
};


- (void)saveDatabase{
    //Saving stations
    NSString *baseDir = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Caches"];
    NSString *stationsFilePath = [NSString stringWithFormat:@"%@/%@", baseDir, @"stations.dat"];
    NSFileManager *fileMan = [NSFileManager defaultManager];
    if([fileMan fileExistsAtPath:stationsFilePath]){
        [fileMan removeItemAtPath:stationsFilePath error:nil];
    };
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:_stationsArray];
    [fileMan createFileAtPath:stationsFilePath contents:arrayData attributes:nil];
    
    //Saving regions
    NSString *regionsFilePath = [NSString stringWithFormat:@"%@/%@", baseDir, @"regions.dat"];
    if([fileMan fileExistsAtPath:regionsFilePath]){
        [fileMan removeItemAtPath:regionsFilePath error:nil];
    };
    NSData *dictionaryData = [NSKeyedArchiver archivedDataWithRootObject:_regionsDictionary];
    [fileMan createFileAtPath:regionsFilePath contents:dictionaryData attributes:nil];
    [self updateStations];
};

#pragma mark - Current location determine method

- (void)requestUserLocation{
    if([CLLocationManager locationServicesEnabled] == YES) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.distanceFilter = 100;
    }else{
        self.locationManager = nil;
    };
    
    if(self.locationManager){
        [self.locationManager startUpdatingLocation];
    }else{
        [self updateStations];
    };
};

- (CLLocationDistance)distanceBetweenPoint:(CLLocationCoordinate2D)from toPoint:(CLLocationCoordinate2D)to{
    CLLocation *locationFrom = [[CLLocation alloc] initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *locationTo = [[CLLocation alloc] initWithLatitude:to.latitude longitude:to.longitude];
    //NSLog(@"Distance between (%.5f, %.5f) and (%.5f, %.5f) = %.2f", from.latitude, from.longitude, to.latitude, to.longitude, [locationTo distanceFromLocation:locationFrom]);
    return [locationTo distanceFromLocation:locationFrom];
};

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error {
    NSLog(@"Cannot determine current location! Error: %@", [error localizedDescription]);
    curLocation = CLLocationCoordinate2DMake(0, 0);
    [self selectCityByLocation:[[CLLocation alloc] initWithLatitude:0 longitude:0]];
};

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations {
    CLLocation *location = [locations lastObject];
    curLocation = location.coordinate;
    if(_mapController) _mapController.center = curLocation;
    
    
    NSLog(@"Location determined (IOS 6): %.7f, %.7f", curLocation.latitude, curLocation.longitude);
    [self selectCityByLocation:location];
    [manager stopUpdatingLocation];
};

- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation {
    curLocation  = newLocation.coordinate;
    if(_mapController) _mapController.center = curLocation;
    
    NSLog(@"Location determined (IOS 5): %.7f, %.7f", curLocation.latitude, curLocation.longitude);
    [self selectCityByLocation:newLocation];
    [manager stopUpdatingLocation];
};

- (void)selectCityByLocation:(CLLocation *)location{
    [self updateStationsByDistanceFromLocation:location.coordinate];
    
    if(isCitySelectedByGeolocationOnceAtThisSession){
        [self updateStations];
        return;
    };
    
    CLLocationCoordinate2D coord = [location coordinate];
    NSString* url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@&language=ru&sensor=true", [NSString stringWithFormat:@"%f,%f", coord.latitude, coord.longitude]];
    HSSingleReqest *request = [[HSSingleReqest alloc] initWithURL:url andDelegate:self andCallbackFunction:@selector(regionWasDetermined:data:) andErrorCallBackFunction:@selector(regionCannotBeDetermined:data:)];
    request.method = HSHTTPMethodGET;
    request.url = url;
    [request sendRequest];
};

- (void)updateStationsByDistanceFromLocation:(CLLocationCoordinate2D)curPoint{
    for(NSMutableDictionary *oneStation in _stationsArray){
        CLLocationCoordinate2D stationPoint = CLLocationCoordinate2DMake([[oneStation objectForKey:@"lat"] doubleValue], [[oneStation objectForKey:@"lon"] doubleValue]);
        double curDist = [self distanceBetweenPoint:curPoint toPoint:stationPoint];
        [oneStation setObject:[NSNumber numberWithDouble:curDist] forKey:@"_distance"];
    };
};

- (void)regionWasDetermined:(HSSingleReqest*)request data:(NSData*)data {
    //NSString *locality = nil;
    BOOL isFoundedRegion = NO;
    BOOL noLocality = NO, noArea1 = NO, noArea2 = NO;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString* name;
    if([json isKindOfClass:[NSDictionary class]]){
        NSString* status = [json objectForKey:@"status"];
        if([status isEqualToString:@"OK"] == YES) {
            NSArray* results = [json objectForKey:@"results"];
            if([results count] > 0) {
                NSDictionary* first = [results objectAtIndex:0];
                NSArray* addressComponents = [first objectForKey:@"address_components"];
                for(NSDictionary * item in addressComponents) {
                    
                    NSString* type = [[item objectForKey:@"types"] objectAtIndex:0];
                    if(!noLocality && !noArea1 && !noArea2 && [type isEqualToString:@"locality"] == YES) {
                        name = [item objectForKey:@"long_name"];
                        if([name isKindOfClass:[NSString class]] == YES) {
                            if([self tryToSetRegionWithStr:name]){
                                isFoundedRegion = YES;
                                break;
                            };
                            noLocality = YES;
                        };
                    };
                    if(noLocality && !noArea1 && !noArea2 && [type isEqualToString:@"administrative_area_level_1"] == YES) {
                        name = [item objectForKey:@"long_name"];
                        if([name isKindOfClass:[NSString class]] == YES) {
                            if([self tryToSetRegionWithStr:name]){
                                isFoundedRegion = YES;
                                break;
                            };
                            noArea1 = YES;
                        };
                    };
                    if(noLocality && noArea1 && !noArea2 && [type isEqualToString:@"administrative_area_level_1"] == YES) {
                        name = [item objectForKey:@"long_name"];
                        if([name isKindOfClass:[NSString class]] == YES) {
                            if([self tryToSetRegionWithStr:name]){
                                isFoundedRegion = YES;
                                break;
                            };
                            noArea2 = YES;
                        };
                    };
                };
            };
        };
    };
    
    
    
    if(!isFoundedRegion){
        NSString* resultStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Cannot determine current region! Reply from geocoder: %@", resultStr);
        [self loadLastChoice];
    }else{
        //perform geocoding for current region area
        //[self requestCurrentRegionAreaWithRegionName:name];
        isCitySelectedByGeolocationOnceAtThisSession = YES;
    }
    
    [self updateStations];
};


- (void)regionCannotBeDetermined:(HSSingleReqest*)request data:(NSError *)error{
    NSLog(@"Cannot determine region name throught google! Message: %@", [error localizedDescription]);

    [self loadLastChoice];
    [self updateStations];
};

- (void)requestCurrentRegionAreaWithRegionName:(NSString *)regionName{
    if(regionName){
        NSString* url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&language=ru&sensor=true", regionName];
        HSSingleReqest *request = [[HSSingleReqest alloc] initWithURL:url andDelegate:self andCallbackFunction:@selector(regionAreaWasDetermined:data:) andErrorCallBackFunction:@selector(regionAreaCannotBeDetermined:data:)];
        request.method = HSHTTPMethodGET;
        request.url = url;
        [request sendRequest];
    };
};

- (void)regionAreaWasDetermined:(HSSingleReqest*)request data:(NSData*)data{
    _mapController.center = CLLocationCoordinate2DMake(0, 0);
    _mapController.span = MKCoordinateSpanMake(0, 0);
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if([json isKindOfClass:[NSDictionary class]]){
        NSString *status = [json objectForKey:@"status"];
        if([status isEqualToString:@"OK"] == YES) {
            NSArray *results = [json objectForKey:@"results"];
            if([results count] > 0) {
                NSDictionary *first = [results objectAtIndex:0];
                NSDictionary *geometry = [first objectForKey:@"geometry"];
                if(geometry){
                    CLLocationCoordinate2D curCardCenter;
                    curCardCenter.latitude = [[[geometry objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
                    curCardCenter.longitude = [[[geometry objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
                    _mapController.center = curCardCenter;
                    NSDictionary *southWest = [[geometry objectForKey:@"viewport"] objectForKey:@"southwest"];
                    NSDictionary *northEast = [[geometry objectForKey:@"viewport"] objectForKey:@"northeast"];
                    if(southWest && northEast){
                        MKCoordinateSpan curRegionSpan;
                        curRegionSpan.latitudeDelta = fabs([[southWest objectForKey:@"lat"] doubleValue] - [[northEast objectForKey:@"lat"] doubleValue])/2.0;
                        curRegionSpan.longitudeDelta = fabs([[southWest objectForKey:@"lng"] doubleValue] - [[northEast objectForKey:@"lng"] doubleValue])/2.0;
                        _mapController.span = curRegionSpan;
                    };
                };
            };
        };
    };
};

- (void)regionAreaCannotBeDetermined:(HSSingleReqest*)request data:(NSError *)error{
    NSLog(@"Cannot determine region area throught google! Message: %@", [error localizedDescription]);
};

- (BOOL)isRegion:(NSString *)region1 equalToRegion:(NSString *)region2{
    NSRange containsRange = [region1 rangeOfString:region2];
    if(containsRange.location!=NSNotFound){
        return YES;
    }else{
        containsRange = [region2 rangeOfString:region1];
        if(containsRange.location!=NSNotFound){
            return YES;
        };
    };

    return NO;
};

- (BOOL)tryToSetRegionWithStr:(NSString *)regionStr{
    if(regionStr && _regionsDictionary && [_regionsDictionary count]>0){
        NSLog(@"Region: %@", regionStr);
        
        BOOL isFounded = NO;
        for(id oneRegionId in [[_regionsDictionary keyEnumerator] allObjects]){
            NSDictionary *curRegion = [_regionsDictionary objectForKey:oneRegionId];
            NSString *curRegionName = [curRegion objectForKey:@"region_name"];
            
            if([self isRegion:curRegionName equalToRegion:regionStr]){
                isFounded = YES;
                _region_id = [oneRegionId integerValue];
                _district_id = -1;
                break;
            };
            
            for(id oneDistrictId in [[curRegion keyEnumerator] allObjects]){
                if([oneDistrictId isKindOfClass:[NSString class]] && [oneDistrictId isEqualToString:@"region_name"]) continue;
                
                NSString *curDistrictName = [curRegion objectForKey:oneDistrictId];
                if([self isRegion:curDistrictName equalToRegion:regionStr]){
                    isFounded = YES;
                    _region_id = -1;
                    _district_id = [oneDistrictId integerValue];
                    break;
                };
            };
        };
        
        return isFounded;
    };
    
    return NO;
};

- (void)updateListWithRegion:(NSString *)regionStr{
    [self tryToSetRegionWithStr:regionStr];
    
    
    [self updateStations];
    
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
};

#pragma mark - Table view delegate routines

- (BOOL)isSearchModeForTable:(UITableView *)tableView{
    return tableView==self.searchDisplayController.searchResultsTableView ? YES : NO;
};

- (NSDictionary *)dictionaryForTable:(UITableView *)tableView forStationKeyPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *currentStationsDictionary = [self isSearchModeForTable:tableView] ? _filteredDictionary : _stationsByDistance;
    NSArray *curSectionArray = nil;
    NSDictionary *curDict = nil;
    
    switch ([indexPath section]) {
        case 0:
            curSectionArray = [currentStationsDictionary objectForKey:@"lessThan1"];
            break;
        case 1:
            curSectionArray = [currentStationsDictionary objectForKey:@"lessThan3"];
            break;
        case 2:
            curSectionArray = [currentStationsDictionary objectForKey:@"lessThan5"];
            break;
        case 3:
            curSectionArray = [currentStationsDictionary objectForKey:@"lessThan10"];
            break;
        case 4:
            curSectionArray = [currentStationsDictionary objectForKey:@"lessThan15"];
            break;
        case 5:
            curSectionArray = [currentStationsDictionary objectForKey:@"moreThan15"];
            break;
    };
    if(curSectionArray==nil || [curSectionArray count]<=[indexPath row]){
        return nil;
    };
    
    curDict = [curSectionArray objectAtIndex:[indexPath row]];
    
    return curDict;
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSMutableDictionary *currentStationsDictionary = [self isSearchModeForTable:tableView] ? _filteredDictionary : _stationsByDistance;
    
    return [[[currentStationsDictionary keyEnumerator] allObjects] count];
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableDictionary *currentStationsDictionary = [self isSearchModeForTable:tableView] ? _filteredDictionary : _stationsByDistance;

    switch (section) {
        case 0:
            return [[currentStationsDictionary objectForKey:@"lessThan1"] count];
            break;
        case 1:
            return [[currentStationsDictionary objectForKey:@"lessThan3"] count];
            break;
        case 2:
            return [[currentStationsDictionary objectForKey:@"lessThan5"] count];
            break;
        case 3:
            return [[currentStationsDictionary objectForKey:@"lessThan10"] count];
            break;
        case 4:
            return [[currentStationsDictionary objectForKey:@"lessThan15"] count];
            break;
        case 5:
            return [[currentStationsDictionary objectForKey:@"moreThan15"] count];
            break;
            
        default:
            return 0;
            break;
    };
};

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSMutableDictionary *currentStationsDictionary = [self isSearchModeForTable:tableView] ? _filteredDictionary : _stationsByDistance;
    
    NSInteger elementsConnt = 0;
    switch (section) {
        case 0:
            elementsConnt = [[currentStationsDictionary objectForKey:@"lessThan1"] count];
            break;
        case 1:
            elementsConnt = [[currentStationsDictionary objectForKey:@"lessThan3"] count];
            break;
        case 2:
            elementsConnt = [[currentStationsDictionary objectForKey:@"lessThan5"] count];
            break;
        case 3:
            elementsConnt = [[currentStationsDictionary objectForKey:@"lessThan10"] count];
            break;
        case 4:
            elementsConnt = [[currentStationsDictionary objectForKey:@"lessThan15"] count];
            break;
        case 5:
            elementsConnt = [[currentStationsDictionary objectForKey:@"moreThan15"] count];
            break;
            
        default:
            return 0;
            break;
    };
    
    return elementsConnt>0 ? 30.0 : 0.0;
};

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return STATION_ROW_HEIGHT;
    NSDictionary *curDict = [self dictionaryForTable:tableView forStationKeyPath:indexPath];
    if(curDict==nil) return 0.0;
    
    NSString *nameStr = [curDict objectForKey:@"name"];
    NSString *addressStr = [curDict objectForKey:@"shortaddress"] ? [curDict objectForKey:@"shortaddress"] : [curDict objectForKey:@"address"];
    NSString *labelStr = [NSString stringWithFormat:@"%@\n%@", (nameStr ? nameStr : @""), (addressStr ? addressStr : @"")];
    CGSize labelSize = [labelStr sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:CGSizeMake(300, 100500) lineBreakMode:NSLineBreakByWordWrapping];
    
    //NSLog(@"Height for index path (%d, %d) = %.1f", indexPath.section, indexPath.row, labelSize.height+10.0);
    return labelSize.height+10.0;
 };


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    float headerHeight = [self tableView:tableView heightForHeaderInSection:section];
    if(headerHeight<=0) return nil;
    
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
    };
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, headerHeight)];
    headerView.clipsToBounds = NO;
    UIImageView *headerBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DonorStations_tableHeaderBackground"]];
    //headerBackground.frame = headerView.bounds;
    [headerView addSubview:headerBackground];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
    headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    headerLabel.textColor = DONOR_STATIONS_SEPARATOR_TEXT_COLOR;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.text = headerStr;
    [headerView addSubview:headerLabel];
    
    return headerView;
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID;
    cellID = @"InvitroOnlineRootHistoryCellID";
    
    float cellHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UILabel *regionLabel;
    UIImageView *separator = nil;
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        
        regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, cellHeight-10)];
        regionLabel.tag = 10;
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
        cell.selectedBackgroundView.backgroundColor = RGBA_COLOR(0, 0, 0, 0.1);
        
        separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DonorStations_tableCellSeparator"]];
        separator.tag = 11;
        [cell addSubview:separator];
    };
    
    regionLabel = (UILabel *)[cell viewWithTag:10];
    NSDictionary *curDict = [self dictionaryForTable:tableView forStationKeyPath:indexPath];
    NSString *nameStr = [curDict objectForKey:@"name"];
    NSString *addressStr = [curDict objectForKey:@"shortaddress"] ? [curDict objectForKey:@"shortaddress"] : [curDict objectForKey:@"address"];
    regionLabel.text = [NSString stringWithFormat:@"%@\n%@", (nameStr ? nameStr : @""), (addressStr ? addressStr : @"")];
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0){
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:regionLabel.text];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:DONOR_TEXT_COLOR range:NSMakeRange(0, [nameStr length])];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:DONOR_GREEN_COLOR range:NSMakeRange([nameStr length]+1, [addressStr length])];
        regionLabel.attributedText = attributedStr;
        regionLabel.highlightedTextColor = DONOR_RED_COLOR;
    };
    CGRect regionLabelFrame = regionLabel.frame;
    regionLabelFrame.size.height = cellHeight-10;
    regionLabel.frame = regionLabelFrame;
    
    separator = (UIImageView *)[cell viewWithTag:11];
    CGRect separatorFrame = separator.frame;
    separatorFrame.origin = CGPointMake(12, cellHeight-3);
    separator.frame = separatorFrame;
    
    return cell;
    
};


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *curDict = [self dictionaryForTable:tableView forStationKeyPath:indexPath];
    if(curDict){
        HSStationCardViewController *cardViewController = [[HSStationCardViewController alloc] initWithNibName:@"HSStationCardViewController" bundle:nil];
        cardViewController.stationDictionary = curDict;
        [self.navigationController pushViewController:cardViewController animated:YES];
    };
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
};


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.backgroundColor = [UIColor clearColor];
    
};


#pragma mark - Supporting for sliding search-bar

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(_blockDidScrollDelegateCall || self.searchDisplayController.isActive) return;
    
    float offset = scrollView.contentOffset.y;
    UIView *searchBar = (UIView *)self.searchDisplayController.searchBar;
    if(offset<0){
        isSearchBarShowed = ((-offset)>searchBar.frame.size.height) ? YES : NO;
    }else{
        isSearchBarShowed = NO;
    };
    
    CGRect searchBarRect = searchBar.frame;
    float barOffset = isSearchBarShowed ? searchBar.frame.size.height : (-offset);
    searchBarRect.origin.y = scrollView.frame.origin.y - searchBar.frame.size.height + barOffset;
    searchBar.frame = searchBarRect;
    
    scrollView.contentInset = UIEdgeInsetsMake(barOffset>0 ? barOffset : 0, 0, 0, 0);
    //NSLog(@"scrollViewDidScroll: %.0f (%@), barOffset = %.0f", scrollView.contentOffset.y, isSearchBarShowed ? @"SHOW" : @"HIDE", barOffset);
    
};

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _blockDidScrollDelegateCall = NO;
};

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if(targetContentOffset->y < 0){
        //NSLog(@"END DRAGGING: offset: %.0f->%.0f; %@ bar", scrollView.contentOffset.y, targetContentOffset->y, isSearchBarShowed ? @"SHOW" : @"HIDE");
        UIView *searchBar = (UIView *)self.searchDisplayController.searchBar;
        if(isSearchBarShowed){
            [UIView animateWithDuration:0.5 animations:^{
                scrollView.contentInset = UIEdgeInsetsMake(searchBar.bounds.size.height, 0, 0, 0);
                CGRect searchBarRect = searchBar.frame;
                searchBarRect.origin.y = scrollView.frame.origin.y;
                searchBar.frame = searchBarRect;
            }];
        }else{
            _blockDidScrollDelegateCall = YES;
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                CGRect searchBarRect = searchBar.frame;
                searchBarRect.origin.y = scrollView.frame.origin.y - searchBarRect.size.height;
                searchBar.frame = searchBarRect;
            } completion:^(BOOL finished){
                _blockDidScrollDelegateCall = NO;
            }];
        };
    };
};



#pragma mark - UISearchDisplayController Delegate Methods

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
    for(UIView *oneView in self.searchDisplayController.searchBar.subviews){
        if([oneView isKindOfClass:[UIButton class]]){
            [(UIButton *)oneView setTitle:@"Отменить" forState:UIControlStateNormal];
        };
    };
};

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
    
};
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    
};
- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    
};

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
	NSString *str;
    NSRange substringRange;
    BOOL isResults = NO;
    
	for (NSString *oneKey in [[_stationsByDistance keyEnumerator] allObjects]){
        NSMutableArray *curDistArray = [_stationsByDistance objectForKey:oneKey];
        NSMutableArray *curDistArrayFiltered = [_filteredDictionary objectForKey:oneKey];
        [curDistArrayFiltered removeAllObjects];
        
        for(NSMutableDictionary *oneStation in curDistArray){
            str = [oneStation objectForKey:@"name"];
            substringRange = [str rangeOfString:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [str length])];
            if(substringRange.location != NSNotFound){
                [curDistArrayFiltered addObject:oneStation];
                isResults = YES;
                continue;
            }else{
                str = [oneStation objectForKey:@"address"];
                substringRange = [str rangeOfString:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [str length])];
                if(substringRange.location != NSNotFound){
                    [curDistArrayFiltered addObject:oneStation];
                    isResults = YES;
                    continue;
                };
            };
        };
	};
    
    if(!isResults){
        double delayInSeconds = 0.001;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            for(UIView *oneView in self.searchDisplayController.searchResultsTableView.subviews){
                if([oneView isKindOfClass:[UILabel class]]){
                    [(UILabel *)oneView setText:@"Не найдено"];
                };
            };
        });
    };
    
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
};


- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    
};
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView{
    //CGRect rct = tableView.frame;
    //tableView.frame = CGRectMake(rct.origin.x, rct.origin.y, 240.0, rct.size.height);
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _stationsTable.hidden = YES;
};
- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView{
    _stationsTable.hidden = NO;
};
- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView{
    
};




@end
