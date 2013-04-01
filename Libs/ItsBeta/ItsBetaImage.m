/*--------------------------------------------------*/

#import "ItsBetaImage.h"
#import "ItsBetaFastCache.h"
#import "ItsBetaRest.h"
#import "ItsBetaQueue.h"
#import "ItsBetaApi.h"
#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaImage

+ (ItsBetaImage*) imageWithImageURL:(NSString*)imageURL {
    return NS_SAFE_RETAIN([[self alloc] initWithImageURL:imageURL]);
}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        _URL = NS_SAFE_RETAIN([coder decodeObjectForKey:@"url"]);
        _key = NS_SAFE_RETAIN([coder decodeObjectForKey:@"key"]);
    }
    return self;
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

- (void) encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:_URL forKey:@"url"];
    [coder encodeObject:_key forKey:@"key"];
}

- (BOOL) synchronizeSync {
    __block BOOL result = YES;
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
            } sendFailure:^(ItsBetaRest* rest, NSError* error) {
                result = NO;
            }];
        }
    }
    return result;
}

@end

/*--------------------------------------------------*/
