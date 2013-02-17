//
//  StationsAnnotation.h
//  BloodDonor
//
//  Created by Владимир Носков on 09.08.12.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface StationsAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) UIImageView *imageAnnotation;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) int tag;

@end

