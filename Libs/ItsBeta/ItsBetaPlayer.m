/*--------------------------------------------------*/

#import "ItsBetaPlayer.h"
#import "ItsBetaFastCache.h"
#import "ItsBetaRest.h"
#import "ItsBetaQueue.h"
#import "ItsBetaApi.h"
#import "ItsBeta.h"

/*--------------------------------------------------*/

#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)
#   import <FacebookSDK/FacebookSDK.h>
#else
#   import "ItsBetaGraphUser.h"
#   import "ItsBetaFacebookIPhone.h"
#   import "ItsBetaFacebookIPad.h"
#endif

/*--------------------------------------------------*/

#define ITSBETA_PLAYER_OBJECT_DEFAULT_PAGE_SIZE     100

/*--------------------------------------------------*/

@interface ItsBetaPlayer () {
    NSDate* _lastUpdateObjects;
    ItsBetaObjectCollection* _objects;
    
#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)
#else
    ItsBetaFacebook* _facebookController;
#endif
}

#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)
- (void) loginWithFacebookOfficialSDK:(ItsBetaPlayerLogin)callback;
- (void) logoutWithFacebookOfficialSDK:(ItsBetaPlayerLogout)callback;
+ (BOOL) handleOpenURL:(NSURL*)url;
#else
#if defined(TARGET_OS_IPHONE)
- (void) loginWithFacebook:(ItsBetaPlayerLogin)callback parentViewController:(UIViewController*)parentViewController;
#else
- (void) loginWithFacebook:(ItsBetaPlayerLogin)callback parentViewController:(NSViewController*)parentViewController;
#endif
- (void) logoutWithFacebook:(ItsBetaPlayerLogout)callback;
#endif

@end

/*--------------------------------------------------*/

@implementation ItsBetaPlayer

- (ItsBetaObjectCollection*) objects {
    __block ItsBetaObjectCollection* result = nil;
    [ItsBetaQueue runSync:^{
        result = _objects;
    }];
    return result;
}

+ (ItsBetaPlayer*) playerWithType:(ItsBetaPlayerType)type {
    return NS_SAFE_AUTORELEASE([[self alloc] initWithType:type]);
}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        _type = [coder decodeIntForKey:@"type"];
        _lastUpdateObjects = NS_SAFE_RETAIN([coder decodeObjectForKey:@"last_update_objects"]);
        _objects = NS_SAFE_RETAIN([coder decodeObjectForKey:@"objects"]);
        _Id = NS_SAFE_RETAIN([coder decodeObjectForKey:@"player_id"]);
        _facebookId = NS_SAFE_RETAIN([coder decodeObjectForKey:@"facebook_id"]);
        _facebookToken = NS_SAFE_RETAIN([coder decodeObjectForKey:@"facebook_token"]);
    }
    return self;
}

- (id) initWithType:(ItsBetaPlayerType)type {
    self = [super init];
    if(self != nil) {
        _type = type;
        _objects = NS_SAFE_RETAIN([ItsBetaObjectCollection collection]);
    }
    return self;
}

- (void) dealloc {
    NS_SAFE_RELEASE(_Id);
    NS_SAFE_RELEASE(_facebookId);
    NS_SAFE_RELEASE(_facebookToken);
    NS_SAFE_RELEASE(_objects);
    
#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)
#else
    NS_SAFE_RELEASE(_facebookController);
#endif
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) encodeWithCoder:(NSCoder*)coder {
    [coder encodeInt:_type forKey:@"type"];
    [coder encodeObject:_lastUpdateObjects forKey:@"last_update_objects"];
    [coder encodeObject:_objects forKey:@"objects"];
    [coder encodeObject:_Id forKey:@"player_id"];
    [coder encodeObject:_facebookId forKey:@"facebook_id"];
    [coder encodeObject:_facebookToken forKey:@"facebook_token"];
}

- (BOOL) synchronizeWithProject:(ItsBetaProject*)project {
    if([ItsBeta applicationAccessToken] != nil) {
        // ERROR
        return NO;
    }
    __block NSUInteger countObjects = 0;
    NSDate* lastUpdateObjects = [NSDate date];
    [ItsBetaApi requestServiceURL:[ItsBeta applicationServiceURL]
                      accessToken:[ItsBeta applicationAccessToken]
                       lastUpdate:lastUpdateObjects
                           player:self
                          project:project
                     countObjects:^(NSUInteger count, NSError *error) {
                         countObjects = count;
                     }];
    if(countObjects > 0) {
        NSUInteger countPage = 1;
        if(countObjects > ITSBETA_PLAYER_OBJECT_DEFAULT_PAGE_SIZE) {
            countPage = countObjects / ITSBETA_PLAYER_OBJECT_DEFAULT_PAGE_SIZE;
            if((countObjects % ITSBETA_PLAYER_OBJECT_DEFAULT_PAGE_SIZE) != 0) {
                countPage++;
            }
        }
        for(NSUInteger page = 0; page < countPage; page++) {
            [ItsBetaApi requestServiceURL:[ItsBeta applicationServiceURL]
                              accessToken:[ItsBeta applicationAccessToken]
                               lastUpdate:lastUpdateObjects
                                   player:self
                                  project:project
                                     page:page
                                  prePage:ITSBETA_PLAYER_OBJECT_DEFAULT_PAGE_SIZE
                                  objects:^(ItsBetaObjectCollection* collection, NSError *error) {
                                      [_objects setObjects:collection];
                                  }];
        }
    }
    NS_SAFE_SETTER(_lastUpdateObjects, lastUpdateObjects);
    return YES;
}

- (BOOL) isLogin {
    return (_Id != nil);
}

#if defined(TARGET_OS_IPHONE)
- (void) login:(ItsBetaPlayerLogin)callback parentViewController:(UIViewController*)parentViewController {
#else
- (void) login:(ItsBetaPlayerLogin)callback parentViewController:(NSViewController*)parentViewController {
#endif
    switch(_type) {
        case ItsBetaPlayerTypeFacebook:
#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)
            [self loginWithFacebookOfficialSDK:callback];
#else
            [self loginWithFacebook:callback parentViewController:parentViewController];
#endif
        break;
        default:
            if(callback != nil) {
                callback(nil);
            }
        break;
    }
}

- (void) loginWithFacebookId:(NSString*)facebookId facebookToken:(NSString*)facebookToken callback:(ItsBetaPlayerLogin)callback {
    [ItsBetaApi requestServiceURL:[ItsBeta applicationServiceURL]
                      accessToken:[ItsBeta applicationAccessToken]
                       facebookId:facebookId
                         playerId:^(NSString* playerId, NSError* error) {
                             if(_Id != playerId) {
                                 NS_SAFE_RELEASE(_Id);
                                 _Id = NS_SAFE_RETAIN(playerId);
                             }
                             if(_facebookId != facebookId) {
                                 NS_SAFE_RELEASE(_facebookId);
                                 _facebookId = NS_SAFE_RETAIN(facebookId);
                             }
                             if(_facebookToken != facebookToken) {
                                 NS_SAFE_RELEASE(_facebookToken);
                                 _facebookToken = NS_SAFE_RETAIN(facebookToken);
                             }
                             callback(error);
                         }];
}

- (void) logout:(ItsBetaPlayerLogout)callback {
    switch(_type) {
        case ItsBetaPlayerTypeFacebook:
#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)
            [self logoutWithFacebookOfficialSDK:callback];
#else
            [self logoutWithFacebook:callback];
#endif
        break;
        default:
            if(callback != nil) {
                callback(nil);
            }
        break;
    }
}

#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)

- (void) loginWithFacebookOfficialSDK:(ItsBetaPlayerLogin)callback {
#if __has_feature(objc_arc)
    __weak id safeSelf = self;
#else
    id safeSelf = self;
#endif
    [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_stream", @"publish_actions", nil]
                                       defaultAudience:FBSessionDefaultAudienceOnlyMe
                                          allowLoginUI:YES
                                     completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                         switch(state) {
                                             case FBSessionStateOpen:
                                             case FBSessionStateOpenTokenExtended:
                                                 [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary< FBGraphUser > *user, NSError *error) {
                                                     if(error == nil) {
                                                         [safeSelf loginWithFacebookId:[user id] facebookToken:[session accessToken] callback:callback];
                                                     } else {
                                                         callback([[error userInfo] objectForKey:@"com.facebook.sdk:ErrorInnerErrorKey"]);
                                                     }
                                                 }];
                                                 break;
                                             case FBSessionStateClosedLoginFailed:
                                                 [[FBSession activeSession] closeAndClearTokenInformation];
                                                 error = [NSError errorWithDomain:ItsBetaErrorDomain
                                                                             code:ItsBetaErrorFacebookAuth
                                                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                   @"Facebook.Fail.Session", NSLocalizedDescriptionKey,
                                                                                   nil]];
                                                 break;
                                             case FBSessionStateClosed:
                                                 break;
                                             default:
                                                 error = [NSError errorWithDomain:ItsBetaErrorDomain
                                                                             code:ItsBetaErrorFacebookAuth
                                                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                   @"Facebook.Fail.Unknown", NSLocalizedDescriptionKey,
                                                                                   nil]];
                                                 break;
                                         }
                                         if(error != nil) {
                                             callback(error);
                                         }
                                     }];
}

- (void) logoutWithFacebookOfficialSDK:(ItsBetaPlayerLogout)callback {
    if([FBSession activeSession] != nil) {
        [[FBSession activeSession] closeAndClearTokenInformation];
    }
    NS_SAFE_RELEASE(_Id);
    NS_SAFE_RELEASE(_facebookId);
    if(callback != nil) {
        callback(nil);
    }
}

+ (BOOL) handleOpenURL:(NSURL*)url {
    return [[FBSession activeSession] handleOpenURL:url];
}

#else

#if defined(TARGET_OS_IPHONE)
- (void) loginWithFacebook:(ItsBetaPlayerLogin)callback parentViewController:(UIViewController*)parentViewController {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(_facebookController == nil) {
            _facebookController = [ItsBetaFacebookIPad new];
        }
    } else {
        if(_facebookController == nil) {
            _facebookController = [ItsBetaFacebookIPhone new];
        }
    }
#else
- (void) loginWithFacebook:(ItsBetaPlayerLogin)callback parentViewController:(NSViewController*)parentViewController {
#endif
    if(_facebookController != nil) {
#if __has_feature(objc_arc)
        __weak id safeSelf = self;
#else
        id safeSelf = self;
#endif
        [_facebookController setParentController:parentViewController];
        [_facebookController setSuccessCallback:^(NSString* accessToken, NSDictionary< ItsBetaGraphUser >* user) {
            [safeSelf loginWithFacebookId:[user id] facebookToken:accessToken callback:callback];
        }];
        [_facebookController setFailureCallback:^(NSError* error) {
            callback(error);
        }];
        [_facebookController request];
    }
}

- (void) logoutWithFacebook:(ItsBetaPlayerLogout)callback {
    NSHTTPCookieStorage* storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    if(storage != nil) {
        for(NSHTTPCookie* cookie in [storage cookies]) {
            if([[cookie domain] rangeOfString:@"facebook"].length > 0) {
                [storage deleteCookie:cookie];
            }
        }
        // [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NS_SAFE_RELEASE(_Id);
    NS_SAFE_RELEASE(_facebookId);
    
    if(callback != nil) {
        callback(nil);
    }
}

#endif

@end

/*--------------------------------------------------*/