/*--------------------------------------------------*/

#import "ItsBeta.h"
#import "FastCache.h"
#import "RestAPI.h"

/*--------------------------------------------------*/

@implementation ItsBetaImage

@synthesize fileName = mFileName;
@synthesize imageData = mImageData;

+ (ItsBetaImage*) imageWithFileName:(NSString*)fileName
{
    return [[[self alloc] initWithFileName:fileName] autorelease];
}

- (id) initWithFileName:(NSString*)fileName
{
    self = [super init];
    if(self != nil)
    {
        mFileName = [fileName retain];
        mFileKey = [[NSString stringWithFormat:@"%X.%@", [fileName hash], [[mFileName pathExtension] stringByDeletingPathExtension]] retain];
        if([[FastCache sharedFastCache] hasCacheForKey:mFileKey] == YES)
        {
            mImageData = [[[FastCache sharedFastCache] imageForKey:mFileKey] retain];
        }
    }
    return self;
}

- (void) dealloc
{
    [mImageData release];
    [mFileKey release];
    [mFileName release];
    [super dealloc];
}

- (void) loadWithOriginal:(ItsBetaCallbackLoadImage)callback
{
    if(mImageData == nil)
    {
        [RestAPIConnection connectionWithMethod:@"GET"
                                            url:mFileName
                                        success:^(RestAPIConnection *connection) {
#if TARGET_OS_IPHONE
                                            mImageData = [[UIImage imageWithData:[connection receivedData]] retain];
#else
                                            mImageData = [[NSImage imageWithData:[connection receivedData]] retain];
#endif
                                            [[FastCache sharedFastCache] setImage:mImageData
                                                                           forKey:mFileKey];
                                            callback(self, nil);
                                        }
                                        failure:^(RestAPIConnection *connection, NSError *error) {
                                            callback(self, error);
                                        }];
    }
    else
    {
        callback(self, nil);
    }
}

@end

/*--------------------------------------------------*/
