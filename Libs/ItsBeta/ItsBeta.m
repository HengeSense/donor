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

+ (void) setApplicationDelegate:(id< ItsBetaApplicationDelegate >)delegate {
    [[[ItsBeta sharedItsBeta] application] setDelegate:delegate];
}

+ (id< ItsBetaApplicationDelegate >) applicationDelegate {
    return [[[ItsBeta sharedItsBeta] application] delegate];
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

+ (ItsBetaObjectTemplate*) objectTemplateById:(NSString*)Id byProject:(ItsBetaProject*)project {
    return [[project objectTemplates] objectTemplateAtId:Id];
}

+ (ItsBetaObject*) objectById:(NSString*)Id byProject:(ItsBetaProject*)project byPlayer:(ItsBetaPlayer*)player {
    return [[player objects] objectAtId:Id];
}

+ (void) synchronizeApplication {
    NSLog(@"[ItsBeta::synchronizeApplication] %@", [NSDate date]);
    [ItsBetaQueue runASync:^{
        if([[[ItsBeta sharedItsBeta] application] synchronizeSync] == YES) {
            [[ItsBeta sharedItsBeta] saveToLocalStorage];
        }
        NSLog(@"[ItsBeta::synchronizeApplication] %@", [NSDate date]);
    }];
}

- (void) synchronizePlayerWithProject:(ItsBetaProject*)project {
    NSLog(@"[ItsBeta::synchronizePlayerWithProject] %@", [NSDate date]);
    [ItsBetaQueue runASync:^{
        if([[[ItsBeta sharedItsBeta] player] synchronizeWithProject:project] == YES) {
            [[ItsBeta sharedItsBeta] saveToLocalStorage];
        }
        NSLog(@"[ItsBeta::synchronizePlayerWithProject] %@", [NSDate date]);
    }];
}

@end

/*--------------------------------------------------*/

ItsBeta* sharedItsBeta = nil;

/*--------------------------------------------------*/