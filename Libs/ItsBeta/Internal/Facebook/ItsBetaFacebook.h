/*--------------------------------------------------*/

#import "ItsBetaCore.h"

/*--------------------------------------------------*/
#if defined(TARGET_OS_IPHONE)
/*--------------------------------------------------*/

@protocol ItsBetaGraphUser;

/*--------------------------------------------------*/

typedef void (^ItsBetaFacebookSuccessCallback)(NSString* accessToken, NSDictionary< ItsBetaGraphUser >* user);
typedef void (^ItsBetaFacebookFailureCallback)(NSError* error);

/*--------------------------------------------------*/

@interface ItsBetaFacebook : UIViewController< UIWebViewDelegate > {
}

@property (retain, nonatomic) IBOutlet UIWebView* webView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

@property (nonatomic, retain) UIViewController* parentController;

@property (nonatomic, retain) NSString* clientId;
@property (nonatomic, retain) NSString* redirectURL;
@property (nonatomic, retain) NSArray* scope;
@property (nonatomic, copy) ItsBetaFacebookSuccessCallback successCallback;
@property (nonatomic, copy) ItsBetaFacebookFailureCallback failureCallback;

- (void) request;

@end

/*--------------------------------------------------*/
#endif
/*--------------------------------------------------*/
