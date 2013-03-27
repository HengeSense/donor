/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)
#   import <FacebookSDK/FacebookSDK.h>
#endif

/*--------------------------------------------------*/

@interface ItsBetaPlayer () {
    dispatch_queue_t _queue;
    NSMutableArray* _objects;
}

- (void) synchronizeObjects;

#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)

- (void) loginWithFacebook:(ItsBetaCallbackLogin)callback;
- (void) logoutWithFacebook:(ItsBetaCallbackLogout)callback;
+ (BOOL) handleOpenURL:(NSURL*)url;

#endif

@end

/*--------------------------------------------------*/

@implementation ItsBetaPlayer

+ (ItsBetaPlayer*) userWithType:(ItsBetaPlayerType)type {
    return NS_SAFE_AUTORELEASE([[self alloc] initWithType:type]);
}

- (id) initWithType:(ItsBetaPlayerType)type {
    self = [super init];
    if(self != nil) {
        _queue = dispatch_queue_create(ItsBetaDispatchQueue, nil);
        
        _type = type;
        
        _objects = NS_SAFE_RETAIN([NSMutableArray array]);
    }
    return self;
}

- (void) dealloc {
    NS_SAFE_RELEASE(_Id);
    NS_SAFE_RELEASE(_facebookId);
    
    dispatch_release(_queue);
    
    NS_SAFE_RELEASE(_objects);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) synchronize {
    if(_Id == nil) {
        return;
    }
}

- (void) synchronizeObjects {
    dispatch_sync(_queue, ^{
        [_objects removeAllObjects];
    });
    for(ItsBetaTemplate* template in [[ItsBeta sharedItsBeta] templates]) {
        [ItsBeta itsBetaObjectByPlayer:self
                            byTemplate:template
                              callback:^(NSArray* objects, NSError* error) {
                                  dispatch_sync(_queue, ^{
                                      [_objects addObjectsFromArray:objects];
                                  });
                              }];
    }
}

- (BOOL) isLogin {
    return (_Id != nil);
}

- (void) login:(ItsBetaCallbackLogin)callback {
    switch(_type) {
        case ItsBetaPlayerTypeFacebook:
#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)
            [self loginWithFacebook:callback];
#endif
        break;
        default:
            if(callback != nil) {
                callback(self, nil);
            }
        break;
    }
}

- (void) loginWithFacebookId:(NSString*)facebookId callback:(ItsBetaCallbackLogin)callback {
    [ItsBeta itsBetaPlayerIdByFacebookId:facebookId
                                callback:^(NSString *playerId, NSError *error) {
                                    if(_Id != playerId) {
                                        NS_SAFE_RELEASE(_Id);
                                        _Id = NS_SAFE_RETAIN(playerId);
                                    }
                                    if(_facebookId != playerId) {
                                        NS_SAFE_RELEASE(_facebookId);
                                        _facebookId = NS_SAFE_RETAIN(facebookId);
                                    }
                                    callback(self, error);
                                }];
}

- (void) logout:(ItsBetaCallbackLogout)callback {
    switch(_type) {
        case ItsBetaPlayerTypeFacebook:
#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)
            [self logoutWithFacebook:callback];
#endif
        break;
        default:
            if(callback != nil) {
                callback(self, nil);
            }
        break;
    }
}

#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)

- (void) loginWithFacebook:(ItsBetaCallbackLogin)callback {
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
                                                         callback(self, [[error userInfo] objectForKey:@"com.facebook.sdk:ErrorInnerErrorKey"]);
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
                                             callback(self, error);
                                         }
                                     }];
}

- (void) logoutWithFacebook:(ItsBetaCallbackLogout)callback {
    if([FBSession activeSession] != nil) {
        [[FBSession activeSession] closeAndClearTokenInformation];
    }
    NS_SAFE_RELEASE(_Id);
    NS_SAFE_RELEASE(_facebookId);
    if(callback != nil) {
        callback(self, nil);
    }
}

+ (BOOL) handleOpenURL:(NSURL*)url {
    return [[FBSession activeSession] handleOpenURL:url];
}

#endif

+ (NSString*) stringWithPlayerType:(ItsBetaPlayerType)playerType {
    switch(playerType) {
        case ItsBetaPlayerTypeFacebook: return @"fb";
    }
    return @"";
}

@end

/*--------------------------------------------------*/