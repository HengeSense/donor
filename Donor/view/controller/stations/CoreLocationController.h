//
//  CoreLocationController.h
//  BloodDonor
//
//  Created by Владимир Носков on 09.08.12.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CoreLocationControllerDelegate

@required
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

@end

@interface CoreLocationController : NSObject <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) id delegate;

@end
