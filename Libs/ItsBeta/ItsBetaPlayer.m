/*--------------------------------------------------*/

#import "ItsBetaPlayer.h"
#import "ItsBetaFastCache.h"
#import "ItsBetaRest.h"
#import "ItsBetaQueue.h"
#import "ItsBetaApi.h"
#import "ItsBeta.h"

/*--------------------------------------------------*/

#define ITSBETA_PLAYER_OBJECT_DEFAULT_PAGE_SIZE     100

/*--------------------------------------------------*/

@interface ItsBetaPlayer () {
    NSDate* _lastUpdateObjects;
    
#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)
#else
    ItsBetaFacebook* _facebookController;
#endif
}

#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)

- (void) loginWithFacebookOfficialSDK:(ItsBetaPlayerLogin)callback;
- (void) logoutWithFacebookOfficialSDK:(ItsBetaPlayerLogout)callback;

#else

#if defined(TARGET_OS_IPHONE)
- (void) loginFacebookWithViewController:(UIViewController*)viewController callback:(ItsBetaPlayerLogin)callback;
#else
- (void) loginFacebookWithViewController:(NSViewController*)viewController callback:(ItsBetaPlayerLogin)callback;
#endif
- (void) logoutWithFacebook:(ItsBetaPlayerLogout)callback;

#endif

@end

/*--------------------------------------------------*/

@implementation ItsBetaPlayer

- (void) setType:(ItsBetaPlayerType)type {
    if(_type != type) {
        [self logout:nil];
        
        _type = type;
    }
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
        _graphUser = NS_SAFE_RETAIN([coder decodeObjectForKey:@"facebook_graph_user"]);
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
    NS_SAFE_RELEASE(_graphUser);
    
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
    [coder encodeObject:_graphUser forKey:@"facebook_graph_user"];
}

- (BOOL) synchronizeWithProject:(ItsBetaProject*)project {
    if([ItsBeta applicationAccessToken] == nil) {
        // ERROR
        return NO;
    }
    if(_Id != nil) {
        __block NSUInteger countObjects = 0;
        NSDate* lastUpdateObjects = [NSDate date];
        [ItsBetaApi requestServiceURL:[ItsBeta applicationServiceURL]
                          accessToken:[ItsBeta applicationAccessToken]
                           lastUpdate:_lastUpdateObjects
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
                                   lastUpdate:_lastUpdateObjects
                                       player:self
                                      project:project
                                         page:page + 1
                                      prePage:ITSBETA_PLAYER_OBJECT_DEFAULT_PAGE_SIZE
                                      objects:^(ItsBetaObjectCollection* collection, NSError *error) {
                                          [_objects setObjects:collection];
                                      }];
            }
        }
        NS_SAFE_SETTER(_lastUpdateObjects, lastUpdateObjects);
    }
    return YES;
}

- (BOOL) isLogined {
    return ((_facebookId != nil) && (_facebookToken != nil));
}

#if defined(TARGET_OS_IPHONE)
- (void) loginWithViewController:(UIViewController*)viewController callback:(ItsBetaPlayerLogin)callback {
#else
- (void) loginWithViewController:(NSViewController*)viewController callback:(ItsBetaPlayerLogin)callback {
#endif
    [[NSNotificationCenter defaultCenter] postNotificationName:ItsBetaWillPlayerLogin object:self];
    switch(_type) {
        case ItsBetaPlayerTypeFacebook:
#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)
            [self loginWithFacebookOfficialSDK:callback];
#else
            [self loginFacebookWithViewController:viewController callback:callback];
#endif
        break;
        default:
            [[NSNotificationCenter defaultCenter] postNotificationName:ItsBetaDidPlayerLogin object:self];
            if(callback != nil) {
                callback(nil);
            }
        break;
    }
}

- (void) loginWithFacebookId:(NSString*)facebookId facebookToken:(NSString*)facebookToken graphUser:(NSDictionary<ItsBetaGraphUser>*)graphUser callback:(ItsBetaPlayerLogin)callback {
    [ItsBetaApi requestServiceURL:[ItsBeta applicationServiceURL]
                      accessToken:[ItsBeta applicationAccessToken]
                       facebookId:facebookId
                         playerId:^(NSString* playerId, NSError* error) {
                             if(_Id != playerId) {
                                 NS_SAFE_SETTER(_Id, playerId);
                             }
                             if(_facebookId != facebookId) {
                                 NS_SAFE_SETTER(_facebookId, facebookId);
                             }
                             if(_facebookToken != facebookToken) {
                                 NS_SAFE_SETTER(_facebookToken, facebookToken);
                             }
                             if(_graphUser != graphUser) {
                                 NS_SAFE_SETTER(_graphUser, graphUser);
                             }
                             if((_Id != nil) && (error != nil)) {
                                 callback(error);
                             } else {
                                 callback(nil);
                             }
                             [[NSNotificationCenter defaultCenter] postNotificationName:ItsBetaDidPlayerLogin object:self];
                         }];
}

- (void) logout:(ItsBetaPlayerLogout)callback {
    [[NSNotificationCenter defaultCenter] postNotificationName:ItsBetaWillPlayerLogout object:self];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:ItsBetaDidPlayerLogout object:self];
}

- (void) createAchievementWithProject:(ItsBetaProject*)project objectTemplate:(ItsBetaObjectTemplate*)objectTemplate params:(NSDictionary*)params callback:(ItsBetaPlayerCreateAchievement)callback {
    [ItsBetaApi requestServiceURL:[ItsBeta applicationServiceURL]
                      accessToken:[ItsBeta applicationAccessToken]
                          project:project
                   objectTemplate:objectTemplate
                           params:params
                     activateCode:^(NSString* activateCode, NSError* error) {
                         if(callback != nil) {
                             callback(activateCode, error);
                         }
                     }];
}

- (void) activateAchievementWithProject:(ItsBetaProject*)project activateCode:(NSString*)activateCode callback:(ItsBetaPlayerActivateAchievement)callback {
    [ItsBetaApi requestServiceURL:[ItsBeta applicationServiceURL]
                      accessToken:[ItsBeta applicationAccessToken]
                          project:project
                           player:self
                     activateCode:activateCode
                           object:^(NSString* object_id, NSError* error) {
                               if(error == nil) {
                                   if((_Id == nil) && (_type == ItsBetaPlayerTypeFacebook)) {
                                       [self loginWithFacebookId:_facebookId facebookToken:_facebookToken graphUser:_graphUser callback:^(NSError *error) {
                                           if(callback != nil) {
                                               callback(object_id, error);
                                           }
                                       }];
                                       return;
                                   }
                               }
                               if(callback != nil) {
                                   callback(object_id, error);
                               }
                           }];
}

- (void) giveAchievementWithProject:(ItsBetaProject*)project objectTemplate:(ItsBetaObjectTemplate*)objectTemplate params:(NSDictionary*)params callback:(ItsBetaPlayerGiveAchievement)callback {
    [ItsBetaApi requestServiceURL:[ItsBeta applicationServiceURL]
                      accessToken:[ItsBeta applicationAccessToken]
                          project:project
                   objectTemplate:objectTemplate
                           params:params
                           player:self
                           object:^(NSString* object_id, NSError *error) {
                               if(error == nil) {
                                   if((_Id == nil) && (_type == ItsBetaPlayerTypeFacebook)) {
                                       [self loginWithFacebookId:_facebookId facebookToken:_facebookToken graphUser:_graphUser callback:^(NSError *error) {
                                           if(callback != nil) {
                                               callback(object_id, error);
                                           }
                                       }];
                                       return;
                                   }
                               }
                               if(callback != nil) {
                                   callback(object_id, error);
                               }
                           }];
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
                                                         [safeSelf loginWithFacebookId:[user id] facebookToken:[session accessToken] graphUser:user callback:callback];
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
    NS_SAFE_RELEASE(_facebookToken);
    NS_SAFE_RELEASE(_graphUser);
    NS_SAFE_RELEASE(_lastUpdateObjects);
    [_objects removeAllObjects];
    
    if(callback != nil) {
        callback(nil);
    }
}

#else

#if defined(TARGET_OS_IPHONE)
- (void) loginFacebookWithViewController:(UIViewController*)viewController callback:(ItsBetaPlayerLogin)callback {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if(_facebookController == nil) {
            _facebookController = NS_SAFE_RETAIN([ItsBetaFacebookIPad new]);
        }
    } else {
        if(_facebookController == nil) {
            _facebookController = NS_SAFE_RETAIN([ItsBetaFacebookIPhone new]);
        }
    }
    if(_facebookController != nil) {
        [_facebookController setParentController:viewController];
    }
#else
- (void) loginFacebookWithViewController:(NSViewController*)viewController callback:(ItsBetaPlayerLogin)callback {
#endif
    if(_facebookController != nil) {
#if __has_feature(objc_arc)
        __weak id safeSelf = self;
#else
        id safeSelf = self;
#endif
        [_facebookController setSuccessCallback:^(NSString* accessToken, NSDictionary< ItsBetaGraphUser >* user) {
            [safeSelf loginWithFacebookId:[user id] facebookToken:accessToken graphUser:user callback:callback];
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
            NSRange range = [[cookie domain] rangeOfString:@"facebook"];
            if(range.length > 0) {
                [storage deleteCookie:cookie];
            }
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NS_SAFE_RELEASE(_Id);
    NS_SAFE_RELEASE(_facebookId);
    NS_SAFE_RELEASE(_facebookToken);
    NS_SAFE_RELEASE(_graphUser);
    NS_SAFE_RELEASE(_lastUpdateObjects);
    [_objects removeAllObjects];
    
    if(callback != nil) {
        callback(nil);
    }
}

#endif
    
+ (BOOL) handleOpenURL:(NSURL*)url {
#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)
    return [[FBSession activeSession] handleOpenURL:url];
#else
    return NO;
#endif
}

@end

/*--------------------------------------------------*/