/*--------------------------------------------------*/

#import "ItsBeta.h"
#import "ItsBetaRestAPI.h"

/*--------------------------------------------------*/

char* const ItsBetaDispatchQueue = "itsbeta";
NSString* const ItsBetaErrorDomain = @"ItsBetaErrorDomain";

/*--------------------------------------------------*/

@interface ItsBeta () {
    dispatch_queue_t _queue;
    NSMutableArray* _categories;
    NSMutableArray* _projects;
    NSMutableArray* _types;
    NSMutableArray* _templates;
}

- (void) synchronizeCategories;
- (void) synchronizeProjects;
- (void) synchronizeTypes;
- (void) synchronizeTemplates;
- (void) synchronizeObjects;

- (NSError*) errorWithDictionary:(NSDictionary*)dictionary;

- (void) requestCategories:(ItsBetaCallbackCollection)callback;
- (void) requestProjectsByCategory:(ItsBetaCategory*)byCategory callback:(ItsBetaCallbackCollection)callback;
- (void) requestTypesByProject:(ItsBetaProject*)byProject callback:(ItsBetaCallbackCollection)callback;
- (void) requestTypesByProject:(ItsBetaProject*)byProject byParent:(ItsBetaType*)byParent callback:(ItsBetaCallbackCollection)callback;
- (void) requestTemplatesByType:(ItsBetaType*)byType callback:(ItsBetaCallbackCollection)callback;
- (void) requestTemplatesByType:(ItsBetaType*)byType byProject:(ItsBetaProject*)byProject callback:(ItsBetaCallbackCollection)callback;
- (void) requestObjectByPlayer:(ItsBetaPlayer*)byPlayer byTemplate:(ItsBetaTemplate*)byTemplate callback:(ItsBetaCallbackCollection)callback;

- (void) requestPlayerIdByFacebookId:(NSString*)byUserId callback:(ItsBetaCallbackPlayerIdWithUserId)callback;
- (void) requestPlayerIdByUserType:(ItsBetaPlayerType)userType byUserId:(NSString*)byUserId callback:(ItsBetaCallbackPlayerIdWithUserId)callback;

@end

/*--------------------------------------------------*/

@implementation ItsBeta

- (NSArray*) categories {
    __block NSArray* result = nil;
    dispatch_sync(_queue, ^{
        result = _categories;
    });
    return result;
}

- (NSArray*) projects {
    __block NSArray* result = nil;
    dispatch_sync(_queue, ^{
        result = _projects;
    });
    return result;
}

- (NSArray*) types {
    __block NSArray* result = nil;
    dispatch_sync(_queue, ^{
        result = _types;
    });
    return result;
}

- (NSArray*) templates {
    __block NSArray* result = nil;
    dispatch_sync(_queue, ^{
        result = _templates;
    });
    return result;
}

+ (ItsBeta*) sharedItsBeta {
    if(sharedItsBeta == nil) {
        @synchronized(self) {
            if(sharedItsBeta == nil) {
                sharedItsBeta = [[self alloc] init];
            }
        }
    }
    return sharedItsBeta;
}

- (id) init {
    self = [super init];
    if(self != nil) {
        _queue = dispatch_queue_create(ItsBetaDispatchQueue, nil);
        
        _serviceURL = @"http://www.itsbeta.com/s/";
        
        _categories = NS_SAFE_RETAIN([NSMutableArray array]);
        _projects = NS_SAFE_RETAIN([NSMutableArray array]);
        _types = NS_SAFE_RETAIN([NSMutableArray array]);
        _templates = NS_SAFE_RETAIN([NSMutableArray array]);
    }
    return self;
}

- (void) dealloc {
    NS_SAFE_RELEASE(_accessToken);
    NS_SAFE_RELEASE(_serviceURL);
    
    dispatch_release(_queue);
    
    NS_SAFE_RELEASE(_categories);
    NS_SAFE_RELEASE(_projects);
    NS_SAFE_RELEASE(_types);
    NS_SAFE_RELEASE(_templates);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) loginWithType:(ItsBetaPlayerType)type callback:(ItsBetaCallbackLogin)callback {
}

- (void) logout:(ItsBetaCallbackLogout)callback {
}

- (void) synchronize {
    if(_accessToken == nil) {
        return;
    }
    [self synchronizeCategories];
}

- (void) synchronizeCategories {
    dispatch_sync(_queue, ^{
        [_categories removeAllObjects];
    });
    [self requestCategories:^(NSArray* categories, NSError* error) {
        dispatch_sync(_queue, ^{
            [_categories addObjectsFromArray:categories];
        });
        [self synchronizeProjects];
    }];
}

- (void) synchronizeProjects {
    dispatch_sync(_queue, ^{
        [_projects removeAllObjects];
    });
    for(ItsBetaCategory* category in _categories) {
        [self requestProjectsByCategory:category
                               callback:^(NSArray* projects, NSError* error) {
                                   dispatch_sync(_queue, ^{
                                       [_projects addObjectsFromArray:projects];
                                   });
                                   [self synchronizeTypes];
                               }];
    }
}

- (void) synchronizeTypes {
    dispatch_sync(_queue, ^{
        [_types removeAllObjects];
    });
    for(ItsBetaProject* project in _projects) {
        [self requestTypesByProject:project
                           callback:^(NSArray* types, NSError* error) {
                               dispatch_sync(_queue, ^{
                                   [_types addObjectsFromArray:types];
                               });
                               [self synchronizeTemplates];
                           }];
    }
}

- (void) synchronizeTemplates {
    dispatch_sync(_queue, ^{
        [_templates removeAllObjects];
    });
    for(ItsBetaType* type in _types) {
        [self requestTemplatesByType:type
                            callback:^(NSArray* templates, NSError* error) {
                                dispatch_sync(_queue, ^{
                                    [_templates addObjectsFromArray:templates];
                                });
                                [self synchronizeObjects];
                            }];
    }
}

- (void) synchronizeObjects {
    if(_currentPlayer == nil) {
        return;
    }
    [_currentPlayer synchronize];
}

- (NSError*) errorWithDictionary:(NSDictionary*)dictionary {
    NSString* status = [dictionary objectForKey:@"status"];
    NSString* description = [dictionary objectForKey:@"description"];
    NSString* additionalInfo = [dictionary objectForKey:@"additional_info"];
    return [NSError errorWithDomain:ItsBetaErrorDomain
                               code:ItsBetaErrorResponse
                           userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ - %@ '%@'", status, description, additionalInfo] forKey:NSLocalizedDescriptionKey]];
}

+ (void) itsBetaCategories:(ItsBetaCallbackCollection)callback {
    [[ItsBeta sharedItsBeta] requestCategories:callback];
}

- (void) requestCategories:(ItsBetaCallbackCollection)callback {
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    if(_accessToken != nil) {
        [query setObject:_accessToken forKey:@"access_token"];
    }
    if(_locale != nil) {
        [query setObject:_locale forKey:@"locale"];
    }
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:[NSString stringWithFormat:@"%@/info/categories.json", _serviceURL]
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil) {
                                            if([responseJSON isKindOfClass:[NSArray class]] == YES) {
                                                NSMutableArray* result = [NSMutableArray array];
                                                for(NSDictionary* item in responseJSON) {
                                                    [result addObject:[ItsBetaCategory categoryWithDictionary:item]];
                                                }
                                                callback(result, nil);
                                            } else if([responseJSON isKindOfClass:[NSDictionary class]] == YES) {
                                                responseError = [self errorWithDictionary:responseJSON];
                                            }
                                        }
                                        if(responseError != nil) {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

+ (void) itsBetaProjectsByCategory:(ItsBetaCategory*)byCategory callback:(ItsBetaCallbackCollection)callback {
    [[ItsBeta sharedItsBeta] requestProjectsByCategory:byCategory callback:callback];
}

- (void) requestProjectsByCategory:(ItsBetaCategory*)byCategory callback:(ItsBetaCallbackCollection)callback {
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    if(_accessToken != nil) {
        [query setObject:_accessToken forKey:@"access_token"];
    }
    if(byCategory != nil) {
        [query setObject:[byCategory name] forKey:@"category_name"];
    }
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:[NSString stringWithFormat:@"%@/info/projects.json", _serviceURL]
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil) {
                                            if([responseJSON isKindOfClass:[NSArray class]] == YES) {
                                                NSMutableArray* result = [NSMutableArray array];
                                                for(NSDictionary* item in responseJSON) {
                                                    [result addObject:[ItsBetaProject projectWithDictionary:item]];
                                                }
                                                callback(result, nil);
                                            } else if([responseJSON isKindOfClass:[NSDictionary class]] == YES) {
                                                responseError = [self errorWithDictionary:responseJSON];
                                            }
                                        }
                                        if(responseError != nil) {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

+ (void) itsBetaTypesByProject:(ItsBetaProject*)byProject callback:(ItsBetaCallbackCollection)callback {
    [[ItsBeta sharedItsBeta] requestTypesByProject:byProject callback:callback];
}

- (void) requestTypesByProject:(ItsBetaProject*)byProject callback:(ItsBetaCallbackCollection)callback {
    [self requestTypesByProject:byProject byParent:nil callback:callback];
}

+ (void) itsBetaTypesByProject:(ItsBetaProject*)byProject byParent:(ItsBetaType*)byParent callback:(ItsBetaCallbackCollection)callback {
    [[ItsBeta sharedItsBeta] requestTypesByProject:byProject byParent:byParent callback:callback];
}

- (void) requestTypesByProject:(ItsBetaProject*)byProject byParent:(ItsBetaType*)byParent callback:(ItsBetaCallbackCollection)callback {
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    if(_accessToken != nil) {
        [query setObject:_accessToken forKey:@"access_token"];
    }
    if(byProject != nil) {
        [query setObject:[byProject Id] forKey:@"project_id"];
    }
    if(byParent != nil) {
        [query setObject:[byParent Id] forKey:@"parent_id"];
    }
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:[NSString stringWithFormat:@"%@/info/objtypes.json", _serviceURL]
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil) {
                                            if([responseJSON isKindOfClass:[NSArray class]] == YES) {
                                                NSMutableArray* result = [NSMutableArray array];
                                                for(NSDictionary* item in responseJSON) {
                                                    [result addObject:[ItsBetaType typeWithDictionary:item]];
                                                }
                                                callback(result, nil);
                                            } else if([responseJSON isKindOfClass:[NSDictionary class]] == YES) {
                                                responseError = [self errorWithDictionary:responseJSON];
                                            }
                                        }
                                        if(responseError != nil) {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

+ (void) itsBetaTemplatesByType:(ItsBetaType*)byType callback:(ItsBetaCallbackCollection)callback {
    [[ItsBeta sharedItsBeta] requestTemplatesByType:byType callback:callback];
}

- (void) requestTemplatesByType:(ItsBetaType*)byType callback:(ItsBetaCallbackCollection)callback {
    [self requestTemplatesByType:byType byProject:nil callback:callback];
}

+ (void) itsBetaTemplatesByType:(ItsBetaType*)byType byProject:(ItsBetaProject*)byProject callback:(ItsBetaCallbackCollection)callback {
    [[ItsBeta sharedItsBeta] requestTemplatesByType:byType byProject:byProject callback:callback];
}

- (void) requestTemplatesByType:(ItsBetaType*)byType byProject:(ItsBetaProject*)byProject callback:(ItsBetaCallbackCollection)callback {
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    if(_accessToken != nil) {
        [query setObject:_accessToken forKey:@"access_token"];
    }
    if(byType != nil) {
        [query setObject:[byType Id] forKey:@"objtype_id"];
    }
    if(byProject != nil) {
        [query setObject:[byProject Id] forKey:@"project_id"];
    }
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:[NSString stringWithFormat:@"%@/info/objtemplates.json", _serviceURL]
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil) {
                                            if([responseJSON isKindOfClass:[NSArray class]] == YES) {
                                                NSMutableArray* result = [NSMutableArray array];
                                                for(NSDictionary* item in responseJSON) {
                                                    [result addObject:[ItsBetaTemplate templateWithDictionary:item]];
                                                }
                                                callback(result, nil);
                                            } else if([responseJSON isKindOfClass:[NSDictionary class]] == YES) {
                                                responseError = [self errorWithDictionary:responseJSON];
                                            }
                                        }
                                        if(responseError != nil) {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

+ (void) itsBetaObjectByPlayer:(ItsBetaPlayer*)byPlayer byTemplate:(ItsBetaTemplate*)byTemplate callback:(ItsBetaCallbackCollection)callback {
    [[ItsBeta sharedItsBeta] requestObjectByPlayer:byPlayer byTemplate:byTemplate callback:callback];
}

- (void) requestObjectByPlayer:(ItsBetaPlayer*)byPlayer byTemplate:(ItsBetaTemplate*)byTemplate callback:(ItsBetaCallbackCollection)callback {
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    if(_accessToken != nil) {
        [query setObject:_accessToken forKey:@"access_token"];
    }
    if(byPlayer != nil) {
        [query setObject:[byPlayer Id] forKey:@"player_id"];
    }
    if(byTemplate != nil) {
        [query setObject:[byTemplate Id] forKey:@"objtemplate_id"];
    }
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:[NSString stringWithFormat:@"%@/info/objs.json", _serviceURL]
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil) {
                                            if([responseJSON isKindOfClass:[NSArray class]] == YES) {
                                                NSMutableArray* result = [NSMutableArray array];
                                                for(NSDictionary* item in responseJSON) {
                                                    [result addObject:[ItsBetaObject objectWithDictionary:item]];
                                                }
                                                callback(result, nil);
                                            } else if([responseJSON isKindOfClass:[NSDictionary class]] == YES) {
                                                responseError = [self errorWithDictionary:responseJSON];
                                            }
                                        }
                                        if(responseError != nil) {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

+ (void) itsBetaPlayerIdByFacebookId:(NSString*)byUserId callback:(ItsBetaCallbackPlayerIdWithUserId)callback {
    [[ItsBeta sharedItsBeta] requestPlayerIdByFacebookId:byUserId callback:callback];
}

- (void) requestPlayerIdByFacebookId:(NSString*)byUserId callback:(ItsBetaCallbackPlayerIdWithUserId)callback {
    [self requestPlayerIdByUserType:ItsBetaPlayerTypeFacebook byUserId:byUserId callback:callback];
}

+ (void) itsBetaPlayerIdByUserType:(ItsBetaPlayerType)userType byUserId:(NSString*)byUserId callback:(ItsBetaCallbackPlayerIdWithUserId)callback {
    [[ItsBeta sharedItsBeta] requestPlayerIdByUserType:userType byUserId:byUserId callback:callback];
}

- (void) requestPlayerIdByUserType:(ItsBetaPlayerType)userType byUserId:(NSString*)byUserId callback:(ItsBetaCallbackPlayerIdWithUserId)callback {
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    if(_accessToken != nil) {
        [query setObject:_accessToken forKey:@"access_token"];
    }
    [query setObject:[ItsBetaPlayer stringWithPlayerType:userType] forKey:@"type"];
    if(byUserId != nil) {
        [query setObject:byUserId forKey:@"id"];
    }
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:[NSString stringWithFormat:@"%@/info/playerid.json", _serviceURL]
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil) {
                                            if([responseJSON isKindOfClass:[NSDictionary class]] == YES) {
                                                NSString* player_id = [responseJSON objectForKey:@"player_id"];
                                                if(player_id != nil) {
                                                    callback([responseJSON objectForKey:@"player_id"], nil);
                                                } else {
                                                    responseError = [self errorWithDictionary:responseJSON];
                                                }
                                            }
                                        }
                                        if(responseError != nil) {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

@end

/*--------------------------------------------------*/

ItsBeta * sharedItsBeta = nil;

/*--------------------------------------------------*/