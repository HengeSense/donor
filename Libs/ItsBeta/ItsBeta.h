/*--------------------------------------------------*/

#import <Foundation/Foundation.h>

/*--------------------------------------------------*/

#if defined(TARGET_OS_IPHONE)
#   import <UIKit/UIKit.h>
#endif

/*--------------------------------------------------*/

#if __has_feature(objc_arc)
#   define NS_SAFE_AUTORELEASE(object)              object
#   define NS_SAFE_RETAIN(object)                   object
#   define NS_SAFE_RELEASE(object)                  object = nil
#else
#   define NS_SAFE_AUTORELEASE(object)              [object autorelease]
#   define NS_SAFE_RETAIN(object)                   [object retain]
#   define NS_SAFE_RELEASE(object)                  [object release]; object = nil
#endif

/*--------------------------------------------------*/

char* const ItsBetaDispatchQueue;
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
    ItsBetaPlayerTypeFacebook
};
typedef NSUInteger ItsBetaPlayerType;

/*--------------------------------------------------*/

@class ItsBetaPlayer;
@class ItsBetaCategory;
@class ItsBetaProject;
@class ItsBetaParams;
@class ItsBetaType;
@class ItsBetaTemplate;
@class ItsBetaObject;
@class ItsBetaImage;

/*--------------------------------------------------*/

typedef void (^ItsBetaCallbackLogin)(ItsBetaPlayer* user, NSError* error);
typedef void (^ItsBetaCallbackLogout)(ItsBetaPlayer* user, NSError* error);
typedef void (^ItsBetaCallbackPlayerIdWithUserId)(NSString* playerId, NSError* error);
typedef void (^ItsBetaCallbackCollection)(NSArray* array, NSError* error);
typedef void (^ItsBetaCallbackImage)(ItsBetaImage* image, NSError* error);

/*--------------------------------------------------*/

@interface ItsBeta : NSObject

@property(nonatomic, readwrite, retain) NSString* serviceURL; // Базовый URL сервиса
@property(nonatomic, readwrite, retain) NSString* accessToken; // Уникальный ключ доступа
@property(nonatomic, readwrite, retain) NSString* locale; // Язык

@property(nonatomic, readonly) NSArray* categories;
@property(nonatomic, readonly) NSArray* projects;
@property(nonatomic, readonly) NSArray* types;
@property(nonatomic, readonly) NSArray* templates;

@property(nonatomic, readonly) ItsBetaCategory* currentCategory;
@property(nonatomic, readonly) ItsBetaProject* currentProject;
@property(nonatomic, readonly) ItsBetaPlayer* currentPlayer;

+ (ItsBeta*) sharedItsBeta;

- (void) synchronize;

- (void) loginWithType:(ItsBetaPlayerType)type callback:(ItsBetaCallbackLogin)callback;
- (void) logout:(ItsBetaCallbackLogout)callback;

+ (void) itsBetaCategories:(ItsBetaCallbackCollection)callback;
+ (void) itsBetaProjectsByCategory:(ItsBetaCategory*)byCategory callback:(ItsBetaCallbackCollection)callback;
+ (void) itsBetaTypesByProject:(ItsBetaProject*)byProject callback:(ItsBetaCallbackCollection)callback;
+ (void) itsBetaTypesByProject:(ItsBetaProject*)byProject byParent:(ItsBetaType*)byParent callback:(ItsBetaCallbackCollection)callback;
+ (void) itsBetaTemplatesByType:(ItsBetaType*)byType callback:(ItsBetaCallbackCollection)callback;
+ (void) itsBetaTemplatesByType:(ItsBetaType*)byType byProject:(ItsBetaProject*)byProject callback:(ItsBetaCallbackCollection)callback;
+ (void) itsBetaObjectByPlayer:(ItsBetaPlayer*)byPlayer byTemplate:(ItsBetaTemplate*)byTemplate callback:(ItsBetaCallbackCollection)callback;

+ (void) itsBetaPlayerIdByFacebookId:(NSString*)byUserId callback:(ItsBetaCallbackPlayerIdWithUserId)callback;
+ (void) itsBetaPlayerIdByUserType:(ItsBetaPlayerType)userType byUserId:(NSString*)byUserId callback:(ItsBetaCallbackPlayerIdWithUserId)callback;

@end

/*--------------------------------------------------*/

@interface ItsBetaPlayer : NSObject

@property(nonatomic, readonly) ItsBetaPlayerType type; // Тип пользователя
@property(nonatomic, readonly) NSString* Id; // Уникальный Id пользователя
@property(nonatomic, readonly) NSString* facebookId; //Id в facebook

@property(nonatomic, readonly) NSArray* objects;

+ (ItsBetaPlayer*) userWithType:(ItsBetaPlayerType)type;

- (id) initWithType:(ItsBetaPlayerType)type;

- (void) synchronize;

- (BOOL) isLogin;
- (void) login:(ItsBetaCallbackLogin)callback;
- (void) loginWithFacebookId:(NSString*)facebookId callback:(ItsBetaCallbackLogin)callback;
- (void) logout:(ItsBetaCallbackLogout)callback;

+ (NSString*) stringWithPlayerType:(ItsBetaPlayerType)playerType;

@end

/*--------------------------------------------------*/

@interface ItsBetaCategory : NSObject

@property(nonatomic, readonly) NSString* name; // Имя категории
@property(nonatomic, readonly) NSString* title; // Внешнее название категории
@property(nonatomic, readonly) NSString* locale; // Язык

+ (ItsBetaCategory*) categoryWithDictionary:(NSDictionary*)dictionary;

- (id) initWithDictionary:(NSDictionary*)dictionary;

@end

/*--------------------------------------------------*/

@interface ItsBetaProject : NSObject

@property(nonatomic, readonly) NSString* Id; // Уникальный Id проекта
@property(nonatomic, readonly) NSString* name; // Имя проекта
@property(nonatomic, readonly) NSString* categoryName; // Имя категории
@property(nonatomic, readonly) NSString* title; // Заголовок проекта
#if TARGET_OS_IPHONE
@property(nonatomic, readonly) UIColor* color; // Цвет проекта
#else
@property(nonatomic, readonly) CLColor* color; // Цвет проекта
#endif

+ (ItsBetaProject*) projectWithDictionary:(NSDictionary*)dictionary;

- (id) initWithDictionary:(NSDictionary*)dictionary;

@end

/*--------------------------------------------------*/

@interface ItsBetaParams : NSObject

@property(nonatomic, readonly) NSDictionary* dictionary;

+ (ItsBetaParams*) paramsWithArray:(NSArray*)array;

- (id) initWithArray:(NSArray*)array;

@end

/*--------------------------------------------------*/

@interface ItsBetaType : NSObject

@property(nonatomic, readonly) NSString* Id; // Id типа
@property(nonatomic, readonly) NSString* name; // имя типа
@property(nonatomic, readonly) NSString* projectId; // Id проекта
@property(nonatomic, readonly) NSString* parentId; // Id родительского типа
@property(nonatomic, readonly) ItsBetaParams* internal; // Внутриние параметры
@property(nonatomic, readonly) ItsBetaParams* external; // Внешние параметры
@property(nonatomic, readonly) ItsBetaParams* shared; // Общие параметры

@property(nonatomic, readonly) NSNumber* templateCount; // Кол-во шаблонов в типе

+ (ItsBetaType*) typeWithDictionary:(NSDictionary*)dictionary;

- (id) initWithDictionary:(NSDictionary*)dictionary;

@end

/*--------------------------------------------------*/

@interface ItsBetaTemplate : NSObject

@property(nonatomic, readonly) NSString* Id; // Id шаблона
@property(nonatomic, readonly) NSString* name; // имя шаблона
@property(nonatomic, readonly) NSString* projectId; // Id проекта
@property(nonatomic, readonly) NSString* typeId; //  Id типа
@property(nonatomic, readonly) NSString* imageURL; // URL изображения
@property(nonatomic, readonly) ItsBetaParams* internal; // Внутриние параметры
@property(nonatomic, readonly) ItsBetaParams* shared; // Общие параметры

@property(nonatomic, readonly) NSNumber* objectCount; // Кол-во объектов в шаблоне

@property(nonatomic, readonly) ItsBetaImage* image;

+ (ItsBetaTemplate*) templateWithDictionary:(NSDictionary*)dictionary;

- (id) initWithDictionary:(NSDictionary*)dictionary;

@end

/*--------------------------------------------------*/

@interface ItsBetaObject : NSObject

@property(nonatomic, readonly) NSString* Id; // Id обьекта
@property(nonatomic, readonly) NSString* name; // имя обьекта
@property(nonatomic, readonly) ItsBetaParams* external; // Внешние параметры

+ (ItsBetaObject*) objectWithDictionary:(NSDictionary*)dictionary;

- (id) initWithDictionary:(NSDictionary*)dictionary;

@end

/*--------------------------------------------------*/

@interface ItsBetaImage : NSObject

@property(nonatomic, readonly) NSString* URL; // Удаленный путь до изображения
@property(nonatomic, readonly) NSString* key; // Локальный ключ изображения
#if TARGET_OS_IPHONE
@property(nonatomic, readonly) UIImage* data; // Изображение
#else
@property(nonatomic, readonly) NSImage* data; // Изображение
#endif

+ (ItsBetaImage*) imageWithImageURL:(NSString*)imageURL;

- (id) initWithImageURL:(NSString*)imageURL;

- (void) synchronize:(ItsBetaCallbackImage)callback;

@end

/*--------------------------------------------------*/

extern ItsBeta* sharedItsBeta;

/*--------------------------------------------------*/
