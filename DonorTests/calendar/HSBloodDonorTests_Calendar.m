//
//  HSBloodDonorTests_Calendar.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 21.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSBloodDonorTests_Calendar.h"

#import <Parse/Parse.h>

#import "HSCalendar.h"
#import "HSModelCommon.h"
#import "HSEvent.h"

@implementation HSBloodDonorTests_Calendar

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) testLoadRemoteEvents {
    [PFUser logOut];
    PFUser *currentUser = [PFUser logInWithUsername: @"serjbazuka@gmail.com" password:@"123"];
    STAssertTrue(currentUser != nil, @"Unable to login");
    
    HSCalendar *calendar = [HSCalendar sharedInstance];
    [calendar unlockModelWithUser:currentUser];
    __block BOOL testDone = NO;
    [calendar pullEventsFromServer:^(BOOL success, NSError *error) {
        STAssertTrue(success, @"Pull remote events should not failed.");
        for (HSEvent *event in [calendar allEvents]) {
            NSLog(@"Event: %@", event);
        }
        testDone = YES;
    }];
    while (!testDone) {
        [NSThread sleepForTimeInterval: 0.1];
    }
    [calendar lockModel];
    [PFUser logOut];

}

@end
