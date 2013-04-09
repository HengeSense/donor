/*--------------------------------------------------*/

#import "ItsBetaCore.h"

/*--------------------------------------------------*/

typedef void (^ItsBetaApiResponseCategoryCollection)(ItsBetaCategoryCollection* collection, NSError* error);
typedef void (^ItsBetaApiResponseProjectCollection)(ItsBetaProjectCollection* collection, NSError* error);
typedef void (^ItsBetaApiResponseObjectTypeCollection)(ItsBetaObjectTypeCollection* collection, NSError* error);
typedef void (^ItsBetaApiResponseObjectTemplateCollection)(ItsBetaObjectTemplateCollection* collection, NSError* error);
typedef void (^ItsBetaApiResponseObjectCollection)(ItsBetaObjectCollection* collection, NSError* error);
typedef void (^ItsBetaApiResponseCountObject)(NSUInteger count, NSError* error);
typedef void (^ItsBetaApiResponsePlayerId)(NSString* playerId, NSError* error);
typedef void (^ItsBetaApiResponseCreateAchievement)(NSString* activateCode, NSError* error);
typedef void (^ItsBetaApiResponseActivateAchievement)(NSString* object_id, NSError* error);
typedef void (^ItsBetaApiResponseGiveAchievement)(NSString* object, NSError* error);
typedef void (^ItsBetaApiResponseAchievementURL)(NSString* object_url, NSError* error);

/*--------------------------------------------------*/

@interface ItsBetaApi : NSObject

+ (NSString*) playerTypeToString:(ItsBetaPlayerType)playerType;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                    locale:(NSString*)locale
                categories:(ItsBetaApiResponseCategoryCollection)categories;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                  projects:(ItsBetaApiResponseProjectCollection)projects;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                  category:(ItsBetaCategory*)category
                  projects:(ItsBetaApiResponseProjectCollection)projects;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                   project:(ItsBetaProject*)project
               objectTypes:(ItsBetaApiResponseObjectTypeCollection)objectTypes;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                   project:(ItsBetaProject*)project
                objectType:(ItsBetaObjectType*)objectType
               objectTypes:(ItsBetaApiResponseObjectTypeCollection)objectTypes;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                objectType:(ItsBetaObjectType*)objectType
           objectTemplates:(ItsBetaApiResponseObjectTemplateCollection)objectTemplates;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                   project:(ItsBetaProject*)project
           objectTemplates:(ItsBetaApiResponseObjectTemplateCollection)objectTemplates;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                   project:(ItsBetaProject*)project
                objectType:(ItsBetaObjectType*)objectType
           objectTemplates:(ItsBetaApiResponseObjectTemplateCollection)objectTemplates;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                    player:(ItsBetaPlayer*)player
            objectTemplate:(ItsBetaObjectTemplate*)objectTemplate
                   objects:(ItsBetaApiResponseObjectCollection)objects;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                    player:(ItsBetaPlayer*)player
                   project:(ItsBetaProject*)project
           objectTemplate:(ItsBetaObjectTemplate*)objectTemplate
                   objects:(ItsBetaApiResponseObjectCollection)objects;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                    player:(ItsBetaPlayer*)player
                   project:(ItsBetaProject*)project
              countObjects:(ItsBetaApiResponseCountObject)countObjects;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                lastUpdate:(NSDate*)lastUpdate
                    player:(ItsBetaPlayer*)player
                   project:(ItsBetaProject*)project
                      page:(NSUInteger)page
                   prePage:(NSUInteger)prePage
                   objects:(ItsBetaApiResponseObjectCollection)objects;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                facebookId:(NSString*)facebookId
                  playerId:(ItsBetaApiResponsePlayerId)playerId;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                playerType:(ItsBetaPlayerType)playerType
                    userId:(NSString*)userId
                  playerId:(ItsBetaApiResponsePlayerId)playerId;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                   project:(ItsBetaProject*)project
            objectTemplate:(ItsBetaObjectTemplate*)objectTemplate
                    params:(NSDictionary*)params
              activateCode:(ItsBetaApiResponseCreateAchievement)activateCode;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                   project:(ItsBetaProject*)project
                    player:(ItsBetaPlayer*)player
              activateCode:(NSString*)activateCode
                    object:(ItsBetaApiResponseActivateAchievement)object;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                   project:(ItsBetaProject*)project
            objectTemplate:(ItsBetaObjectTemplate*)objectTemplate
                    params:(NSDictionary*)params
                    player:(ItsBetaPlayer*)player
                    object:(ItsBetaApiResponseGiveAchievement)object;

+ (void) requestServiceURL:(NSString*)serviceURL
               accessToken:(NSString*)accessToken
                  objectId:(NSString*)objectId
              objectIdType:(NSString*)objectIdType
                    params:(NSDictionary*)params
                    object:(ItsBetaApiResponseAchievementURL)object;
@end

/*--------------------------------------------------*/
