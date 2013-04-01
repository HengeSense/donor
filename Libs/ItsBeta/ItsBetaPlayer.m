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
#endif

/*--------------------------------------------------*/

@interface ItsBetaPlayer () {
    ItsBetaObjectCollection* _objects;
}

#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)

- (void) loginWithFacebook:(ItsBetaCallbackLogin)callback;
- (void) logoutWithFacebook:(ItsBetaCallbackLogout)callback;
+ (BOOL) handleOpenURL:(NSURL*)url;

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
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) encodeWithCoder:(NSCoder*)coder {
    [coder encodeInt:_type forKey:@"type"];
    [coder encodeObject:_objects forKey:@"objects"];
    [coder encodeObject:_Id forKey:@"player_id"];
    [coder encodeObject:_facebookId forKey:@"facebook_id"];
    [coder encodeObject:_facebookToken forKey:@"facebook_token"];
}

- (void) synchronizeWithProject:(ItsBetaProject*)project {
    [ItsBetaQueue runSync:^{
        for(ItsBetaObjectTemplate* template in [project objectTemplates]) {
            [ItsBetaApi requestServiceURL:[ItsBeta applicationServiceURL]
                              accessToken:[ItsBeta applicationAccessToken]
                               lastUpdate:nil
                                   player:self
                                  project:project
                           objectTemplate:template
                                  objects:^(ItsBetaObjectCollection* collection, NSError *error) {
                                      [_objects setObjects:collection];
                                  }];
        }
    }];
}

- (BOOL) isLogin {
    return (_Id != nil);
}

- (void) login:(ItsBetaPlayerLogin)callback {
    switch(_type) {
        case ItsBetaPlayerTypeFacebook:
#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)
            [self loginWithFacebook:callback];
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

- (void) loginWithFacebook:(ItsBetaPlayerLogin)callback {
    [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_stream", @"publish_actions", nil]
                                       defaultAudience:FBSessionDefaultAudienceOnlyMe
                                          allowLoginUI:YES
                                     completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                         switch(state) {
                                             case FBSessionStateOpen:
                                             case FBSessionStateOpenTokenExtended:
                                                 [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary< FBGraphUser > *user, NSError *error) {
                                                     if(error == nil) {
                                                         [self loginWithFacebookId:[user id] callback:callback];
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

- (void) logoutWithFacebook:(ItsBetaPlayerLogout)callback {
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

#endif

@end

/*--------------------------------------------------*/