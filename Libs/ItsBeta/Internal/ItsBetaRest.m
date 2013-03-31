/*--------------------------------------------------*/

#import "ItsBetaRest.h"

/*--------------------------------------------------*/

@interface ItsBetaRestRequest : NSMutableURLRequest

+ (ItsBetaRestRequest*) requestWithMethod:(NSString*)method url:(NSString*)url query:(NSDictionary*)query;
+ (ItsBetaRestRequest*) requestWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query;

- (id) initWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query;

@end

/*--------------------------------------------------*/

@implementation ItsBetaRestRequest

+ (ItsBetaRestRequest*) requestWithMethod:(NSString*)method url:(NSString*)url query:(NSDictionary*)query {
    return NS_SAFE_AUTORELEASE([[self alloc] initWithMethod:method url:url headers:nil query:query]);
}

+ (ItsBetaRestRequest*) requestWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query {
    return NS_SAFE_AUTORELEASE([[self alloc] initWithMethod:method url:url headers:headers query:query]);
}

- (id) initWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query {
    if([method isEqualToString:@"GET"] == YES) {
        if(query != nil) {
            NSMutableArray *getQuery = [NSMutableArray arrayWithCapacity:128];
            if(getQuery != nil) {
                [query enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                     [getQuery addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
                     *stop = NO;
                 }];
                url = [NSString stringWithFormat:@"%@?%@", url, [getQuery componentsJoinedByString:@"&"]];
            }
        }
    }
    self = [super initWithURL:[NSURL URLWithString:url]];
    if(self != nil) {
        [self setHTTPMethod:method];
        if(headers != nil) {
            [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                 [self setValue:obj forHTTPHeaderField:key];
                 *stop = NO;
             }];
        }
        if([method isEqualToString:@"POST"] == YES) {
            if(query != nil) {
                NSMutableArray *postQuery = [NSMutableArray arrayWithCapacity:128];
                if(postQuery != nil) {
                    [query enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                         [postQuery addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
                         *stop = NO;
                     }];
                    NSString* postBody = [postQuery componentsJoinedByString:@"&"];
                    if(postBody != nil) {
                        [self setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
                    }
                }
            }
        }
    }
    return self;
}

@end

/*--------------------------------------------------*/

@implementation ItsBetaRest

+ (ItsBetaRest*) restWithMethod:(NSString*)method url:(NSString*)url {
    return NS_SAFE_AUTORELEASE([[self alloc] initWithMethod:method url:url headers:nil query:nil]);
}

+ (ItsBetaRest*) restWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers {
    return NS_SAFE_AUTORELEASE([[self alloc] initWithMethod:method url:url headers:headers query:nil]);
}

+ (ItsBetaRest*) restWithMethod:(NSString*)method url:(NSString*)url query:(NSDictionary*)query {
    return NS_SAFE_AUTORELEASE([[self alloc] initWithMethod:method url:url headers:nil query:query]);
}

+ (ItsBetaRest*) restWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query {
    return NS_SAFE_AUTORELEASE([[self alloc] initWithMethod:method url:url headers:headers query:query]);
}

- (id) initWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query {
    self = [super init];
    if(self != nil) {
        _request = NS_SAFE_RETAIN([ItsBetaRestRequest requestWithMethod:method url:url headers:headers query:query]);
    }
    return self;
}

- (void) dealloc {
    NS_SAFE_RELEASE(_receivedData);
    NS_SAFE_RELEASE(_request);
    NS_SAFE_RELEASE(_response);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) sendSuccess:(ItsBetaRestSuccess)success sendFailure:(ItsBetaRestFailure)failure {
    NSURLResponse* response = nil;
    NSError* error = nil;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    _receivedData = NS_SAFE_RETAIN([NSURLConnection sendSynchronousRequest:_request returningResponse:&response error:&error]);
    _response = NS_SAFE_RETAIN(response);
    if(error == nil) {
        if(success != nil) {
            success(self);
        }
    } else {
        if(failure != nil) {
            failure(self, error);
        }
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end

/*--------------------------------------------------*/
