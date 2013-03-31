/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

#import "ItsBetaFastCache.h"
#import "ItsBetaRest.h"

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
            ItsBetaRest* rest = [ItsBetaRest restWithMethod:@"GET" url:_URL];
            [rest sendSuccess:^(ItsBetaRest* rest) {
#if TARGET_OS_IPHONE
                _data = NS_SAFE_RETAIN([UIImage imageWithData:[rest receivedData]]);
#else
                _data = NS_SAFE_RETAIN([NSImage imageWithData:[rest receivedData]]);
#endif
                [[ItsBetaFastCache sharedItsBetaFastCache] setImage:_data forKey:_key];
                if(callback != nil) {
                    callback(self, nil);
                }
            } sendFailure:^(ItsBetaRest* rest, NSError *error) {
                if(callback != nil) {
                    callback(self, error);
                }
            }];
        } else {
            if(callback != nil) {
                callback(self, nil);
            }
        }
    } else {
        if(callback != nil) {
            callback(self, nil);
        }
    }
}

@end

/*--------------------------------------------------*/
