/*--------------------------------------------------*/

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

/*--------------------------------------------------*/

#if __has_feature(objc_arc)
#   define NS_SAFE_AUTORELEASE(object)              object
#   define NS_SAFE_RETAIN(object)                   object
#   define NS_SAFE_RELEASE(object)                  object = nil
#else
#   define NS_SAFE_AUTORELEASE(object)              [object autorelease]
#   define NS_SAFE_RETAIN(object)                   [object retain]
#   define NS_SAFE_RELEASE(object)                  [object release]
#endif

/*--------------------------------------------------*/

NSString* const ItsBetaErrorDomain;

/*--------------------------------------------------*/

enum {
    ItsBetaErrorInternal,
    ItsBetaErrorResponse,
    ItsBetaErrorFacebookAuth,

};
typedef NSUInteger ItsBetaError;

/*--------------------------------------------------*/

enum {
    ItsBetaUserTypeFacebook
};
typedef NSUInteger ItsBetaUserType;

/*--------------------------------------------------*/

@class ItsBetaUser;
@class ItsBetaImage;
@class ItsBetaCategory;
@class ItsBetaCategories;
@class ItsBetaProject;
@class ItsBetaProjects;
@class ItsBetaParams;
@class ItsBetaBadge;
@class ItsBetaBadges;
@class ItsBetaAchievement;
@class ItsBetaAchievements;

/*--------------------------------------------------*/

typedef void (^ItsBetaCallbackLogin)(NSError* error);
typedef void (^ItsBetaCallbackLogout)(NSError* error);
typedef void (^ItsBetaCallbackCategories)(ItsBetaCategories* categories, NSError* error);
typedef void (^ItsBetaCallbackProjects)(ItsBetaProjects* projects, NSError* error);
typedef void (^ItsBetaCallbackParams)(ItsBetaParams* params, NSError* error);
typedef void (^ItsBetaCallbackBadges)(ItsBetaBadges* badges, NSError* error);
typedef void (^ItsBetaCallbackAchievements)(ItsBetaAchievements* achievements, NSError* error);
typedef void (^ItsBetaCallbackCreateAchievement)(NSString* achieveInternalID, NSString* achieveFBID, NSError* error);
typedef void (^ItsBetaCallbackActivateAchievement)(ItsBetaAchievement* achievement, NSError* error);
typedef void (^ItsBetaCallbackLoadImage)(ItsBetaImage* image, NSError* error);
typedef void (^ItsBetaCallbackInternalID)(NSString* internalUserID, NSError* error);
typedef void (^ItsBetaCallbackAchievementAviability)(BOOL availability, NSError* error);
typedef void (^ItsBetaCallbackAchievementURL)(NSString* achievementURL, NSError* error);
typedef void (^ItsBetaCallBackBadge)(ItsBetaBadge* badge, NSError* error);

/*--------------------------------------------------*/

@interface ItsBeta : NSObject {
}

@property(nonatomic, readwrite, retain) NSString* serviceURL; // Базовый URL сервиса
@property(nonatomic, readwrite, retain) NSString* accessToken; // Уникальный ключ доступа
@property(nonatomic, readwrite, retain) NSString* locale; // Язык

+ (ItsBeta*) sharedItsBeta;

- (void) requestCategories:(ItsBetaCallbackCategories)callback;
- (void) requestProjectsByCategory:(ItsBetaCategory*)byCategory callback:(ItsBetaCallbackProjects)callback;
- (void) requestParamsByProject:(ItsBetaProject*)byProject callback:(ItsBetaCallbackParams)callback;
- (void) requestBadgesByProject:(ItsBetaProject*)byProject callback:(ItsBetaCallbackBadges)callback;
- (void) requestAchievementsByUser:(ItsBetaUser*)byUser byCategory:(ItsBetaCategory*)byCategory byProject:(ItsBetaProject*)byProject byBadges:(ItsBetaBadges*)byBadges callback:(ItsBetaCallbackAchievements)callback;
- (void) requestAchievementsByUser:(ItsBetaUser*)byUser byCategory:(ItsBetaCategory*)byCategory byProjects:(ItsBetaProjects*)byProjects byBadges:(ItsBetaBadges*)byBadges callback:(ItsBetaCallbackAchievements)callback;
- (void) requestAchievementsByUser:(ItsBetaUser*)byUser byCategories:(ItsBetaCategories*)byCategories byProjects:(ItsBetaProjects*)byProjects byBadges:(ItsBetaBadges*)byBadges callback:(ItsBetaCallbackAchievements)callback;
- (void) requestCreateAchievementByBadge:(ItsBetaBadge*)byBadge byParams:(NSDictionary*)byParams byExternalCode:(NSString*)byExternalCode callback:(ItsBetaCallbackCreateAchievement)callback;
- (void) requestInternalUserIDByUser:(ItsBetaUser*)byUser callback:(ItsBetaCallbackInternalID)callback;
- (void) requestAchievementAvailabilityByUser:(ItsBetaUser *)byUser byObjectTemplateId:(NSString*)byObjectTemplateId callback:(ItsBetaCallbackAchievementAviability)callback;
- (void) requestAchievementsAvailabilityByUser:(ItsBetaUser *)byUser byObjectTemplates:(ItsBetaBadges*)byObjectTemplates;
- (void) requestAchievementURLByAchievement:(NSString *)byAchievemntFBID byType:(NSString *)byType callback:(ItsBetaCallbackAchievementURL)callback;
- (void) requestBadgeTemplateByTypeID:(NSString*)byTypeID byProjectID:(NSString*)byProjectID callback:(ItsBetaCallBackBadge)callback;

@end

/*--------------------------------------------------*/

@interface ItsBetaUser : NSObject
{
@protected
    ItsBetaUserType mType; // Тип пользователя
    NSString* mID; // Уникальный ID пользователя
    NSString* mFaceBookID;  //ID в facebook
    NSDictionary< FBGraphUser >* mUserFB;
    BOOL mAchievementActivated;
}

@property(nonatomic, readonly) ItsBetaUserType type;
@property(nonatomic, readonly) NSString* typeAsString;
@property(nonatomic, retain) NSString* ID;
@property(nonatomic, readonly) NSString* faceBookID;
@property(nonatomic, retain) NSDictionary< FBGraphUser >* userFB;
@property(nonatomic) BOOL achievementActivated;

+ (ItsBetaUser*) userWithType:(ItsBetaUserType)type;

+ (ItsBetaUser*) sharedItsBetaUser;

- (id) initWithType:(ItsBetaUserType)type;

- (BOOL) isLogin;
- (void) login:(ItsBetaCallbackLogin)callback;
- (void) logout:(ItsBetaCallbackLogout)callback;

+ (BOOL) handleOpenURL:(NSURL*)url;

@end

/*--------------------------------------------------*/

@interface ItsBetaImage : NSObject {
@protected
    NSString* mFileName; // Удаленный путь до изображения
    NSString* mFileKey; // Локальный ключ изображения
#if TARGET_OS_IPHONE
    UIImage* mImageData;
#else
    NSImage* mImageData;
#endif
}

@property(nonatomic, readonly) NSString* fileName;
#if TARGET_OS_IPHONE
@property(nonatomic, readonly) UIImage* imageData;
#else
@property(nonatomic, readonly) NSImage* imageData;
#endif

+ (ItsBetaImage*) imageWithFileName:(NSString*)fileName;

- (id) initWithFileName:(NSString*)fileName;

- (void) loadWithOriginal:(ItsBetaCallbackLoadImage)callback;

@end

/*--------------------------------------------------*/

@interface ItsBetaCategory : NSObject {
}

@property(nonatomic, readonly) NSString* name; // Имя категории
@property(nonatomic, readonly) NSString* title; // Внешнее название категории

+ (ItsBetaCategory*) categoryWithDictionary:(NSDictionary*)dictionary;
+ (ItsBetaCategory*) categoryWithName:(NSString*)name title:(NSString*)title;

- (id) initWithName:(NSString*)name title:(NSString*)title;

@end

/*--------------------------------------------------*/

@interface ItsBetaCategories : NSObject {
}

@property(nonatomic, readonly) NSArray* list; // Массив категорий

+ (ItsBetaCategories*) categories;
+ (ItsBetaCategories*) categoriesWithCategory:(ItsBetaCategory*)category;

- (id) initWithCategory:(ItsBetaCategory*)category;

- (void) addCategory:(ItsBetaCategory*)category;
- (void) removeCategory:(ItsBetaCategory*)category;
- (void) removeCategoryByName:(NSString*)categoryName;
- (ItsBetaCategory*) categoryAtName:(NSString*)categoryName;
- (ItsBetaCategory*) categoryAt:(NSUInteger)index;

@end

/*--------------------------------------------------*/

@interface ItsBetaProject : NSObject {
}

@property(nonatomic, readonly) NSString* ID; // Уникальный ID проекта
@property(nonatomic, readonly) NSString* name; // Имя проекта
@property(nonatomic, readonly) NSString* title; // заголовок проекта

@property(nonatomic, readonly) ItsBetaCategory* category; // Указатель на категорию

+ (ItsBetaProject*) projectWithID:(NSString*)ID name:(NSString*)name title:(NSString*)title category:(ItsBetaCategory*)category;

- (id) initWithID:(NSString*)ID name:(NSString*)name title:(NSString*)title category:(ItsBetaCategory*)category;

@end

/*--------------------------------------------------*/

@interface ItsBetaProjects : NSObject {
}

@property(nonatomic, readonly) NSArray* list; // Массив проектов

+ (ItsBetaProjects*) projects;
+ (ItsBetaProjects*) projectsWithProject:(ItsBetaProject*)project;

- (id) initWithProject:(ItsBetaProject*)project;

- (void) addProject:(ItsBetaProject*)project;
- (void) removeProject:(ItsBetaProject*)project;
- (void) removeProjectByID:(NSString*)projectID;
- (ItsBetaProject*) projectAtID:(NSString*)projectID;
- (ItsBetaProject*) projectAt:(NSUInteger)index;

@end

/*--------------------------------------------------*/

typedef NSString ItsBetaParam;

/*--------------------------------------------------*/

@interface ItsBetaParams : NSObject {
}

@property(nonatomic, readonly) NSString* ID; // Уникальный ID спика параметров
@property(nonatomic, readonly) NSArray* keys; // Массив параметров

+ (ItsBetaParams*) paramsWithID:(NSString*)ID
                           keys:(NSArray*)keys;

- (id) initWithID:(NSString*)ID
             keys:(NSArray*)keys;

@end

/*--------------------------------------------------*/

@interface ItsBetaBadge : NSObject
{
@protected
    NSString* mID; // ID бейджа
    NSString* mName; // имя бейджа
    NSString* mTitle; // название бейджа
    NSString* mDescription; // описание бейджа
    NSString* mImageURL; // URL картинки бейджа
    
@protected
    ItsBetaProject* mProject; // Указатель на проект
    ItsBetaImage* mImage; // Указатель на изображение
}

@property(nonatomic, readonly) NSString* ID;
@property(nonatomic, readonly) NSString* name;
@property(nonatomic, readonly) NSString* title;
@property(nonatomic, readonly) NSString* description;
@property(nonatomic, readonly) NSString* imageURL;

@property(nonatomic, readonly) ItsBetaProject* project;
@property(nonatomic, readonly) ItsBetaImage* image;
@property(nonatomic) BOOL aviability;

+ (ItsBetaBadge*) badgeWithID:(NSString*)ID
                         name:(NSString*)name
                        title:(NSString*)title
                  description:(NSString*)description
                     imageURL:(NSString*)imageURL
                      project:(ItsBetaProject*)project;

- (id) initWithID:(NSString*)ID
             name:(NSString*)name
            title:(NSString*)title
      description:(NSString*)description
         imageURL:(NSString*)imageURL
          project:(ItsBetaProject*)project;

@end

/*--------------------------------------------------*/

@interface ItsBetaBadges : NSObject
{
@protected
    NSMutableArray* mList; // Массив бейджей
}

@property(nonatomic, readonly) NSArray* list;

+ (ItsBetaBadges*) sharedBadges;

- (void) addBadge:(ItsBetaBadge*)badge;
- (void) addBadge:(ItsBetaBadge*)newBadge replaceIfExist:(BOOL)replaceIfExist;
- (void) removeBadge:(ItsBetaBadge*)badge;
- (void) removeBadgeByID:(NSString*)badgeID;
- (ItsBetaBadge*) badgeAtID:(NSString*)badgeID;
- (ItsBetaBadge*) badgeAt:(NSUInteger)index;

@end

/*--------------------------------------------------*/

@interface ItsBetaAchievement : NSObject
{
@protected
    NSString* mID; // ID достижения
    NSString* mFaceBookID; // ID достижения на facebook
    NSString* mBadgeID; // ID бейджа
    NSString* mDetails; // Полное описание достижения (c учетом вставки параметров)
    BOOL mActivated; // Статус достижения
    
@protected
    ItsBetaUser* mUser; // Указатель на пользователя
    ItsBetaBadge* mBadge; // Указатель на бейдж
}

@property(nonatomic, readonly) NSString* ID;
@property(nonatomic, readonly) NSString* faceBookID;
@property(nonatomic, readonly) NSString* badgeID;
@property(nonatomic, readonly) NSString* details;
@property(nonatomic, readonly) BOOL activated;

@property(nonatomic, readonly) ItsBetaUser* user;
@property(nonatomic, readonly) ItsBetaBadge* badge;

+ (ItsBetaAchievement*) achievementWithID:(NSString*)ID
                               faceBookID:(NSString*)faceBookID
                                  badgeID:(NSString*)badgeID
                                  details:(NSString*)details
                                activated:(BOOL)activated
                                     user:(ItsBetaUser*)user
                                    badge:(ItsBetaBadge*)badge;

- (id) initWithID:(NSString*)ID
       faceBookID:(NSString*)faceBookID
          badgeID:(NSString*)badgeID
          details:(NSString*)details
        activated:(BOOL)activated
             user:(ItsBetaUser*)user
            badge:(ItsBetaBadge*)badge;

@end

/*--------------------------------------------------*/

@interface ItsBetaAchievements : NSObject
{
@protected
    NSMutableArray* mList; // Массив достидений
}

@property(nonatomic, readonly) NSArray* list;

+ (ItsBetaAchievements*) sharedItsBetaAchievements;
+ (ItsBetaAchievements*) achievements;

- (void) addAchievement:(ItsBetaAchievement*)achievement;
- (void) removeAchievement:(ItsBetaAchievement*)achievement;
- (void) removeAchievementByID:(NSString*)achievementID;
- (ItsBetaAchievement*) achievementAtID:(NSString*)achievementID;
- (ItsBetaAchievement*) achievementAt:(NSUInteger)index;

@end

/*--------------------------------------------------*/

extern ItsBeta* sharedItsBeta;
extern ItsBetaUser* sharedItsBetaUser;
extern ItsBetaBadges* sharedBadges;
extern NSArray* sharedBadgeTypeIDs;
extern ItsBetaAchievements* sharedItsBetaAchievements;

/*--------------------------------------------------*/
