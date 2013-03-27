/*--------------------------------------------------*/

#import <Foundation/Foundation.h>

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

@interface RestAPIRequest : NSMutableURLRequest

+ (RestAPIRequest*) requestWithMethod:(NSString*)method url:(NSString*)url query:(NSDictionary*)query;
+ (RestAPIRequest*) requestWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query;

- (id) initWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query;

@end

/*--------------------------------------------------*/

@class RestAPIConnection;

/*--------------------------------------------------*/

typedef void (^RestAPIConnectionSuccess)(RestAPIConnection* connection);
typedef void (^RestAPIConnectionFailure)(RestAPIConnection* connection, NSError* error);

/*--------------------------------------------------*/

@interface RestAPIConnection : NSURLConnection< NSURLConnectionDelegate, NSURLConnectionDataDelegate > {
@protected
    NSMutableData* mReceivedData;
    RestAPIConnectionSuccess mSuccess;
    RestAPIConnectionFailure mFailure;
}

@property (nonatomic, readonly) NSData* receivedData;

+ (RestAPIConnection*) connectionWithMethod:(NSString*)method url:(NSString*)url success:(RestAPIConnectionSuccess)success failure:(RestAPIConnectionFailure)failure;
+ (RestAPIConnection*) connectionWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers success:(RestAPIConnectionSuccess)success failure:(RestAPIConnectionFailure)failure;
+ (RestAPIConnection*) connectionWithMethod:(NSString*)method url:(NSString*)url query:(NSDictionary*)query success:(RestAPIConnectionSuccess)success failure:(RestAPIConnectionFailure)failure;
+ (RestAPIConnection*) connectionWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query success:(RestAPIConnectionSuccess)success failure:(RestAPIConnectionFailure)failure;

- (id) initWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query success:(RestAPIConnectionSuccess)success failure:(RestAPIConnectionFailure)failure;

@end

/*--------------------------------------------------*/
