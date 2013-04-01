/*--------------------------------------------------*/

#import "ItsBetaApi.h"
#import "ItsBetaRest.h"

/*--------------------------------------------------*/

#import "ItsBetaApplication.h"
#import "ItsBetaPlayer.h"
#import "ItsBetaCategory.h"
#import "ItsBetaProject.h"
#import "ItsBetaParams.h"
#import "ItsBetaObjectType.h"
#import "ItsBetaObjectTemplate.h"
#import "ItsBetaObject.h"

/*--------------------------------------------------*/

#import "NSDate+ItsBeta.h"

/*--------------------------------------------------*/

@interface ItsBetaApi () {
    NSDate* lastUpdate;
}

+ (NSError*) errorWithDictionary:(NSDictionary*)dictionary;

@end

/*--------------------------------------------------*/

@implementation ItsBetaApi

+ (NSError*) errorWithDictionary:(NSDictionary*)dictionary {
    NSString* status = [dictionary objectForKey:@"status"];
    NSString* description = [dictionary objectForKey:@"description"];
    NSString* additionalInfo = [dictionary objectForKey:@"additional_info"];
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ - %@ '%@'", status, description, additionalInfo] forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:ItsBetaErrorDomain code:ItsBetaErrorResponse userInfo:userInfo];
}

+ (NSString*) playerTypeToString:(ItsBetaPlayerType)playerType {
    switch(playerType) {
        case ItsBetaPlayerTypeFacebook: return @"fb";
        default: break;
    }
    return @"";
}

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                    locale:(NSString*)locale
                categories:(ItsBetaApiResponseCategoryCollection)categories {
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    if(accessToken != nil) {
        [query setObject:accessToken forKey:@"access_token"];
    }
    if(locale != nil) {
        [query setObject:locale forKey:@"locale"];
    }
    if(lastUpdate != nil) {
        [query setObject:[NSDate iso8601FromDate:lastUpdate] forKey:@"updated_at"];
    }
    ItsBetaRest* rest = [ItsBetaRest restWithMethod:@"POST" url:[NSString stringWithFormat:@"%@/info/categories.json", serviceURL] query:query];
    [rest sendSuccess:^(ItsBetaRest* rest) {
        NSError* error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:[rest receivedData] options:0 error:&error];
        if(error == nil) {
            if([json isKindOfClass:[NSArray class]] == YES) {
                if(categories != nil) {
                    categories([ItsBetaCategoryCollection collectionWithArray:json], nil);
                }
            } else if([json isKindOfClass:[NSDictionary class]] == YES) {
                error = [self errorWithDictionary:json];
            }
        }
        if(error != nil) {
            if(categories != nil) {
                categories(nil, error);
            }
            NSLog(@"%@", error);
        }
    } sendFailure:^(ItsBetaRest* rest, NSError* error) {
        if(categories != nil) {
            categories(nil, error);
        }
        NSLog(@"%@", error);
    }];
}

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                  projects:(ItsBetaApiResponseProjectCollection)projects {
    [self requestServiceURL:serviceURL
                accessToken:accessToken
                 lastUpdate:lastUpdate
                   category:nil
                   projects:projects];
}

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                  category:(ItsBetaCategory*)category
                  projects:(ItsBetaApiResponseProjectCollection)projects {
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    if(accessToken != nil) {
        [query setObject:accessToken forKey:@"access_token"];
    }
    if(category != nil) {
        [query setObject:[category name] forKey:@"category_name"];
    }
    if(lastUpdate != nil) {
        [query setObject:[NSDate iso8601FromDate:lastUpdate] forKey:@"updated_at"];
    }
    ItsBetaRest* rest = [ItsBetaRest restWithMethod:@"POST" url:[NSString stringWithFormat:@"%@/info/projects.json", serviceURL] query:query];
    [rest sendSuccess:^(ItsBetaRest* rest) {
        NSError* error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:[rest receivedData] options:0 error:&error];
        if(error == nil) {
            if([json isKindOfClass:[NSArray class]] == YES) {
                if(projects != nil) {
                    projects([ItsBetaProjectCollection collectionWithArray:json], nil);
                }
            } else if([json isKindOfClass:[NSDictionary class]] == YES) {
                error = [self errorWithDictionary:json];
            }
        }
        if(error != nil) {
            if(projects != nil) {
                projects(nil, error);
            }
            NSLog(@"%@", error);
        }
    } sendFailure:^(ItsBetaRest* rest, NSError* error) {
        if(projects != nil) {
            projects(nil, error);
        }
        NSLog(@"%@", error);
    }];
}

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                   project:(ItsBetaProject*)project
               objectTypes:(ItsBetaApiResponseObjectTypeCollection)objectTypes {
    [self requestServiceURL:serviceURL
                accessToken:accessToken
                 lastUpdate:lastUpdate
                    project:project
                 objectType:nil
                objectTypes:objectTypes];
}

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                   project:(ItsBetaProject*)project
                objectType:(ItsBetaObjectType*)objectType
               objectTypes:(ItsBetaApiResponseObjectTypeCollection)objectTypes {
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    if(accessToken != nil) {
        [query setObject:accessToken forKey:@"access_token"];
    }
    if(project != nil) {
        [query setObject:[project Id] forKey:@"project_id"];
    }
    if(objectType != nil) {
        [query setObject:[objectType Id] forKey:@"parent_id"];
    }
    if(lastUpdate != nil) {
        [query setObject:[NSDate iso8601FromDate:lastUpdate] forKey:@"updated_at"];
    }
    ItsBetaRest* rest = [ItsBetaRest restWithMethod:@"POST" url:[NSString stringWithFormat:@"%@/info/objtypes.json", serviceURL] query:query];
    [rest sendSuccess:^(ItsBetaRest* rest) {
        NSError* error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:[rest receivedData] options:0 error:&error];
        if(error == nil) {
            if([json isKindOfClass:[NSArray class]] == YES) {
                if(objectTypes != nil) {
                    objectTypes([ItsBetaObjectTypeCollection collectionWithArray:json], nil);
                }
            } else if([json isKindOfClass:[NSDictionary class]] == YES) {
                error = [self errorWithDictionary:json];
            }
        }
        if(error != nil) {
            if(objectTypes != nil) {
                objectTypes(nil, error);
            }
            NSLog(@"%@", error);
        }
    } sendFailure:^(ItsBetaRest* rest, NSError* error) {
        if(objectTypes != nil) {
            objectTypes(nil, error);
        }
        NSLog(@"%@", error);
    }];
}

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                objectType:(ItsBetaObjectType*)objectType
           objectTemplates:(ItsBetaApiResponseObjectTemplateCollection)objectTemplates {
    [self requestServiceURL:serviceURL
                accessToken:accessToken
                 lastUpdate:lastUpdate
                    project:nil
                 objectType:objectType
            objectTemplates:objectTemplates];
}

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                   project:(ItsBetaProject*)project
           objectTemplates:(ItsBetaApiResponseObjectTemplateCollection)objectTemplates {
    [self requestServiceURL:serviceURL
                accessToken:accessToken
                 lastUpdate:lastUpdate
                    project:project
                 objectType:nil
            objectTemplates:objectTemplates];
}

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                   project:(ItsBetaProject*)project
                objectType:(ItsBetaObjectType*)objectType
           objectTemplates:(ItsBetaApiResponseObjectTemplateCollection)objectTemplates {
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    if(accessToken != nil) {
        [query setObject:accessToken forKey:@"access_token"];
    }
    if(project != nil) {
        [query setObject:[project Id] forKey:@"project_id"];
    }
    if(objectType != nil) {
        [query setObject:[objectType Id] forKey:@"objtype_id"];
    }
    if(lastUpdate != nil) {
        [query setObject:[NSDate iso8601FromDate:lastUpdate] forKey:@"updated_at"];
    }
    ItsBetaRest* rest = [ItsBetaRest restWithMethod:@"POST" url:[NSString stringWithFormat:@"%@/info/objtemplates.json", serviceURL] query:query];
    [rest sendSuccess:^(ItsBetaRest* rest) {
        NSError* error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:[rest receivedData] options:0 error:&error];
        if(error == nil) {
            if([json isKindOfClass:[NSArray class]] == YES) {
                if(objectTemplates != nil) {
                    objectTemplates([ItsBetaObjectTemplateCollection collectionWithArray:json], nil);
                }
            } else if([json isKindOfClass:[NSDictionary class]] == YES) {
                error = [self errorWithDictionary:json];
            }
        }
        if(error != nil) {
            if(objectTemplates != nil) {
                objectTemplates(nil, error);
            }
            NSLog(@"%@", error);
        }
    } sendFailure:^(ItsBetaRest* rest, NSError* error) {
        if(objectTemplates != nil) {
            objectTemplates(nil, error);
        }
        NSLog(@"%@", error);
    }];
}

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                    player:(ItsBetaPlayer*)player
            objectTemplate:(ItsBetaObjectTemplate*)objectTemplate
                   objects:(ItsBetaApiResponseObjectCollection)objects {
    [self requestServiceURL:serviceURL
                accessToken:accessToken
                 lastUpdate:lastUpdate
                     player:player
                    project:nil
             objectTemplate:objectTemplate
                    objects:objects];
}

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                    player:(ItsBetaPlayer*)player
                   project:(ItsBetaProject*)project
            objectTemplate:(ItsBetaObjectTemplate*)objectTemplate
                   objects:(ItsBetaApiResponseObjectCollection)objects {
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    if(accessToken != nil) {
        [query setObject:accessToken forKey:@"access_token"];
    }
    if(player != nil) {
        [query setObject:[player Id] forKey:@"player_id"];
    }
    if(project != nil) {
        [query setObject:[project Id] forKey:@"project_id"];
    }
    if(objectTemplate != nil) {
        [query setObject:[objectTemplate Id] forKey:@"objtemplate_id"];
    }
    if(lastUpdate != nil) {
        [query setObject:[NSDate iso8601FromDate:lastUpdate] forKey:@"updated_at"];
    }
    ItsBetaRest* rest = [ItsBetaRest restWithMethod:@"POST" url:[NSString stringWithFormat:@"%@/info/objs.json", serviceURL] query:query];
    [rest sendSuccess:^(ItsBetaRest* rest) {
        NSError* error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:[rest receivedData] options:0 error:&error];
        if(error == nil) {
            if([json isKindOfClass:[NSArray class]] == YES) {
                if(objects != nil) {
                    objects([ItsBetaObjectCollection collectionWithArray:json], nil);
                }
            } else if([json isKindOfClass:[NSDictionary class]] == YES) {
                error = [self errorWithDictionary:json];
            }
        }
        if(error != nil) {
            if(objects != nil) {
                objects(nil, error);
            }
            NSLog(@"%@", error);
        }
    } sendFailure:^(ItsBetaRest* rest, NSError* error) {
        if(objects != nil) {
            objects(nil, error);
        }
        NSLog(@"%@", error);
    }];
}

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                    player:(ItsBetaPlayer*)player
                   project:(ItsBetaProject*)project
              countObjects:(ItsBetaApiResponseCountObject)countObjects {
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    if(accessToken != nil) {
        [query setObject:accessToken forKey:@"access_token"];
    }
    if(player != nil) {
        [query setObject:[player Id] forKey:@"player_id"];
    }
    if(project != nil) {
        [query setObject:[project Id] forKey:@"project_id"];
    }
    if(lastUpdate != nil) {
        [query setObject:[NSDate iso8601FromDate:lastUpdate] forKey:@"updated_at"];
    }
    ItsBetaRest* rest = [ItsBetaRest restWithMethod:@"POST" url:[NSString stringWithFormat:@"%@/info/projectobjs.json", serviceURL] query:query];
    [rest sendSuccess:^(ItsBetaRest* rest) {
        NSError* error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:[rest receivedData] options:0 error:&error];
        if(error == nil) {
            if([json isKindOfClass:[NSDictionary class]] == YES) {
                NSNumber* count = [json objectForKey:@"count"];
                if(count != nil) {
                    if(countObjects != nil) {
                        countObjects([count unsignedIntegerValue], nil);
                    }
                } else {
                    error = [self errorWithDictionary:json];
                }
            }
        }
        if(error != nil) {
            if(countObjects != nil) {
                countObjects(0, error);
            }
            NSLog(@"%@", error);
        }
    } sendFailure:^(ItsBetaRest* rest, NSError* error) {
        if(countObjects != nil) {
            countObjects(0, error);
        }
        NSLog(@"%@", error);
    }];
}

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                    player:(ItsBetaPlayer*)player
                   project:(ItsBetaProject*)project
                      page:(NSUInteger)page
                   prePage:(NSUInteger)prePage
                   objects:(ItsBetaApiResponseObjectCollection)objects {
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    if(accessToken != nil) {
        [query setObject:accessToken forKey:@"access_token"];
    }
    if(player != nil) {
        [query setObject:[player Id] forKey:@"player_id"];
    }
    if(project != nil) {
        [query setObject:[project Id] forKey:@"project_id"];
    }
    if(page != NSNotFound) {
        [query setObject:[NSNumber numberWithUnsignedInteger:page] forKey:@"page"];
    }
    if(prePage != NSNotFound) {
        [query setObject:[NSNumber numberWithUnsignedInteger:prePage] forKey:@"pre_page"];
    }
    if(lastUpdate != nil) {
        [query setObject:[NSDate iso8601FromDate:lastUpdate] forKey:@"updated_at"];
    }
    ItsBetaRest* rest = [ItsBetaRest restWithMethod:@"POST" url:[NSString stringWithFormat:@"%@/info/projectobjs.json", serviceURL] query:query];
    [rest sendSuccess:^(ItsBetaRest* rest) {
        NSError* error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:[rest receivedData] options:0 error:&error];
        if(error == nil) {
            if([json isKindOfClass:[NSArray class]] == YES) {
                if(objects != nil) {
                    objects([ItsBetaObjectCollection collectionWithArray:json], nil);
                }
            } else if([json isKindOfClass:[NSDictionary class]] == YES) {
                error = [self errorWithDictionary:json];
            }
        }
        if(error != nil) {
            if(objects != nil) {
                objects(nil, error);
            }
            NSLog(@"%@", error);
        }
    } sendFailure:^(ItsBetaRest* rest, NSError* error) {
        if(objects != nil) {
            objects(nil, error);
        }
        NSLog(@"%@", error);
    }];
}

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                facebookId:(NSString*)facebookId
                  playerId:(ItsBetaApiResponsePlayerId)playerId {
    [self requestServiceURL:serviceURL
                accessToken:accessToken
                 playerType:ItsBetaPlayerTypeFacebook
                     userId:facebookId
                   playerId:playerId];
}

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                playerType:(ItsBetaPlayerType)playerType
                    userId:(NSString*)userId
                  playerId:(ItsBetaApiResponsePlayerId)playerId {
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    if(accessToken != nil) {
        [query setObject:accessToken forKey:@"access_token"];
    }
    [query setObject:[self playerTypeToString:playerType] forKey:@"type"];
    if(userId != nil) {
        [query setObject:userId forKey:@"id"];
    }
    ItsBetaRest* rest = [ItsBetaRest restWithMethod:@"POST" url:[NSString stringWithFormat:@"%@/info/playerid.json", serviceURL] query:query];
    [rest sendSuccess:^(ItsBetaRest* rest) {
        NSError* error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:[rest receivedData] options:0 error:&error];
        if(error == nil) {
            if([json isKindOfClass:[NSDictionary class]] == YES) {
                NSString* player_id = [json objectForKey:@"player_id"];
                if(player_id != nil) {
                    if(playerId != nil) {
                        playerId([json objectForKey:@"player_id"], nil);
                    }
                } else {
                    error = [self errorWithDictionary:json];
                }
            }
        }
        if(error != nil) {
            if(playerId != nil) {
                playerId(nil, error);
            }
            NSLog(@"%@", error);
        }
    } sendFailure:^(ItsBetaRest* rest, NSError* error) {
        if(playerId != nil) {
            playerId(nil, error);
        }
        NSLog(@"%@", error);
    }];
}

@end

/*--------------------------------------------------*/