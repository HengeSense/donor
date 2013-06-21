//
//  HSStationsMapViewController.h
//  Donor
//
//  Created by Eugine Korobovsky on 09.04.13.
//  Updated by Sergey Seroshtan on 24.05.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "HSStationInfo.h"

@interface HSStationsMapViewController : UIViewController <MKMapViewDelegate>

/// @name UI properties
@property (nonatomic, strong) IBOutlet MKMapView *stationsMap;

/// @name Model data configuration
@property (nonatomic, strong) NSArray *stations;

/// @name Map configuration
@property (nonatomic) CLLocationCoordinate2D center;
@property (nonatomic) MKCoordinateSpan span;

/// @name Initialization
/**
 * @param stations - array of HSStationInfo objects
 */
- (id)initWithStations:(NSArray *)stations;

/// @name Map interaction
- (void)reloadMapPoints;
- (void)updateMapPosition;

@end


@interface HSStationsMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong, readonly) HSStationInfo *stationInfo;
@property (nonatomic, weak, readonly) HSStationsMapViewController *delegate;

- (id)initWithStation:(HSStationInfo *)stationInfo andDelegate:(HSStationsMapViewController *)delegate;
- (void)showStation:(id)sender;

@end;