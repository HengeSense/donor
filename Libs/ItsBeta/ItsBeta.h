/*--------------------------------------------------*/

#import "ItsBetaCore.h"

/*--------------------------------------------------*/

#import "ItsBetaApplication.h"
#import "ItsBetaPlayer.h"
#import "ItsBetaCategory.h"
#import "ItsBetaProject.h"
#import "ItsBetaParams.h"
#import "ItsBetaObjectType.h"
#import "ItsBetaObjectTemplate.h"
#import "ItsBetaObject.h"
#import "ItsBetaImage.h"

/*--------------------------------------------------*/

typedef void (^ItsBetaLogin)(ItsBetaPlayer* player, NSError* error);
typedef void (^ItsBetaLogout)(ItsBetaPlayer* player, NSError* error);
typedef void (^ItsBetaCreateAchievement)(ItsBetaPlayer* player, NSString* activateCode, NSError* error);
typedef void (^ItsBetaActivateAchievement)(ItsBetaPlayer* player, NSString* object_id, NSError* error);
typedef void (^ItsBetaGiveAchievement)(ItsBetaPlayer* player, NSString* object_id, NSError* error);

/*--------------------------------------------------*/

@interface ItsBeta : NSObject< NSCoding >

@property(nonatomic, readonly) ItsBetaApplication* application;
@property(nonatomic, readonly) ItsBetaPlayer* player;

+ (ItsBeta*) sharedItsBeta;

+ (void) setApplicationServiceURL:(NSString*)serviceURL;
+ (NSString*) applicationServiceURL;

+ (void) setApplicationAccessToken:(NSString*)accessToken;
+ (NSString*) applicationAccessToken;

+ (void) setApplicationProjectWhiteList:(NSArray*)projectWhiteList;
+ (NSArray*) applicationProjectWhiteList;

+ (void) setApplicationProjectBlackList:(NSArray*)projectBlackList;
+ (NSArray*) applicationProjectBlackList;

+ (ItsBetaCategory*) categoryByName:(NSString*)name;
+ (ItsBetaProject*) projectById:(NSString*)Id;
+ (ItsBetaProject*) projectByName:(NSString*)name;
+ (ItsBetaObjectType*) objectTypeById:(NSString*)Id byProject:(ItsBetaProject*)project;
+ (ItsBetaObjectType*) objectTypeByName:(NSString*)name byProject:(ItsBetaProject*)project;
+ (ItsBetaObjectTemplate*) objectTemplateById:(NSString*)Id byProject:(ItsBetaProject*)project;
+ (ItsBetaObjectTemplate*) objectTemplateByName:(NSString*)name byProject:(ItsBetaProject*)project;
+ (ItsBetaObject*) objectById:(NSString*)Id;
+ (ItsBetaObject*) objectById:(NSString*)Id byPlayer:(ItsBetaPlayer*)player;
+ (ItsBetaObjectCollection*) objectsWithObjectTemplate:(ItsBetaObjectTemplate*)objectTemplate;
+ (ItsBetaObjectCollection*) objectsWithObjectTemplate:(ItsBetaObjectTemplate*)objectTemplate byPlayer:(ItsBetaPlayer*)player;

+ (BOOL) playerLogined;
#if defined(TARGET_OS_IPHONE)
+ (void) playerLoginFacebookWithViewController:(UIViewController*)viewController callback:(ItsBetaLogin)callback;
#else
+ (void) playerLoginFacebookWithViewController:(NSViewController*)viewController callback:(ItsBetaLogin)callback;
#endif
+ (void) playerLogout:(ItsBetaLogout)callback;

+ (void) playerCreateAchievementWithProject:(ItsBetaProject*)project objectTemplate:(ItsBetaObjectTemplate*)objectTemplate params:(NSDictionary*)params callback:(ItsBetaCreateAchievement)callback;
+ (void) playerActivateAchievementWithProject:(ItsBetaProject*)project activateCode:(NSString*)activateCode callback:(ItsBetaActivateAchievement)callback;
+ (void) playerGiveAchievementWithProject:(ItsBetaProject*)project objectTemplate:(ItsBetaObjectTemplate*)objectTemplate params:(NSDictionary*)params callback:(ItsBetaGiveAchievement)callback;

+ (void) synchronizeApplication;
+ (void) synchronizePlayerWithProject:(ItsBetaProject*)project;

+ (BOOL) handleOpenURL:(NSURL*)url;

@end

/*--------------------------------------------------*/

extern ItsBeta* sharedItsBeta;

/*--------------------------------------------------*/
