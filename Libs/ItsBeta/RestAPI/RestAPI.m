/*--------------------------------------------------*/

#import "RestAPI.h"

/*--------------------------------------------------*/

@implementation RestAPIRequest

+ (RestAPIRequest*) requestWithMethod:(NSString*)method url:(NSString*)url query:(NSDictionary*)query {
    return NS_SAFE_AUTORELEASE([[self alloc] initWithMethod:method url:url headers:nil query:query]);
}

+ (RestAPIRequest*) requestWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query {
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

@implementation RestAPIConnection

@synthesize receivedData = mReceivedData;

+ (RestAPIConnection*) connectionWithMethod:(NSString*)method url:(NSString*)url success:(RestAPIConnectionSuccess)success failure:(RestAPIConnectionFailure)failure {
    return NS_SAFE_AUTORELEASE([[self alloc] initWithMethod:method url:url headers:nil query:nil success:success failure:failure]);
}

+ (RestAPIConnection*) connectionWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers success:(RestAPIConnectionSuccess)success failure:(RestAPIConnectionFailure)failure {
    return NS_SAFE_AUTORELEASE([[self alloc] initWithMethod:method url:url headers:headers query:nil success:success failure:failure]);
}

+ (RestAPIConnection*) connectionWithMethod:(NSString*)method url:(NSString*)url query:(NSDictionary*)query success:(RestAPIConnectionSuccess)success failure:(RestAPIConnectionFailure)failure {
    return NS_SAFE_AUTORELEASE([[self alloc] initWithMethod:method url:url headers:nil query:query success:success failure:failure]);
}

+ (RestAPIConnection*) connectionWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query success:(RestAPIConnectionSuccess)success failure:(RestAPIConnectionFailure)failure {
    return NS_SAFE_AUTORELEASE([[self alloc] initWithMethod:method url:url headers:headers query:query success:success failure:failure]);
}

- (id) initWithMethod:(NSString*)method url:(NSString*)url headers:(NSDictionary*)headers query:(NSDictionary*)query success:(RestAPIConnectionSuccess)success failure:(RestAPIConnectionFailure)failure {
    RestAPIRequest* request = [RestAPIRequest requestWithMethod:method url:url headers:headers query:query];
    self = [super initWithRequest:request delegate:self];
    if(self != nil) {
        mReceivedData = NS_SAFE_RETAIN([NSMutableData data]);
        mSuccess = Block_copy(success);
        mFailure = Block_copy(failure);
    }
    return self;
}

- (void) dealloc
{
    NS_SAFE_RELEASE(mReceivedData);
    Block_release(mSuccess);
    Block_release(mFailure);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [mReceivedData setLength:0];
}

- (void) connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    [mReceivedData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection*)connection {
    if(mSuccess != nil) {
        mSuccess(self);
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void) connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    if(mFailure != nil) {
        mFailure(self, error);
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end

/*--------------------------------------------------*/
