/*--------------------------------------------------*/

#import "ItsBeta.h"
#import "RestAPI.h"

/*--------------------------------------------------*/

NSString* const ItsBetaErrorDomain = @"ItsBetaErrorDomain";

/*--------------------------------------------------*/

@interface ItsBeta (Private)

- (NSError*) errorByStatus:(NSString*)byStatus byDescription:(NSString*)byDescription byAdditionalInfo:(NSString*)byAdditionalInfo;
- (NSError*) errorByDescription:(NSString*)byDescription;

@end

/*--------------------------------------------------*/

@implementation ItsBeta (Private)

- (NSError*) errorByStatus:(NSString*)byStatus byDescription:(NSString*)byDescription byAdditionalInfo:(NSString*)byAdditionalInfo {
    return [NSError errorWithDomain:ItsBetaErrorDomain code:ItsBetaErrorResponse userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ - %@ '%@'", byStatus, byDescription, byAdditionalInfo] forKey:NSLocalizedDescriptionKey]];
}

- (NSError*) errorByDescription:(NSString*)byDescription {
    return [NSError errorWithDomain:ItsBetaErrorDomain code:ItsBetaErrorInternal userInfo:[NSDictionary dictionaryWithObjectsAndKeys:byDescription, NSLocalizedDescriptionKey, nil]];
}

@end

/*--------------------------------------------------*/

@implementation ItsBeta

@synthesize serviceURL = mServiceURL;
@synthesize accessToken = mAccessToken;

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
    }
    return self;
}

- (void) dealloc {
    [mAccessToken release];
    [mServiceURL release];
    [super dealloc];
}

- (void) requestCategoriesWithLocale:(NSString*)locale callback:(ItsBetaCallbackCategories)callback {
    NSMutableDictionary* query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  mAccessToken, @"access_token",
                                  nil];
    if(locale != nil) {
        [query setObject:locale forKey:@"locale"];
    }
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:[NSString stringWithFormat:@"%@/info/categories.json", mServiceURL]
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil) {
                                            if([responseJSON isKindOfClass:[NSArray class]] == YES) {
                                                ItsBetaCategories* result = [ItsBetaCategories categories];
                                                if(result != nil) {
                                                    NSArray* categories = (NSArray*)responseJSON;
                                                    for(NSDictionary* itemCategory in categories) {
                                                        ItsBetaCategory* resultCategory = [ItsBetaCategory categoryWithID:[itemCategory objectForKey:@"api_name"] name:[itemCategory objectForKey:@"display_name"] title:[itemCategory objectForKey:@"display_name"]];
                                                        if(resultCategory != nil) {
                                                            [result addCategory:resultCategory];
                                                        }
                                                    }
                                                    callback(result, nil);
                                                } else {
                                                    responseError = [self errorByDescription:@"Out of memory"];
                                                }
                                            } else if([responseJSON isKindOfClass:[NSDictionary class]] == YES) {
                                                responseError = [self errorByStatus:[responseJSON objectForKey:@"error"] byDescription:[responseJSON objectForKey:@"description"] byAdditionalInfo:[responseJSON objectForKey:@"additional_info"]];
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

- (void) requestProjectsByCategory:(ItsBetaCategory*)byCategory
                          callback:(ItsBetaCallbackProjects)callback
{
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:[NSString stringWithFormat:@"%@/info/projects.json", mServiceURL]
                                      query:[NSDictionary dictionaryWithObjectsAndKeys:
                                             mAccessToken, @"access_token",
                                             [byCategory ID], @"category_name",
                                             nil]
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            if([responseJSON isKindOfClass:[NSArray class]] == YES)
                                            {
                                                ItsBetaProjects* result = [ItsBetaProjects projects];
                                                if(result != nil)
                                                {
                                                    NSArray* projects = (NSArray*)responseJSON;
                                                    for(NSDictionary* itemProject in projects)
                                                    {
                                                        ItsBetaProject* resultProject = [ItsBetaProject projectWithID:[itemProject objectForKey:@"id"]
                                                                                                           name:[itemProject objectForKey:@"api_name"]
                                                                                                          title:[itemProject objectForKey:@"display_name"]
                                                                                                       category:byCategory];
                                                        if(resultProject != nil)
                                                        {
                                                            [result addProject:resultProject];
                                                        }
                                                    }
                                                    callback(result, nil);
                                                }
                                                else
                                                {
                                                    responseError = [self errorByDescription:@"Out of memory"];
                                                }
                                            }
                                            else if([responseJSON isKindOfClass:[NSDictionary class]] == YES)
                                            {
                                                responseError = [self errorByStatus:[responseJSON objectForKey:@"error"]
                                                                      byDescription:[responseJSON objectForKey:@"description"]
                                                                   byAdditionalInfo:[responseJSON objectForKey:@"additional_info"]];
                                            }
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

- (void) requestParamsByProject:(ItsBetaProject*)byProject
                       callback:(ItsBetaCallbackParams)callback
{
    [RestAPIConnection connectionWithMethod:@"GET"
                                        url:[NSString stringWithFormat:@"%@/info/apidef.json", mServiceURL]
                                      query:[NSDictionary dictionaryWithObjectsAndKeys:
                                             mAccessToken, @"access_token",
                                             [byProject ID], @"project_id",
                                             nil]
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            NSString* error = [responseJSON objectForKey:@"error"];
                                            if(error == nil)
                                            {
                                                ItsBetaParams* result = [ItsBetaParams paramsWithID:[responseJSON objectForKey:@"id"]
                                                                                               keys:[responseJSON objectForKey:@"params"]];
                                                if(result != nil)
                                                {
                                                    callback(result, nil);
                                                }
                                                else
                                                {
                                                    responseError = [self errorByDescription:@"Out of memory"];
                                                }
                                            }
                                            else
                                            {
                                                responseError = [self errorByStatus:error
                                                                      byDescription:[responseJSON objectForKey:@"description"]
                                                                   byAdditionalInfo:[responseJSON objectForKey:@"additional_info"]];
                                            }
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

- (void) requestBadgesByProject:(ItsBetaProject*)byProject
                       callback:(ItsBetaCallbackBadges)callback
{
    [RestAPIConnection connectionWithMethod:@"GET"
                                        url:[NSString stringWithFormat:@"%@/info/badges.json", mServiceURL]
                                      query:[NSDictionary dictionaryWithObjectsAndKeys:
                                             mAccessToken, @"access_token",
                                             [byProject ID], @"project_id",
                                             nil]
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            if([responseJSON isKindOfClass:[NSArray class]] == YES)
                                            {
                                                ItsBetaBadges* result = [ItsBetaBadges sharedBadges];
                                                if(result != nil)
                                                {
                                                    NSArray* badges = (NSArray*)responseJSON;
                                                    for(NSDictionary* itemBadge in badges)
                                                    {
                                                        ItsBetaBadge* resultBadge = [ItsBetaBadge badgeWithID:[itemBadge objectForKey:@"id"]
                                                                                                         name:[itemBadge objectForKey:@"name"]
                                                                                                        title:[itemBadge objectForKey:@"title"]
                                                                                                  description:[itemBadge objectForKey:@"description"]
                                                                                                     imageURL:[itemBadge objectForKey:@"image"]
                                                                                                      project:byProject];
                                                        if(resultBadge != nil)
                                                        {
                                                            [result addBadge:resultBadge];
                                                        }
                                                    }
                                                    callback(result, nil);
                                                }
                                                else
                                                {
                                                    responseError = [self errorByDescription:@"Out of memory"];
                                                }
                                            }
                                            else if([responseJSON isKindOfClass:[NSDictionary class]] == YES)
                                            {
                                                responseError = [self errorByStatus:[responseJSON objectForKey:@"error"]
                                                                      byDescription:[responseJSON objectForKey:@"description"]
                                                                   byAdditionalInfo:[responseJSON objectForKey:@"additional_info"]];
                                            }
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

- (void) requestAchievementsByUser:(ItsBetaUser*)byUser
                        byCategory:(ItsBetaCategory*)byCategory
                         byProject:(ItsBetaProject*)byProject
                          byBadges:(ItsBetaBadges*)byBadges
                          callback:(ItsBetaCallbackAchievements)callback
{
    [self requestAchievementsByUser:byUser
                       byCategories:[ItsBetaCategories categoriesWithCategory:byCategory]
                         byProjects:[ItsBetaProjects projectsWithProject:byProject]
                           byBadges:byBadges
                           callback:callback];
}

- (void) requestAchievementsByUser:(ItsBetaUser*)byUser
                        byCategory:(ItsBetaCategory*)byCategory
                        byProjects:(ItsBetaProjects*)byProjects
                          byBadges:(ItsBetaBadges*)byBadges
                          callback:(ItsBetaCallbackAchievements)callback
{
    [self requestAchievementsByUser:byUser
                       byCategories:[ItsBetaCategories categoriesWithCategory:byCategory]
                         byProjects:byProjects
                           byBadges:byBadges
                           callback:callback];
}

- (void) requestAchievementsByUser:(ItsBetaUser*)byUser
                      byCategories:(ItsBetaCategories*)byCategories
                        byProjects:(ItsBetaProjects*)byProjects
                          byBadges:(ItsBetaBadges*)byBadges
                          callback:(ItsBetaCallbackAchievements)callback
{
    NSMutableDictionary* query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  mAccessToken, @"access_token",
                                  [byUser typeAsString], @"user_type",
                                  [byUser ID], @"user_id",
                                  nil];
    NSMutableArray* categoriesID = [NSMutableArray arrayWithCapacity:32];
    if(categoriesID != nil)
    {
        for(ItsBetaCategory* category in [byCategories list])
        {
            [categoriesID addObject:[category ID]];
        }
        NSString* categories = [categoriesID componentsJoinedByString:@","];
        if(categories != nil)
        {
            [query setObject:categories
                      forKey:@"categories"];
        }
    }
    NSMutableArray* projectsID = [NSMutableArray arrayWithCapacity:32];
    if(projectsID != nil)
    {
        for(ItsBetaProject* project in [byProjects list])
        {
            [projectsID addObject:[project ID]];
        }
        NSString* projects = [projectsID componentsJoinedByString:@","];
        if(projects != nil)
        {
            [query setObject:projects
                      forKey:@"projects"];
        }
    }
    [RestAPIConnection connectionWithMethod:@"GET"
                                        url:[NSString stringWithFormat:@"%@/players/retrieve.json", mServiceURL]
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        NSDictionary* responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            if([responseJSON isKindOfClass:[NSArray class]] == YES)
                                            {
                                                ItsBetaAchievements* result = [ItsBetaAchievements achievements];
                                                if(result != nil)
                                                {
                                                    NSArray* categories = (NSArray*)responseJSON;
                                                    for(NSDictionary* itemCategory in categories)
                                                    {
                                                        NSArray* projects = [itemCategory objectForKey:@"projects"];
                                                        for(NSDictionary* itemProject in projects)
                                                        {
                                                            NSArray* achievements = [itemProject objectForKey:@"achievements"];
                                                            for(NSDictionary* itemAchievement in achievements)
                                                            {
                                                                NSString* badgeID = [itemAchievement objectForKey:@"badge_id"];
                                                                ItsBetaBadge* resultBadge = [byBadges badgeAtID:badgeID];
                                                                
                                                                ItsBetaAchievement* resultAchievement = [ItsBetaAchievement achievementWithID:[itemAchievement objectForKey:@"id"]
                                                                                                                                    faceBookID:[itemAchievement objectForKey:@"ololo"]
                                                                                                                                            badgeID:badgeID
                                                                                                                                      details:[itemAchievement objectForKey:@"details"]
                                                                                                                                    activated:[[itemAchievement objectForKey:@"activated"] boolValue]
                                                                                                                                         user:byUser
                                                                                                                                        badge:resultBadge];
                                                                if(resultAchievement != nil)
                                                                {
                                                                    [result addAchievement:resultAchievement];
                                                                }
                                                            }
                                                        }
                                                    }
                                                    callback(result, nil);
                                                }
                                                else
                                                {
                                                    responseError = [self errorByDescription:@"Out of memory"];
                                                }
                                            }
                                            else if([responseJSON isKindOfClass:[NSDictionary class]] == YES)
                                            {
                                                responseError = [self errorByStatus:[responseJSON objectForKey:@"error"]
                                                                      byDescription:[responseJSON objectForKey:@"description"]
                                                                   byAdditionalInfo:[responseJSON objectForKey:@"additional_info"]];
                                            }
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

- (void) requestAchievementAvailabilityByUser:(ItsBetaUser *)byUser
                           byObjectTemplateId:(NSString*)byObjectTemplateId
                          callback:(ItsBetaCallbackAchievementAviability)callback
{
    NSMutableDictionary* query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  mAccessToken, @"access_token",
                                  byObjectTemplateId, @"objtemplate_id",
                                  [byUser ID], @"player_id",
                                  nil];
    
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:[NSString stringWithFormat:@"%@/info/objs.json", mServiceURL]
                                      query:query
                                    success:^(RestAPIConnection *connection)
                                    {
                                        NSError* responseError = nil;
                                        NSDictionary* responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            if([responseJSON isKindOfClass:[NSArray class]] == YES)
                                            {
                                                if ([responseJSON count] > 0)
                                                {
                                                    callback(YES, nil);
                                                }
                                                else
                                                {
                                                    callback(NO, nil);
                                                }
                                            }
                                            else if([responseJSON isKindOfClass:[NSDictionary class]] == YES)
                                            {
                                                NSString* status = [responseJSON objectForKey:@"error"];
                                                if(status != nil)
                                                {
                                                    if([status isEqualToString:@"304"] == YES)
                                                    {
                                                        callback(NO, nil);
                                                    }
                                                    else
                                                    {
                                                        responseError = [self errorByStatus:[responseJSON objectForKey:@"error"]
                                                                              byDescription:[responseJSON objectForKey:@"description"]
                                                                           byAdditionalInfo:[responseJSON objectForKey:@"additional_info"]];
                                                    }
                                                }
                                                else
                                                {
                                                    callback(YES, nil);
                                                }
                                            }
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(NO, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(NO, error);
                                    }];
}

- (void) requestAchievementsAvailabilityByUser:(ItsBetaUser *)byUser
                            byObjectTemplates:(ItsBetaBadges*)byObjectTemplates
{
    NSMutableArray* templatesCopy = [[byObjectTemplates list] copy];
    for(ItsBetaBadge* badge in templatesCopy)
    {
        if(badge != nil)
        {
            [self requestAchievementAvailabilityByUser:byUser
                                    byObjectTemplateId:[badge ID]
                                              callback:^(BOOL availability, NSError *error)
            {
                if(error == nil)
                {
                    if(availability != [badge aviability])
                    {
                        [badge setAviability:availability];
                        [byObjectTemplates addBadge:badge replaceIfExist:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"badgeStateChanged" object:self];
                    }
                    // Создаём ачивку за установку приложения, если она ещё не получена
                    if([[badge name] isEqualToString:@"rospil_installed"] == YES && [badge aviability] == NO)
                    {
                        [self requestCreateAchievementByBadge:badge
                                                     byParams:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"unique", nil]
                                               byExternalCode:[[ItsBetaUser sharedItsBetaUser] faceBookID]
                                                     callback:^(NSString *achieveInternalID, NSString *achieveFBID, NSError *error)
                        {
                            if (error == nil)
                            {
                                ItsBetaAchievement* achievementForInstall = [ItsBetaAchievement achievementWithID:achieveInternalID
                                                                                                       faceBookID:achieveFBID
                                                                                                          badgeID:[badge ID]
                                                                                                          details:@""
                                                                                                        activated:YES
                                                                                                             user:byUser
                                                                                                            badge:badge];
                                [[ItsBetaAchievements sharedItsBetaAchievements] addAchievement:achievementForInstall];
                                [badge setAviability:YES];
                                [byObjectTemplates addBadge:badge replaceIfExist:YES];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"badgeStateChanged" object:self];
                            }
                        }];
                    }
                    // Создаём ачивку за комментарий, если комментарий был оставлен, а ачивка ещё не получена
                    else if([[badge name] isEqualToString:@"rospil_comment"] == YES && [badge aviability] == NO && [g_RP commentPosted] == YES)
                    {
                        [self requestCreateAchievementByBadge:badge
                                                     byParams:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"unique", nil]
                                               byExternalCode:[[ItsBetaUser sharedItsBetaUser] faceBookID]
                                                     callback:^(NSString *achieveInternalID, NSString *achieveFBID, NSError *error)
                         {
                             if (error == nil)
                             {
                                 ItsBetaAchievement* achievementForComment = [ItsBetaAchievement achievementWithID:achieveInternalID
                                                                                                        faceBookID:achieveFBID
                                                                                                           badgeID:[badge ID]
                                                                                                           details:@""
                                                                                                         activated:YES
                                                                                                              user:byUser
                                                                                                             badge:badge];
                                 [[ItsBetaAchievements sharedItsBetaAchievements] addAchievement:achievementForComment];
                                 [badge setAviability:YES];
                                 [byObjectTemplates addBadge:badge replaceIfExist:YES];
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"badgeStateChanged" object:self];
                             }
                         }];
                    }
                    else if([[badge name] isEqualToString:@"rospil_comment"] == YES && [badge aviability] == YES)
                    {
                        [g_RP setCommentPosted:YES];
                    }
                }
            }];
        }
    }
    
}

- (void) requestCreateAchievementByBadge:(ItsBetaBadge*)byBadge
                                byParams:(NSDictionary*)byParams
                          byExternalCode:(NSString*)byExternalCode
                                callback:(ItsBetaCallbackCreateAchievement)callback
{
    NSMutableDictionary* query = [NSMutableDictionary dictionaryWithObject:mAccessToken forKey:@"access_token"];
    if(byExternalCode != nil)
    {
        [query setObject:byExternalCode
                  forKey:@"user_id"];
    }
    [byParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         [query setObject:obj
                   forKey:key];
         *stop = NO;
     }];
    [query setObject:[byBadge name] forKey:@"badge_name"];
    [query setObject:[[[FBSession activeSession] accessTokenData] accessToken] forKey:@"user_token"];
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:[NSString stringWithFormat:@"%@/%@/%@/achieves/posttofbonce.json", mServiceURL, [[[byBadge project] category] ID], [[byBadge project] name]]
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        NSDictionary* responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            NSString* error = [responseJSON objectForKey:@"error"];
                                            if(error == nil)
                                            {
                                                if([[[ItsBetaUser sharedItsBetaUser] ID] isEqualToString:@""] == YES)
                                                {
                                                    [[ItsBeta sharedItsBeta] requestInternalUserIDByUser:[ItsBetaUser sharedItsBetaUser]
                                                                                                callback:^(NSString *internalUserID, NSError *error)
                                                     {
                                                         if(error == nil)
                                                         {
                                                             [[ItsBetaUser sharedItsBetaUser] setID:internalUserID];
                                                         }
                                                         else
                                                         {
                                                             if([[[[error userInfo] objectForKey:@"status"] stringValue] isEqualToString:@"305"] == YES)
                                                             {
                                                                 [[ItsBetaUser sharedItsBetaUser] setID:NULL];
                                                             }
                                                         }
                                                     }];
                                                }
                                                callback([responseJSON objectForKey:@"id"], [responseJSON objectForKey:@"fb_id"], nil);
                                            }
                                            else
                                            {
                                                responseError = [self errorByStatus:error
                                                                      byDescription:[responseJSON objectForKey:@"description"]
                                                                   byAdditionalInfo:[responseJSON objectForKey:@"additional_info"]];
                                            }
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(nil, nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, nil, error);
                                    }];
}

- (void) requestAchievementURLByAchievement:(NSString *)byAchievemntFBID
                                     byType:(NSString *)byType
                                   callback:(ItsBetaCallbackAchievementURL)callback
{
    NSMutableDictionary* query = [NSMutableDictionary dictionaryWithObject:mAccessToken forKey:@"access_token"];
    if(byAchievemntFBID != nil)
    {
        [query setObject:byAchievemntFBID
                  forKey:@"id"];
    }
    else
    {
        [query setObject:@""
                  forKey:@"id"];
    }
    if(byType != nil)
    {
        [query setObject:byType forKey:@"type"];
    }
    else
    {
        [query setObject:@"fb" forKey:@"type"];
    }
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:[NSString stringWithFormat:@"%@/info/achievement_url.json", mServiceURL]
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        NSDictionary* responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            NSString* error = [responseJSON objectForKey:@"error"];
                                            if(error == nil)
                                            {
                                                callback([responseJSON objectForKey:@"url"], nil);
                                            }
                                            else
                                            {
                                                responseError = [self errorByStatus:error
                                                                      byDescription:[responseJSON objectForKey:@"description"]
                                                                   byAdditionalInfo:[responseJSON objectForKey:@"additional_info"]];
                                            }
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(nil, responseError);
                                        }
                                    }
                                    failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}



- (void) requestInternalUserIDByUser:(ItsBetaUser *)byUser
                            callback:(ItsBetaCallbackInternalID)callback
{
    NSString* url = nil;
    NSMutableDictionary* query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  mAccessToken, @"access_token",
                                  @"fb_user_id", @"type",
                                  [byUser faceBookID], @"id",
                                  nil];
    
    url = [NSString stringWithFormat:@"%@/info/playerid.json", mServiceURL];
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:url
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        NSDictionary* responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            NSString* error = [responseJSON objectForKey:@"error"];
                                            if(error == nil)
                                            {
                                                NSString* result = [responseJSON objectForKey:@"player_id"];
                                                if(result != nil)
                                                {
                                                    callback(result, nil);
                                                }
                                                else
                                                {
                                                    responseError = [self errorByDescription:@"Out of memory"];
                                                }
                                            }
                                            else if([error isEqualToString:@"305"] == YES )
                                            {
                                                responseError = [NSError errorWithDomain:ItsBetaErrorDomain
                                                                                    code:ItsBetaErrorResponse
                                                                                userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@", error] forKey:@"status"]];
                                            }
                                            else
                                            {
                                                responseError = [self errorByStatus:error
                                                                      byDescription:[responseJSON objectForKey:@"description"]
                                                                   byAdditionalInfo:[responseJSON objectForKey:@"additional_info"]];
                                            }
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(nil, responseError);
                                        }
                                    } failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

- (void) requestBadgeTemplateByTypeID:(NSString *)byTypeID
                            byProjectID:(NSString *)byProjectID
                             callback:(ItsBetaCallBackBadge)callback
{
    NSString* url = nil;
    NSMutableDictionary* query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  mAccessToken, @"access_token",
                                  byTypeID, @"objtype_id",
                                  byProjectID, @"project_id",
                                  nil];
    
    url = [NSString stringWithFormat:@"%@/info/objtemplates.json", mServiceURL];
    [RestAPIConnection connectionWithMethod:@"POST"
                                        url:url
                                      query:query
                                    success:^(RestAPIConnection *connection) {
                                        NSError* responseError = nil;
                                        id responseJSON = [NSJSONSerialization JSONObjectWithData:[connection receivedData] options:0 error:&responseError];
                                        if(responseError == nil)
                                        {
                                            if([responseJSON isKindOfClass:[NSArray class]] == YES)
                                            {
                                                for(NSDictionary* template in responseJSON)
                                                {
                                                    NSString* error = [template objectForKey:@"error"];
                                                    if(error == nil)
                                                    {
                                                        ItsBetaBadge* badge = [ItsBetaBadge badgeWithID:[template objectForKey:@"id"]
                                                                                                   name:[template objectForKey:@"api_name"]
                                                                                                  title:[template objectForKey:@"api_name"]
                                                                                            description:[template objectForKey:@"api_name"]
                                                                                               imageURL:[template objectForKey:@"pic"]
                                                                                                project:[ItsBetaProject projectWithID:byProjectID name:@"rospil" title:@"rospil" category:[ItsBetaCategory categoryWithID:@"social" name:@"social" title:@"Social"]]];
                                                        if(badge != nil)
                                                        {
                                                            callback(badge, nil);
                                                        }
                                                        else
                                                        {
                                                            responseError = [self errorByDescription:@"Out of memory"];
                                                        }
                                                    }
                                                    else
                                                    {
                                                        responseError = [self errorByStatus:error
                                                                              byDescription:[template objectForKey:@"description"]
                                                                           byAdditionalInfo:[template objectForKey:@"additional_info"]];
                                                    }
                                                }
                                            }
                                            
                                        }
                                        if(responseError != nil)
                                        {
                                            callback(nil, responseError);
                                        }
                                    } failure:^(RestAPIConnection *connection, NSError *error) {
                                        callback(nil, error);
                                    }];
}

@end

/*--------------------------------------------------*/

ItsBeta * sharedItsBeta = nil;
NSArray* sharedBadgeTypeIDs = nil;

/*--------------------------------------------------*/