//
//  CoreLocationController.m
//  BloodDonor
//
//  Created by Владимир Носков on 09.08.12.
//
//

#import "CoreLocationController.h"

@implementation CoreLocationController

@synthesize locationManager, delegate;

- (id)init
{
    self = [super init];
    
    if(self != nil)
    {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
        step = 10;
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.delegate locationUpdate:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.delegate locationError:error];
}

- (void)dealloc {
    [locationManager release];
    [super dealloc];
}

@end
