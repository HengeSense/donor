/*--------------------------------------------------*/

#import <Foundation/Foundation.h>

/*--------------------------------------------------*/

#if defined(TARGET_OS_IPHONE)
#   import <UIKit/UIKit.h>
#else
#   import <AppKit/AppKit.h>
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
#define NS_SAFE_SETTER(object, value)               NS_SAFE_RELEASE(object); object = value; object = NS_SAFE_RETAIN(object)

/*--------------------------------------------------*/

NSString* const ItsBetaErrorDomain;

/*--------------------------------------------------*/

NSString* const ItsBetaWillApplicationSynchronize;
NSString* const ItsBetaDidApplicationSynchronize;
NSString* const ItsBetaWillPlayerSynchronize;
NSString* const ItsBetaDidPlayerSynchronize;
NSString* const ItsBetaWillPlayerLogin;
NSString* const ItsBetaDidPlayerLogin;
NSString* const ItsBetaWillPlayerLogout;
NSString* const ItsBetaDidPlayerLogout;

/*--------------------------------------------------*/

typedef enum {
    ItsBetaErrorInternal,
    ItsBetaErrorResponse,
    ItsBetaErrorExpiredToken,
    ItsBetaErrorFacebookAuth
} ItsBetaError;

/*--------------------------------------------------*/

typedef enum {
    ItsBetaPlayerTypeUnknown,
    ItsBetaPlayerTypeFacebook
} ItsBetaPlayerType;

/*--------------------------------------------------*/

@protocol ItsBetaApplicationDelegate;

/*--------------------------------------------------*/

@class ItsBetaApplication;
@class ItsBetaPlayer;

/*--------------------------------------------------*/

@class ItsBetaCategory;
@class ItsBetaCategoryCollection;
@class ItsBetaProject;
@class ItsBetaProjectCollection;

/*--------------------------------------------------*/

@class ItsBetaParams;

/*--------------------------------------------------*/

@class ItsBetaObjectType;
@class ItsBetaObjectTypeCollection;
@class ItsBetaObjectTemplate;
@class ItsBetaObjectTemplateCollection;
@class ItsBetaObject;
@class ItsBetaObjectCollection;

/*--------------------------------------------------*/

@class ItsBetaImage;

/*--------------------------------------------------*/
