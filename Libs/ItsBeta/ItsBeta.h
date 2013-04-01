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

@interface ItsBeta : NSObject< NSCoding >

@property(nonatomic, readonly) ItsBetaApplication* application;
@property(nonatomic, readonly) ItsBetaPlayer* player;

+ (ItsBeta*) sharedItsBeta;

+ (void) setApplicationServiceURL:(NSString*)serviceURL;
+ (NSString*) applicationServiceURL;

+ (void) setApplicationAccessToken:(NSString*)accessToken;
+ (NSString*) applicationAccessToken;

+ (void) setApplicationDelegate:(id< ItsBetaApplicationDelegate >)delegate;
+ (id< ItsBetaApplicationDelegate >) applicationDelegate;

+ (void) synchronizeApplication;

@end

/*--------------------------------------------------*/

extern ItsBeta* sharedItsBeta;

/*--------------------------------------------------*/
