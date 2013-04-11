/*--------------------------------------------------*/

#import "ItsBetaObject.h"

/*--------------------------------------------------*/

#if defined(ITSBETA_USE_FACEBOOK_OFFICIAL_SDK)
#   import <FacebookSDK/FacebookSDK.h>
#else
#   import "ItsBetaGraphUser.h"
#   import "ItsBetaFacebookIPhone.h"
#   import "ItsBetaFacebookIPad.h"
#endif

/*--------------------------------------------------*/

typedef void (^ItsBetaPlayerLogin)(NSError* error);
typedef void (^ItsBetaPlayerLogout)(NSError* error);
typedef void (^ItsBetaPlayerCreateAchievement)(NSString* activateCode, NSError* error);
typedef void (^ItsBetaPlayerActivateAchievement)(NSString* object_id, NSError* error);
typedef void (^ItsBetaPlayerGiveAchievement)(NSString* object_id, NSError* error);

/*--------------------------------------------------*/

@interface ItsBetaPlayer : NSObject< NSCoding >

@property(nonatomic, readwrite) ItsBetaPlayerType type; // Тип пользователя
@property(nonatomic, readwrite) NSString* typeString; // Тип пользователя в виде строки
@property(nonatomic, readonly) NSString* Id; // Уникальный Id пользователя
@property(nonatomic, readonly) NSString* facebookId; // Id в facebook
@property(nonatomic, readonly) NSString* facebookToken; // facebook access token
@property(nonatomic, readonly) NSDictionary <ItsBetaGraphUser>* graphUser; // Объект 

@property(nonatomic, readonly) ItsBetaObjectCollection* objects;

+ (ItsBetaPlayer*) playerWithType:(ItsBetaPlayerType)type;

- (id) initWithType:(ItsBetaPlayerType)type;

- (BOOL) synchronizeWithProject:(ItsBetaProject*)project;

- (BOOL) isLogined;

#if defined(TARGET_OS_IPHONE)
- (void) loginWithViewController:(UIViewController*)viewController callback:(ItsBetaPlayerLogin)callback;
#else
- (void) loginWithViewController:(NSViewController*)viewController callback:(ItsBetaPlayerLogin)callback;
#endif
- (void) loginWithFacebookId:(NSString*)facebookId facebookToken:(NSString*)facebookToken graphUser:(NSDictionary<ItsBetaGraphUser>*)graphUser callback:(ItsBetaPlayerLogin)callback;
- (void) logout:(ItsBetaPlayerLogout)callback;

- (void) createAchievementWithProject:(ItsBetaProject*)project objectTemplate:(ItsBetaObjectTemplate*)objectTemplate params:(NSDictionary*)params callback:(ItsBetaPlayerCreateAchievement)callback;
- (void) activateAchievementWithProject:(ItsBetaProject*)project activateCode:(NSString*)activateCode callback:(ItsBetaPlayerActivateAchievement)callback;
- (void) giveAchievementWithProject:(ItsBetaProject*)project objectTemplate:(ItsBetaObjectTemplate*)objectTemplate params:(NSDictionary*)params callback:(ItsBetaPlayerGiveAchievement)callback;

+ (BOOL) handleOpenURL:(NSURL*)url;

@end

/*--------------------------------------------------*/
