/*--------------------------------------------------*/

#import "ItsBeta.h"
#import "ItsBetaQueue.h"
#import "ItsBetaRest.h"
#import "ItsBetaApi.h"

/*--------------------------------------------------*/

@interface ItsBeta ()

- (void) saveToLocalStorage;

@end

/*--------------------------------------------------*/

@implementation ItsBeta

+ (ItsBeta*) sharedItsBeta {
    if(sharedItsBeta == nil) {
        @synchronized(self) {
            if(sharedItsBeta == nil) {
                NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"itsbeta"];
                if([data isKindOfClass:[NSData class]] == YES) {
                    sharedItsBeta = NS_SAFE_RETAIN([NSKeyedUnarchiver unarchiveObjectWithData:data]);
                } else {
                    sharedItsBeta = [[self alloc] init];
                } 
            }
        }
    }
    return sharedItsBeta;
}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        _application = NS_SAFE_RETAIN([coder decodeObjectForKey:@"application"]);
        _player = NS_SAFE_RETAIN([coder decodeObjectForKey:@"player"]);
    }
    return self;
}

- (id) init {
    self = [super init];
    if(self != nil) {
        _application = NS_SAFE_RETAIN([ItsBetaApplication application]);
        _player = NS_SAFE_RETAIN([ItsBetaPlayer playerWithType:ItsBetaPlayerTypeUnknown]);
    }
    return self;
}

- (void) dealloc {
    NS_SAFE_RELEASE(_application);
    NS_SAFE_RELEASE(_player);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:_application forKey:@"application"];
    [coder encodeObject:_player forKey:@"player"];
}

- (void) saveToLocalStorage {
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
    if([data isKindOfClass:[NSData class]] == YES) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"itsbeta"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void) setApplicationServiceURL:(NSString*)serviceURL {
    [[[ItsBeta sharedItsBeta] application] setServiceURL:serviceURL];
}

+ (NSString*) applicationServiceURL {
    return [[[ItsBeta sharedItsBeta] application] serviceURL];
}

+ (void) setApplicationAccessToken:(NSString*)accessToken {
    [[[ItsBeta sharedItsBeta] application] setAccessToken:accessToken];
}

+ (NSString*) applicationAccessToken {
    return [[[ItsBeta sharedItsBeta] application] accessToken];
}

+ (void) setApplicationProjectWhiteList:(NSArray*)projectWhiteList {
    [[[ItsBeta sharedItsBeta] application] setProjectWhiteList:projectWhiteList];
}

+ (NSArray*) applicationProjectWhiteList {
    return [[[ItsBeta sharedItsBeta] application] projectWhiteList];
}

+ (void) setApplicationProjectBlackList:(NSArray*)projectBlackList {
    [[[ItsBeta sharedItsBeta] application] setProjectBlackList:projectBlackList];
}

+ (NSArray*) applicationProjectBlackList {
    return [[[ItsBeta sharedItsBeta] application] projectBlackList];
}

+ (ItsBetaCategory*) categoryByName:(NSString*)name {
    return [[[[ItsBeta sharedItsBeta] application] categories] categoryAtName:name];
}

+ (ItsBetaProject*) projectById:(NSString*)Id {
    return [[[[ItsBeta sharedItsBeta] application] projects] projectAtId:Id];
}

+ (ItsBetaProject*) projectByName:(NSString*)name {
    return [[[[ItsBeta sharedItsBeta] application] projects] projectAtName:name];
}

+ (ItsBetaObjectType*) objectTypeById:(NSString*)Id byProject:(ItsBetaProject*)project {
    return [[project objectTypes] objectTypeAtId:Id];
}

+ (ItsBetaObjectType*) objectTypeByName:(NSString*)name byProject:(ItsBetaProject*)project {
    return [[project objectTypes] objectTypeAtName:name];
}

+ (ItsBetaObjectTemplate*) objectTemplateById:(NSString*)Id byProject:(ItsBetaProject*)project {
    return [[project objectTemplates] objectTemplateAtId:Id];
}

+ (ItsBetaObjectTemplate*) objectTemplateByName:(NSString*)name byProject:(ItsBetaProject*)project {
    return [[project objectTemplates] objectTemplateAtName:name];
}

+ (ItsBetaObject*) objectById:(NSString*)Id {
    return [[[[ItsBeta sharedItsBeta] player] objects] objectAtId:Id];
}

+ (ItsBetaObject*) objectById:(NSString*)Id byPlayer:(ItsBetaPlayer*)player {
    return [[player objects] objectAtId:Id];
}

+ (ItsBetaObjectCollection*) objectsWithObjectTemplate:(ItsBetaObjectTemplate*)objectTemplate {
    return [[[[ItsBeta sharedItsBeta] player] objects] objectsWithObjectTemplate:objectTemplate];
}

+ (ItsBetaObjectCollection*) objectsWithObjectTemplate:(ItsBetaObjectTemplate*)objectTemplate byPlayer:(ItsBetaPlayer*)player {
    return [[player objects] objectsWithObjectTemplate:objectTemplate];
}

+ (BOOL) playerLogined {
    return [[[ItsBeta sharedItsBeta] player] isLogined];
}

#if defined(TARGET_OS_IPHONE)
+ (void) playerLoginFacebookWithViewController:(UIViewController*)viewController callback:(ItsBetaLogin)callback {
#else
+ (void) playerLoginFacebookWithViewController:(NSViewController*)viewController callback:(ItsBetaLogin)callback {
#endif
    ItsBeta* itsbeta = [ItsBeta sharedItsBeta];
    ItsBetaPlayer* player = [itsbeta player];
    [player setType:ItsBetaPlayerTypeFacebook];
    [player loginWithViewController:viewController callback:^(NSError* error) {
        if(callback != nil) {
            callback(player, error);
        }
        [ItsBetaQueue runASync:^{
            [itsbeta saveToLocalStorage];
        }];
    }];
}

+ (void) playerLogout:(ItsBetaLogout)callback {
    ItsBeta* itsbeta = [ItsBeta sharedItsBeta];
    ItsBetaPlayer* player = [itsbeta player];
    [player logout:^(NSError* error) {
        if(callback != nil) {
            callback(player, error);
        }
        [ItsBetaQueue runASync:^{
            [itsbeta saveToLocalStorage];
        }];
    }];
}
    
+ (void) playerCreateAchievementWithProject:(ItsBetaProject*)project objectTemplate:(ItsBetaObjectTemplate*)objectTemplate params:(NSDictionary*)params callback:(ItsBetaCreateAchievement)callback {
    ItsBetaPlayer* player = [[ItsBeta sharedItsBeta] player];
    [player createAchievementWithProject:project
                          objectTemplate:objectTemplate
                                  params:params
                                callback:^(NSString* activateCode, NSError* error) {
                                    if(callback != nil) {
                                        callback(player, activateCode, error);
                                    }
                                }];
}

+ (void) playerActivateAchievementWithProject:(ItsBetaProject*)project activateCode:(NSString*)activateCode callback:(ItsBetaActivateAchievement)callback {
    ItsBetaPlayer* player = [[ItsBeta sharedItsBeta] player];
    [player activateAchievementWithProject:project
                              activateCode:activateCode
                                  callback:^(NSString* object_id, NSError* error) {
                                      if(callback != nil) {
                                          callback(player, object_id, error);
                                      }
                                  }];
}

+ (void) playerGiveAchievementWithProject:(ItsBetaProject*)project objectTemplate:(ItsBetaObjectTemplate*)objectTemplate params:(NSDictionary*)params callback:(ItsBetaGiveAchievement)callback {
    ItsBetaPlayer* player = [[ItsBeta sharedItsBeta] player];
    [player giveAchievementWithProject:project
                        objectTemplate:objectTemplate
                                params:params
                              callback:^(NSString* object_id, NSError* error) {
                                  if(callback != nil) {
                                      callback(player, object_id, error);
                                  }
                              }];
}

+ (void) objectUrlForId:(NSString*)Id type:(NSString*)type params:(NSDictionary*)params callback:(ItsBetaObjectUrl)callback
{
    [ItsBetaApi requestServiceURL:[ItsBeta applicationServiceURL]
                      accessToken:[ItsBeta applicationAccessToken]
                         objectId:Id
                     objectIdType:type
                           params:params
                           object:^(NSString* object_url, NSError* error){
                               if(callback != nil) {
                                   callback(object_url, error);
                               }
                           }];
}

+ (void) synchronizeApplication {
    ItsBeta* itsbeta = [ItsBeta sharedItsBeta];
    [ItsBetaQueue runASync:^{
        [ItsBetaQueue runMainSync:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ItsBetaWillApplicationSynchronize object:self];
            NSLog(@"[ItsBeta] Will synchronize application in %@", [NSDate date]);
        }];
        if([[itsbeta application] synchronizeSync] == YES) {
            [itsbeta saveToLocalStorage];
        }
        [ItsBetaQueue runMainSync:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ItsBetaDidApplicationSynchronize object:self];
            NSLog(@"[ItsBeta] Did synchronize application in %@", [NSDate date]);
        }];
    }];
}

+ (void) synchronizePlayerWithProject:(ItsBetaProject*)project {
    ItsBeta* itsbeta = [ItsBeta sharedItsBeta];
    [ItsBetaQueue runASync:^{
        [ItsBetaQueue runMainSync:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ItsBetaWillPlayerSynchronize object:self];
            NSLog(@"[ItsBeta] Will synchronize player in %@", [NSDate date]);
        }];
        if([[itsbeta player] synchronizeWithProject:project] == YES) {
            [itsbeta saveToLocalStorage];
        }
        [ItsBetaQueue runMainSync:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ItsBetaDidPlayerSynchronize object:self];
            NSLog(@"[ItsBeta] Did synchronize player in %@", [NSDate date]);
        }];
    }];
}
    
+ (BOOL) handleOpenURL:(NSURL*)url {
    return [ItsBetaPlayer handleOpenURL:url];
}
    
@end

/*--------------------------------------------------*/

ItsBeta* sharedItsBeta = nil;

/*--------------------------------------------------*/