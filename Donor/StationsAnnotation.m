//
//  StationsAnnotation.m
//  BloodDonor
//
//  Created by Владимир Носков on 09.08.12.
//
//

#import "StationsAnnotation.h"

@implementation StationsAnnotation

@synthesize coordinate;
@synthesize imageAnnotation, title, tag;

- (void)dealloc
{
    self.imageAnnotation = nil;
    self.title = nil;
    [super dealloc];
}

@end
