/*--------------------------------------------------*/

#import "ItsBetaApplication.h"
#import "ItsBetaFastCache.h"
#import "ItsBetaRest.h"
#import "ItsBetaQueue.h"
#import "ItsBetaApi.h"
#import "ItsBeta.h"

/*--------------------------------------------------*/

@interface ItsBetaApplication () {
    NSDate* _lastUpdateCategories;
    NSDate* _lastUpdateProjects;
}

- (void) synchronize;

@end

/*--------------------------------------------------*/

@implementation ItsBetaApplication

+ (ItsBetaApplication*) application {
    return NS_SAFE_AUTORELEASE([[self alloc] init]);
}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        _serviceURL = NS_SAFE_RETAIN([coder decodeObjectForKey:@"service_url"]);
        _accessToken = NS_SAFE_RETAIN([coder decodeObjectForKey:@"access_token"]);
        _lastUpdateCategories = NS_SAFE_RETAIN([coder decodeObjectForKey:@"last_update_categories"]);
        _categories = NS_SAFE_RETAIN([coder decodeObjectForKey:@"categories"]);
        _lastUpdateProjects = NS_SAFE_RETAIN([coder decodeObjectForKey:@"last_update_projects"]);
        _projects = NS_SAFE_RETAIN([coder decodeObjectForKey:@"projects"]);
    }
    return self;
}

- (id) init {
    self = [super init];
    if(self != nil) {
        _serviceURL = @"http://www.itsbeta.com/s";
        _categories = NS_SAFE_RETAIN([ItsBetaCategoryCollection collection]);
        _projects = NS_SAFE_RETAIN([ItsBetaProjectCollection collection]);
    }
    return self;
}

- (void) dealloc {
    NS_SAFE_RELEASE(_accessToken);
    NS_SAFE_RELEASE(_serviceURL);
    NS_SAFE_RELEASE(_categories);
    NS_SAFE_RELEASE(_projects);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:_serviceURL forKey:@"service_url"];
    [coder encodeObject:_accessToken forKey:@"access_token"];
    [coder encodeObject:_lastUpdateCategories forKey:@"last_update_categories"];
    [coder encodeObject:_categories forKey:@"categories"];
    [coder encodeObject:_lastUpdateProjects forKey:@"last_update_projects"];
    [coder encodeObject:_projects forKey:@"projects"];
}

- (BOOL) synchronizeASync {
    if(_accessToken == nil) {
        // ERROR
        return NO;
    }
    [ItsBetaQueue runASync:^{
        [self synchronize];
    }];
    return YES;
}

- (BOOL) synchronizeSync {
    if(_accessToken == nil) {
        // ERROR
        return NO;
    }
    [self synchronize];
    return YES;
}

- (void) synchronize {
    NSDate* lastUpdateCategories = [NSDate date];
    [ItsBetaApi requestServiceURL:[ItsBeta applicationServiceURL]
                      accessToken:[ItsBeta applicationAccessToken]
                       lastUpdate:_lastUpdateCategories
                           locale:[[[ItsBeta sharedItsBeta] application] locale]
                       categories:^(ItsBetaCategoryCollection* collection, NSError* error) {
                           [_categories setCategories:collection];
                       }];
    NS_SAFE_SETTER(_lastUpdateCategories, lastUpdateCategories);
    
    NSDate* lastUpdateProjects = [NSDate date];
    [ItsBetaApi requestServiceURL:[ItsBeta applicationServiceURL]
                      accessToken:[ItsBeta applicationAccessToken]
                       lastUpdate:_lastUpdateProjects
                         projects:^(ItsBetaProjectCollection* collection, NSError* error) {
                             [_projects setProjects:collection];
                         }];
    NS_SAFE_SETTER(_lastUpdateProjects, lastUpdateProjects);
    
    for(ItsBetaProject* project in _projects) {
        NSString* projectName = [project name];
        
        BOOL insideProjectBlackList = NO;
        if([_projectBlackList count] > 0) {
            for(NSString* name in _projectBlackList) {
                if([projectName compare:name options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                    insideProjectBlackList = YES;
                    break;
                }
            }
        }
        BOOL insideProjectWhiteList = NO;
        if([_projectWhiteList count] > 0) {
            for(NSString* name in _projectWhiteList) {
                if([projectName compare:name options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                    insideProjectWhiteList = YES;
                }
            }
        } else {
            insideProjectWhiteList = YES;
        }
        if((insideProjectBlackList == NO) && (insideProjectWhiteList == YES)) {
            [project synchronizeSync];
        }
    }
}

@end

/*--------------------------------------------------*/