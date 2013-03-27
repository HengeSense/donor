/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

#import "ItsBetaFastCache.h"
#import "ItsBetaRestAPI.h"

/*--------------------------------------------------*/

@implementation ItsBetaImage

+ (ItsBetaImage*) imageWithImageURL:(NSString*)imageURL {
    return NS_SAFE_RETAIN([[self alloc] initWithImageURL:imageURL]);
}

- (id) initWithImageURL:(NSString*)imageURL {
    self = [super init];
    if(self != nil) {
        _URL = NS_SAFE_RETAIN(imageURL);
        _key = NS_SAFE_RETAIN([[ItsBetaFastCache sharedItsBetaFastCache] keyWithFilename:imageURL]);
    }
    return self;
}

- (void) dealloc {
    NS_SAFE_RELEASE(_URL);
    NS_SAFE_RELEASE(_key);
    NS_SAFE_RELEASE(_data);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) synchronize:(ItsBetaCallbackImage)callback {
    if(_data == nil) {
        if([[ItsBetaFastCache sharedItsBetaFastCache] hasCacheForKey:_key] == YES) {
            _data = NS_SAFE_RETAIN([[ItsBetaFastCache sharedItsBetaFastCache] imageForKey:_key]);
        }
        if(_data == nil) {
            [RestAPIConnection connectionWithMethod:@"GET"
                                                url:_URL
                                            success:^(RestAPIConnection *connection) {
#if TARGET_OS_IPHONE
                                                _data = NS_SAFE_RETAIN([UIImage imageWithData:[connection receivedData]]);
#else
                                                _data = NS_SAFE_RETAIN([NSImage imageWithData:[connection receivedData]]);
#endif
                                                [[ItsBetaFastCache sharedItsBetaFastCache] setImage:_data forKey:_key];
                                                callback(self, nil);
                                            }
                                            failure:^(RestAPIConnection *connection, NSError *error) {
                                                callback(self, error);
                                            }];
        } else {
            callback(self, nil);
        }
    } else {
        callback(self, nil);
    }
}

@end

/*--------------------------------------------------*/
