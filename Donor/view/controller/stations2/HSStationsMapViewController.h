//
//  HSStationsMapViewController.h
//  Donor
//
//  Created by Eugine Korobovsky on 09.04.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HSStationsMapViewController : UIViewController <MKMapViewDelegate> {
    NSMutableArray *annotations;
}

@property (nonatomic, strong) NSArray *stationsArray;
@property (nonatomic) CLLocationCoordinate2D center;
@property (nonatomic, strong) IBOutlet MKMapView *stationsMap;

- (void)reloadMapPoints;
- (void)openStationForDictionary:(NSDictionary *)stationDict;

@end


@interface HSStationsMapAnnotation : NSObject <MKAnnotation> {
    NSDictionary *curStation;
    
}

@property (nonatomic, assign) HSStationsMapViewController *delegate;

- (id)initWithStation:(NSDictionary *)station andDelegate:(HSStationsMapViewController *)_del;
- (void)showStation:(id)sender;

@end;