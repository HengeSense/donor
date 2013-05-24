//
//  HSStationsMapViewController.m
//  Donor
//
//  Created by Eugine Korobovsky on 09.04.13.
//  Updated by Sergey Seroshtan on 24.05.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSStationsMapViewController.h"
#import "HSStationCardViewController.h"

@interface HSStationsMapViewController ()
/// @name Properties
/// @name Map
@property (nonatomic, strong) NSMutableArray *annotations;

/// @name Private methods
- (void)openStation:(HSStationInfo *)stationInfo;

@end

@implementation HSStationsMapViewController

- (id)init {
    return [self initWithStations:nil];
}

- (id)initWithStations:(NSArray *)stations {
    self = [self initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if (self) {
        // Custom initialization
        self.annotations = [[NSMutableArray alloc] init];
        self.center = CLLocationCoordinate2DMake(0, 0);
        self.span = MKCoordinateSpanMake(0, 0);
        self.stations = stations;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Карта";
    
    [self reloadMapPoints];
    
    self.stationsMap.showsUserLocation = YES;
    [self updateMapPosition];
}

#pragma mark - Private
- (void)reloadMapPoints {
    [self.stationsMap removeAnnotations:self.annotations];
    [self.annotations removeAllObjects];
    for(HSStationInfo *stationInfo in self.stations){
        HSStationsMapAnnotation *stationAnnotation =
                [[HSStationsMapAnnotation alloc] initWithStation:stationInfo andDelegate:self];
        [self.annotations addObject:stationAnnotation];
    }
    [self.stationsMap addAnnotations:self.annotations];
}

- (void)openStation:(HSStationInfo *)stationInfo {
    THROW_IF_ARGUMENT_NIL(stationInfo);
    HSStationCardViewController *cardViewController =
            [[HSStationCardViewController alloc] initWithStationInfo:stationInfo];
    cardViewController.isShowAllInfoForced = YES;
    cardViewController.isMapButtonInitiallyHidden = YES;
    [self.navigationController pushViewController:cardViewController animated:YES];
}

- (BOOL)isSinglePoint {
    return self.stations != nil && [self.stations count] == 1;
}

- (void)updateMapPosition {
    
    if([self isSinglePoint]){
        HSStationInfo *stationInfo = (HSStationInfo *)self.stations[0];
        MKCoordinateRegion showedRegion = {};
        showedRegion.center = CLLocationCoordinate2DMake([stationInfo.lat doubleValue], [stationInfo.lon doubleValue]);
        showedRegion.span = MKCoordinateSpanMake(0.01, 0.01);
        [self.stationsMap setRegion:showedRegion animated:YES];
    } else if (!(fabs(self.center.latitude < 0.0001) && fabs(self.center.longitude < 0.0001))) {
        MKCoordinateRegion showedRegion = {};
        showedRegion.center = self.center;
        if(fabs(self.span.latitudeDelta < 0.0001) && fabs(self.span.longitudeDelta < 0.0001)){
            showedRegion.span = MKCoordinateSpanMake(0.2, 0.2);
        } else {
            showedRegion.span = self.span;
        }
        [self.stationsMap setRegion:showedRegion animated:YES];
    }
}

#pragma mark - Map Kit delegate routines
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {
    if([annotation isKindOfClass:[HSStationsMapAnnotation class]]) {
        MKAnnotationView *annotationView =
                [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annID"];
        [annotationView setImage:[UIImage imageNamed:@"mapAnnotationIcon"]];
        [annotationView setCalloutOffset:CGPointMake(0, 0)];
        [annotationView setCanShowCallout:YES];
        if(![self isSinglePoint]){
            [annotationView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
        calloutAccessoryControlTapped:(UIControl *)control {
    if([[view annotation] isKindOfClass:[HSStationsMapAnnotation class]] && ![self isSinglePoint]) {
        [((HSStationsMapAnnotation *)[view annotation]) showStation:nil];
    }
}


@end

#pragma mark - HSStationsMapAnnotation implementation
@interface HSStationsMapAnnotation ()

@property (nonatomic, strong, readwrite) HSStationInfo *stationInfo;
@property (nonatomic, weak, readwrite) HSStationsMapViewController *delegate;

@end

@implementation HSStationsMapAnnotation

- (id)initWithStation:(HSStationInfo *)stationInfo andDelegate:(HSStationsMapViewController *)delegate {
    THROW_IF_ARGUMENT_NIL(stationInfo);
    self = [super init];
    if(self){
        self.stationInfo = stationInfo;
        self.delegate = self.delegate;
    }
    
    return self;
}

- (CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake([self.stationInfo.lat doubleValue], [self.stationInfo.lon doubleValue]);
}

- (NSString *)title{
    return self.stationInfo.name;
}

- (NSString *)subtitle{
    return @"";
}

- (void)showStation:(id)sender {
    if (self.delegate) {
        [self.delegate openStation:self.stationInfo];
    }
}

@end
