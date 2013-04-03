/*--------------------------------------------------*/

#import "ItsBeta.h"
#import "ItsBetaQueue.h"
#import "ItsBetaRest.h"

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
                    sharedItsBeta = [NSKeyedUnarchiver unarchiveObjectWithData:data];
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

+ (ItsBetaObject*) objectById:(NSString*)Id byPlayer:(ItsBetaPlayer*)player {
    return [[player objects] objectAtId:Id];
}

+ (ItsBetaObjectCollection*) objectsWithObjectTemplate:(ItsBetaObjectTemplate*)objectTemplate byPlayer:(ItsBetaPlayer*)player {
    return [[player objects] objectsWithObjectTemplate:objectTemplate];
}

+ (BOOL) playerLogined {
    return [[[ItsBeta sharedItsBeta] player] isLogined];
}

#if defined(TARGET_OS_IPHONE)
+ (void) facebookLoginWithViewController:(UIViewController*)viewController callback:(ItsBetaLogin)callback {
#else
+ (void) facebookLoginWithViewController:(NSViewController*)viewController callback:(ItsBetaLogin)callback {
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

+ (void) synchronizeApplication {
    ItsBeta* itsbeta = [ItsBeta sharedItsBeta];
    [ItsBetaQueue runASync:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ItsBetaWillApplicationSynchronize object:self];
        NSLog(@"[ItsBeta::synchronizeApplication] %@", [NSDate date]);
        
        if([[itsbeta application] synchronizeSync] == YES) {
            [itsbeta saveToLocalStorage];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ItsBetaDidApplicationSynchronize object:self];
        NSLog(@"[ItsBeta::synchronizeApplication] %@", [NSDate date]);
    }];
}

+ (void) synchronizePlayerWithProject:(ItsBetaProject*)project {
    ItsBeta* itsbeta = [ItsBeta sharedItsBeta];
    [ItsBetaQueue runASync:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ItsBetaWillPlayerSynchronize object:self];
        NSLog(@"[ItsBeta::synchronizePlayerWithProject] %@", [NSDate date]);
        
        if([[itsbeta player] synchronizeWithProject:project] == YES) {
            [itsbeta saveToLocalStorage];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ItsBetaDidPlayerSynchronize object:self];
        NSLog(@"[ItsBeta::synchronizePlayerWithProject] %@", [NSDate date]);
    }];
}
    
+ (BOOL) handleOpenURL:(NSURL*)url {
    return [ItsBetaPlayer handleOpenURL:url];
}
    
@end

/*--------------------------------------------------*/

ItsBeta* sharedItsBeta = nil;

/*--------------------------------------------------*/