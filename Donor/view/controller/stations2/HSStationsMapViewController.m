//
//  HSStationsMapViewController.m
//  Donor
//
//  Created by Eugine Korobovsky on 09.04.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSStationsMapViewController.h"
#import "HSStationCardViewController.h"

@interface HSStationsMapViewController ()

@end

@implementation HSStationsMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        annotations = [[NSMutableArray alloc] init];
        _center = CLLocationCoordinate2DMake(0, 0);
        _span = MKCoordinateSpanMake(0, 0);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Карта";
    
    [self reloadMapPoints];
    
    MKCoordinateRegion showedRegion;
    if([self isSinglePoint]){
        _stationsMap.showsUserLocation = NO;
        
        NSNumber *lan, *lon;
        lan = [[_stationsArray objectAtIndex:0] objectForKey:@"lat"];
        lon = [[_stationsArray objectAtIndex:0] objectForKey:@"lon"];
        showedRegion.center = CLLocationCoordinate2DMake([lan doubleValue], [lon doubleValue]);
        showedRegion.span = MKCoordinateSpanMake(0.01, 0.01);
        [_stationsMap setRegion:showedRegion animated:YES];
    }else{
        if(fabs(_center.latitude<0.0001) && fabs(_center.longitude<0.0001)){
            _stationsMap.showsUserLocation = YES;
        }else{
            _stationsMap.showsUserLocation = YES;
            showedRegion.center = _center;
            if(fabs(_span.latitudeDelta<0.0001) && fabs(_span.longitudeDelta<0.0001)){
                showedRegion.span = MKCoordinateSpanMake(0.1, 0.1);
            }else{
                showedRegion.span = _span;
            };
            [_stationsMap setRegion:showedRegion animated:YES];
        };
    };
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
};

- (void)reloadMapPoints{
    [_stationsMap removeAnnotations:annotations];
    [annotations removeAllObjects];
    for(NSDictionary *oneStation in _stationsArray){
        HSStationsMapAnnotation *oneAnnotation = [[HSStationsMapAnnotation alloc] initWithStation:oneStation andDelegate:self];
        [annotations addObject:oneAnnotation];
    };
    [_stationsMap addAnnotations:annotations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openStationForDictionary:(NSDictionary *)stationDict{
    if(stationDict){
        HSStationCardViewController *cardViewController = [[HSStationCardViewController alloc] initWithNibName:@"HSStationCardViewController" bundle:nil];
        cardViewController.stationDictionary = stationDict;
        cardViewController.isShowAllInfoForced = YES;
        cardViewController.isMapButtonInitiallyHidden = YES;
        [self.navigationController pushViewController:cardViewController animated:YES];
    };
};

- (BOOL)isSinglePoint{
    if(_stationsArray && [_stationsArray count]==1) return YES;
    
    return NO;
};

#pragma mark - Map Kit delegate routines


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {
    if([annotation isKindOfClass:[HSStationsMapAnnotation class]]) {
        MKAnnotationView *annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annID"];
        if(annView!=nil) {
            [annView setImage:[UIImage imageNamed:@"DonorStations_mapAnnotationIcon"]];
            [annView setCalloutOffset:CGPointMake(0, 0)];
            [annView setCanShowCallout:YES];
            if(![self isSinglePoint]){
                [annView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
            };
        };
        
        return annView;
    }
    return nil;
};

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if([[view annotation] isKindOfClass:[HSStationsMapAnnotation class]] && ![self isSinglePoint]) {
        [((HSStationsMapAnnotation *)[view annotation]) showStation:nil];
    };
};


@end

@implementation HSStationsMapAnnotation

- (id)initWithStation:(NSDictionary *)station andDelegate:(HSStationsMapViewController *)_del{
    self = [super init];
    if(self){
        curStation = station;
        _delegate = _del;
    };
    
    return self;
};

- (CLLocationCoordinate2D)coordinate{
    NSNumber *lan, *lon;
    lan = [curStation objectForKey:@"lat"];
    lon = [curStation objectForKey:@"lon"];
    return CLLocationCoordinate2DMake([lan doubleValue], [lon doubleValue]);
}

- (NSString *)title{
    return [curStation objectForKey:@"name"];
}

- (NSString *)subtitle{
    return @"";
};

- (void)showStation:(id)sender{
    [_delegate openStationForDictionary:curStation];
};

@end
