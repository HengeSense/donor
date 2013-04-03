/*--------------------------------------------------*/

#import "ItsBetaObject.h"

/*--------------------------------------------------*/

typedef void (^ItsBetaPlayerLogin)(NSError* error);
typedef void (^ItsBetaPlayerLogout)(NSError* error);

/*--------------------------------------------------*/

@interface ItsBetaPlayer : NSObject< NSCoding >

@property(nonatomic, readwrite) ItsBetaPlayerType type; // Тип пользователя
@property(nonatomic, readonly) NSString* Id; // Уникальный Id пользователя
@property(nonatomic, readonly) NSString* facebookId; // Id в facebook
@property(nonatomic, readonly) NSString* facebookToken; // facebook access token

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
- (void) loginWithFacebookId:(NSString*)facebookId facebookToken:(NSString*)facebookToken callback:(ItsBetaPlayerLogin)callback;

- (void) logout:(ItsBetaPlayerLogout)callback;

+ (BOOL) handleOpenURL:(NSURL*)url;

@end

/*--------------------------------------------------*/
