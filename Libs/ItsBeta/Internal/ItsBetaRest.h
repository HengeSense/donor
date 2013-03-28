/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@class ItsBetaRest;

/*--------------------------------------------------*/

typedef void (^ItsBetaRestSuccess)(ItsBetaRest* rest);
typedef void (^ItsBetaRestFailure)(ItsBetaRest* rest, NSError* error);

/*--------------------------------------------------*/

@interface ItsBetaRest : NSObject {
}

@property (nonatomic, readonly) NSURLRequest* request;
@property (nonatomic, readonly) NSURLResponse* response;
@property (nonatomic, readonly) NSData* receivedData;

+ (ItsBetaRest*) restWithMethod:(NSString*)method url:(NSString*)url;
+ (ItsBetaRest*) restWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers;
+ (ItsBetaRest*) restWithMethod:(NSString*)method url:(NSString*)url query:(NSDictionary*)query;
+ (ItsBetaRest*) restWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query;

- (id) initWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query;

- (void) sendSuccess:(ItsBetaRestSuccess)success sendFailure:(ItsBetaRestFailure)failure;

@end

/*--------------------------------------------------*/
