/*--------------------------------------------------*/

#import "ItsBeta.h"

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
    NSMutableData* _receivedData;
}

@property (nonatomic, readonly) NSData* receivedData;
@property (nonatomic, readwrite, copy) RestAPIConnectionSuccess success;
@property (nonatomic, readwrite, copy) RestAPIConnectionFailure failure;

+ (RestAPIConnection*) connectionWithMethod:(NSString*)method url:(NSString*)url success:(RestAPIConnectionSuccess)success failure:(RestAPIConnectionFailure)failure;
+ (RestAPIConnection*) connectionWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers success:(RestAPIConnectionSuccess)success failure:(RestAPIConnectionFailure)failure;
+ (RestAPIConnection*) connectionWithMethod:(NSString*)method url:(NSString*)url query:(NSDictionary*)query success:(RestAPIConnectionSuccess)success failure:(RestAPIConnectionFailure)failure;
+ (RestAPIConnection*) connectionWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query success:(RestAPIConnectionSuccess)success failure:(RestAPIConnectionFailure)failure;

- (id) initWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query success:(RestAPIConnectionSuccess)success failure:(RestAPIConnectionFailure)failure;

@end

/*--------------------------------------------------*/
