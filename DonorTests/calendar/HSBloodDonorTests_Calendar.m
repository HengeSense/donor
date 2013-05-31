//
//  HSBloodDonorTests_Calendar.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 21.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSBloodDonorTests_Calendar.h"

#import <objc/runtime.h>

#import <Parse/Parse.h>
#import <OCMock/OCMock.h>

#import "Swizzler.h"

#import "HSCalendar.h"
#import "HSModelCommon.h"
#import "HSEvent.h"
#import "HSBloodDonationEvent.h"
#import "HSBloodTestsEvent.h"

#import "HSBloodRemoteEventMoc.h"

#pragma mark - PFUser test data
static NSString * const kPFUserMoc_Useranme = @"test";
static NSString * const kPFUserMoc_Email = @"test@test.com";
static NSString * const kPFUserMoc_Password = @"test";
static NSString * const kPFUserMoc_Token = @"QWER-QWER-QWER-QWER";

#pragma mark - PFUser singleton stub
static PFUser *_mocCurrentUser = nil;

@interface PFUser (MocStub)
+ (PFUser *)currentUser;
@end

@implementation PFUser (MocStub)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (PFUser *)currentUser {
    return _mocCurrentUser;
}

#pragma clang diagnostic pop
@end

#pragma mark - HSCalendar private interface discovering
@interface HSCalendar ()

- (void)checkUnlockedModelPrecondition;
- (BOOL)canAddBloodRemoteEvent: (HSBloodRemoteEvent *)bloodRemoteEvent error: (NSError **)error;

@end

#pragma mark - HSBloodDonorTests_Calendar
@implementation HSBloodDonorTests_Calendar

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_CheckUnlockedModelPrecondition {
    id calendar = [OCMockObject partialMockForObject:[[HSCalendar alloc] init]];
    [calendar lockModel];

    HSBloodRemoteEvent *testEvent = [[HSBloodRemoteEvent alloc] init];
    
    [[calendar expect] checkUnlockedModelPrecondition];
    STAssertThrows([calendar addBloodRemoteEvent:testEvent ignoreRestPeriod:NO completion:nil],
            @"Model is locked. This method invocation should rise exception");
    [calendar verify];

    [[calendar expect] checkUnlockedModelPrecondition];
    STAssertThrows([calendar removeBloodRemoteEvent:testEvent completion:nil],
            @"Model is locked. This method invocation should rise exception");
    [calendar verify];

    [[calendar expect] checkUnlockedModelPrecondition];
    STAssertThrows([calendar replaceBloodRemoteEvent:testEvent withEvent:testEvent ignoreRestPeriod:NO completion:nil],
            @"Model is locked. This method invocation should rise exception");
    [calendar verify];
    
    [[calendar expect] checkUnlockedModelPrecondition];
    STAssertThrows([calendar pullEventsFromServer:nil],
                   @"Model is locked. This method invocation should rise exception");
    [calendar verify];

}

- (void)test_NotificationMechanism {
    _mocCurrentUser = [OCMockObject niceMockForClass:[PFUser class]];
    [self configureMockedUser:_mocCurrentUser];
    [self validateMockedCurentUser];
    
    id calendar = [OCMockObject partialMockForObject:[[HSCalendar alloc] init]];
    [[[calendar stub] andReturnValue:[NSNumber numberWithBool:YES]] canAddBloodRemoteEvent:OCMOCK_ANY error:nil];
    
    [calendar unlockModelWithUser:[PFUser currentUser]];

    /*
     * [HSCalendar addBloodRemoteEvent:completion] tries to save new added event by remote service invocation.
     *     so it should be mocked.
     */
    [Swizzler swizzleFromClass:[HSBloodRemoteEvent class] method:@selector(saveWithCompletionBlock:)
                       toClass:[HSBloodRemoteEventMoc class]];

    /*
     * [HSCalendar removeBloodRemoteEvent:completion:] tries to remove event by remote service invocation.
     *     so it should be mocked.
     */
    [Swizzler swizzleFromClass:[HSBloodRemoteEvent class] method:@selector(removeWithCompletionBlock:)
                       toClass:[HSBloodRemoteEventMoc class]];

    // Test for blood donation event.
    id donationEvent = [OCMockObject partialMockForObject:[[HSBloodDonationEvent alloc] init]];
    // Add donation event
    [[donationEvent expect] scheduleConfirmationLocalNotification];
    [[donationEvent expect] scheduleReminderLocalNotificationAtDate:OCMOCK_ANY];
    [calendar addBloodRemoteEvent:donationEvent ignoreRestPeriod:NO completion:nil];
    [donationEvent verify];
    
    // Remove donation event
    [[donationEvent expect] cancelScheduledLocalNotifications];
    [calendar removeBloodRemoteEvent:donationEvent completion:nil];
    [donationEvent verify];

    // Test for blood test event.
    id testEvent = [OCMockObject partialMockForObject:[[HSBloodTestsEvent alloc] init]];
    // Add test event
    [[testEvent expect] scheduleReminderLocalNotificationAtDate:OCMOCK_ANY];
    [calendar addBloodRemoteEvent:testEvent ignoreRestPeriod:NO completion:nil];
    [testEvent verify];
    
    // Remove test event
    [[testEvent expect] cancelScheduledLocalNotifications];
    [calendar removeBloodRemoteEvent:testEvent completion:nil];
    [testEvent verify];

    // Replace events
    [calendar addBloodRemoteEvent:donationEvent ignoreRestPeriod:NO completion:nil];

    [[donationEvent expect] cancelScheduledLocalNotifications];
    [[testEvent expect] scheduleReminderLocalNotificationAtDate:OCMOCK_ANY];
    [calendar replaceBloodRemoteEvent:donationEvent withEvent:testEvent ignoreRestPeriod:NO completion:nil];
    [testEvent verify];
    [donationEvent verify];

    
    [Swizzler deswizzle];
    [calendar lockModel];
    _mocCurrentUser = nil;
}

- (void)test_AddRemoveReplaceEvents {
    _mocCurrentUser = [OCMockObject niceMockForClass:[PFUser class]];
    [self configureMockedUser:_mocCurrentUser];
    [self validateMockedCurentUser];
    
    id calendar = [OCMockObject partialMockForObject:[[HSCalendar alloc] init]];
    [[[calendar stub] andReturnValue:[NSNumber numberWithBool:YES]] canAddBloodRemoteEvent:OCMOCK_ANY error:nil];
    
    [calendar unlockModelWithUser:[PFUser currentUser]];

    /**
     * [HSCalendar addBloodRemoteEvent:completion] tries to save new added event by invocing remote service,
     *     so it should be mocked.
     */
    [Swizzler swizzleFromClass:[HSBloodRemoteEvent class] method:@selector(saveWithCompletionBlock:)
                       toClass:[HSBloodRemoteEventMoc class]];
    
    /*
     * [HSCalendar removeBloodRemoteEvent:completion:] tries to remove event by remote service invocation.
     *     so it should be mocked.
     */
    [Swizzler swizzleFromClass:[HSBloodRemoteEvent class] method:@selector(removeWithCompletionBlock:)
                       toClass:[HSBloodRemoteEventMoc class]];

    // Test for blood donation event.
    id donationEvent = [OCMockObject partialMockForObject:[[HSBloodDonationEvent alloc] init]];
    // Add donation event
    [calendar addBloodRemoteEvent:donationEvent ignoreRestPeriod:NO completion:^(BOOL success, NSError *error) {
        STAssertTrue(success, @"Add event to calendar should be success.");
    }];
    STAssertTrue([[calendar allEvents] containsObject:donationEvent],
            @"Adding event was successfull so it should be in the calendar event list.");
    
    // Remove donation event
    [calendar removeBloodRemoteEvent:donationEvent completion:^(BOOL success, NSError *error) {
        STAssertTrue(success, @"Remove event from calendar should be success.");
    }];
    STAssertTrue(![[calendar allEvents] containsObject:donationEvent],
            @"Removing event was successfull so it shouldn't be in the calendar event list.");

    // Test for blood test event.
    id testEvent = [OCMockObject partialMockForObject:[[HSBloodTestsEvent alloc] init]];
    // Add test event
    [calendar addBloodRemoteEvent:testEvent ignoreRestPeriod:NO completion:^(BOOL success, NSError *error) {
        STAssertTrue(success, @"Add event to calendar should be success.");
    }];
    STAssertTrue([[calendar allEvents] containsObject:testEvent],
            @"Adding event was successfull so it should be in the calendar event list.");
    
    // Remove test event
    [calendar removeBloodRemoteEvent:testEvent completion:^(BOOL success, NSError *error) {
        STAssertTrue(success, @"Remove event from calendar should be success.");
    }];
    STAssertTrue(![[calendar allEvents] containsObject:testEvent],
            @"Removing event was successfull so it shouldn't be in the calendar event list.");
    
    // Replace events
    [calendar addBloodRemoteEvent:donationEvent ignoreRestPeriod:NO completion:nil];
    [calendar replaceBloodRemoteEvent:donationEvent withEvent:testEvent ignoreRestPeriod:NO
            completion:^(BOOL success, NSError *error)
    {
        STAssertTrue(success, @"Replacing event in calendar should be success.");
    }];
    STAssertTrue([[calendar allEvents] containsObject:testEvent],
            @"After event replacing testEvent should be in the calendar event list.");
    STAssertTrue(![[calendar allEvents] containsObject:donationEvent],
            @"After event replacing donationEvent shouldn't be in the calendar event list.");
    
    [Swizzler deswizzle];
    [calendar lockModel];
    _mocCurrentUser = nil;
}


#pragma mark - PFUser configuration / validation
- (void)configureMockedUser:(id)user {
    [[[user stub] andReturnValue:[NSNumber numberWithBool:YES]] isAuthenticated];
    [[[user stub] andReturnValue:[NSNumber numberWithBool:YES]] isNew];
    [[[user stub] andReturn:kPFUserMoc_Useranme] username];
    [[[user stub] andReturn:kPFUserMoc_Email] email];
    [[[user stub] andReturn:kPFUserMoc_Password] password];
    [[[user stub] andReturn:kPFUserMoc_Token] sessionToken];
}

- (void)validateMockedCurentUser {
    PFUser *currentUser = [PFUser currentUser];
    STAssertTrue([currentUser isAuthenticated], @"Current user should be authenticated.");
    STAssertTrue([currentUser isNew], @"Current user should be a new user.");
    STAssertTrue([currentUser.username isEqualToString:kPFUserMoc_Useranme],
            @"Current username should be '%@'.", kPFUserMoc_Useranme);
    STAssertTrue([currentUser.email isEqualToString:kPFUserMoc_Email],
            @"Current user email should be '%@'.", kPFUserMoc_Email);
    STAssertTrue([currentUser.password isEqualToString:kPFUserMoc_Password],
            @"Current user password should be '%@'.", kPFUserMoc_Password);
    STAssertTrue([currentUser.sessionToken isEqualToString:kPFUserMoc_Token],
            @"Current user password should be '%@'.", kPFUserMoc_Token);
}

@end
