//
//  HSUserInfo.m
//  Donor
//
//  Created by Sergey Seroshtan on 30.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSUserInfo.h"
#import <Parse/Parse.h>

#pragma mark - Remote user keys
static NSString * const kRemoteUserField_Name = @"Name";
static NSString * const kRemoteUserField_SecondName = @"secondName";
static NSString * const kRemoteUserField_BloodGroup = @"BloodGroup";
static NSString * const kRemoteUserField_BloodRh = @"BloodRh";
static NSString * const kRemoteUserField_Sex = @"Sex";
static NSString * const kRemoteUserField_Platform = @"platform";

#pragma mark - Private interface definition
@interface HSUserInfo ()
@property (nonatomic, strong, readwrite) PFUser *user;
@end

@implementation HSUserInfo

#pragma mark - Initialization
- (id)initWithUser:(PFUser *)user {
    THROW_IF_ARGUMENT_NIL(user);
    self = [super init];
    if (self) {
        self.user = user;
        self.name = [user objectForKey:kRemoteUserField_Name];
        self.secondName = [user objectForKey:kRemoteUserField_SecondName];
        self.email = [user email];
        self.bloodGroup = [[user objectForKey:kRemoteUserField_BloodGroup] integerValue];
        self.bloodRh = [[user objectForKey:kRemoteUserField_BloodRh] integerValue];
        self.sex = [[user objectForKey:kRemoteUserField_Sex] unsignedIntegerValue];
        self.devicePlatform = devicePlatformFromString([user objectForKey:kRemoteUserField_Platform]);
    }
    return self;
}

#pragma mark - Applying changes
- (void)applyChanges {
    if (self.name != nil) {
        [self.user setObject:self.name forKey:kRemoteUserField_Name];
    }
    if (self.secondName != nil) {
        [self.user setObject:self.secondName forKey:kRemoteUserField_SecondName];
    }
    if (self.email != nil) {
        [self.user setEmail:self.email];
    }
    [self.user setObject:[NSNumber numberWithInteger:self.bloodGroup] forKey:kRemoteUserField_BloodGroup];
    [self.user setObject:[NSNumber numberWithInteger:self.bloodRh] forKey:kRemoteUserField_BloodRh];
    [self.user setObject:[NSNumber numberWithUnsignedInteger:self.sex] forKey:kRemoteUserField_Sex];
    [self.user setObject: devicePlatformToString(self.devicePlatform) forKey:kRemoteUserField_Platform];
}

@end
