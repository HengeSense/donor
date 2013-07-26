//
//  HSMailChimp.m
//  Donor
//
//  Created by Sergey Seroshtan on 31.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSMailChimp.h"
#import "ChimpKit.h"
#import <Parse/Parse.h>

#import "HSUserInfo.h"
#import "NSString+HSUtils.h"

#pragma mark - Private interface declaration
@interface HSMailChimp () <ChimpKitDelegate>
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *listId;
@property (nonatomic, strong) ChimpKit *chimpKit;
@end

@implementation HSMailChimp

#pragma mark - Singleton
+ (HSMailChimp *)sharedInstance {
    static HSMailChimp *_sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Configuration
- (void)configureWithApiKey:(NSString *)apiKey listId:(NSString *)listId {
    self.apiKey = apiKey;
    self.listId = listId;
    self.chimpKit = [[ChimpKit alloc] initWithDelegate:self andApiKey:apiKey];
}

#pragma mark - Operations
- (void)subscribeOrUpdateEmail:(NSString *)email withUserFirstName:(NSString *)firstName lastName:(NSString *)lastName {
    if (email == nil || email.length == 0) {
        // Fix for https://itsbeta.atlassian.net/browse/DOI-211
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.listId forKey:@"id"];
    [params setValue:email forKey:@"email_address"];
    [params setValue:@"false" forKey:@"double_optin"];
    [params setValue:@"true" forKey:@"update_existing"];
    
    NSMutableDictionary *mergeVars = [NSMutableDictionary dictionary];
    [mergeVars setValue:email forKey:@"EMAIL"];
    if ([firstName isNotEmpty]) {
        [mergeVars setValue:firstName forKey:@"FNAME"];
    }
    if ([lastName isNotEmpty]) {
        [mergeVars setValue:lastName forKey:@"LNAME"];
    }
    [params setValue:mergeVars forKey:@"merge_vars"];
    
    [self.chimpKit callApiMethod:@"listSubscribe" withParams:params];
}

- (void)subscribeOrUpdateUser:(PFUser *)user {
    THROW_IF_ARGUMENT_NIL(user);
    HSUserInfo *userInfo = [[HSUserInfo alloc] initWithUser:user];
    [self subscribeOrUpdateEmail:userInfo.email withUserFirstName:userInfo.name lastName:userInfo.secondName];
}

#pragma mark - ChimpKitDelegate
- (void)ckRequestFailed:(NSError *)error {
    NSLog(@"%@: Email subscription or updating failed with error %@.", NSStringFromClass(self.class), error);
}

- (void)ckRequestSucceeded:(ChimpKit *)ckRequest {
    NSLog(@"%@: Email was successfully subscripted or updated.", NSStringFromClass(self.class));
}


@end
