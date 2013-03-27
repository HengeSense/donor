/*--------------------------------------------------*/

#import "ItsBetaFastCache.h"

/*--------------------------------------------------*/

static inline NSString* cachePathForKey(NSString* directory, NSString* key) {
    return [directory stringByAppendingPathComponent:key];
}

/*--------------------------------------------------*/

@implementation ItsBetaFastCache

@synthesize defaultTimeout = mDefaultTimeout;
@synthesize frozenCacheInfo = mFrozenCacheInfo;

+ (ItsBetaFastCache*) sharedItsBetaFastCache {
    if(sharedItsBetaFastCache == nil) {
        @synchronized(self) {
            if(sharedItsBetaFastCache == nil) {
                sharedItsBetaFastCache = [[self alloc] init];
            }
        }
    }
    return sharedItsBetaFastCache;
}

- (id) init {
    NSString* cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString* oldCachesDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"FastCache"] copy];
    if([[NSFileManager defaultManager] fileExistsAtPath:oldCachesDirectory]) {
        [[NSFileManager defaultManager] removeItemAtPath:oldCachesDirectory error:NULL];
    }
    cachesDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"FastCache"] copy];
    return [self initWithCacheDirectory:cachesDirectory];
}

- (id) initWithCacheDirectory:(NSString*)cacheDirectory {
    if((self = [super init])) {
        mDirectory = NS_SAFE_RETAIN(cacheDirectory);
        mDefaultTimeout = 86400;
        
        mCacheInfoQueue = dispatch_queue_create("fastcache", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_t priority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_set_target_queue(priority, mCacheInfoQueue);

        mFrozenCacheInfoQueue = dispatch_queue_create("fastcache.frozen", DISPATCH_QUEUE_SERIAL);
        priority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_set_target_queue(priority, mFrozenCacheInfoQueue);

        mDiskQueue = dispatch_queue_create("fastcache.disk", DISPATCH_QUEUE_CONCURRENT);
        priority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        dispatch_set_target_queue(priority, mCacheInfoQueue);

        mCacheInfo = [[NSDictionary dictionaryWithContentsOfFile:cachePathForKey(mDirectory, @"fastcache.plist")] mutableCopy];
        if(mCacheInfo == nil) {
            mCacheInfo = [[NSMutableDictionary alloc] init];
        }
        [[NSFileManager defaultManager] createDirectoryAtPath:mDirectory withIntermediateDirectories:YES attributes:nil error:NULL];

        NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
        NSMutableArray* removedKeys = [[NSMutableArray alloc] init];
        for(NSString* key in mCacheInfo) {
            if([mCacheInfo[key] timeIntervalSinceReferenceDate] <= now) {
                [[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(mDirectory, key) error:NULL];
                [removedKeys addObject:key];
            }
        }
        [mCacheInfo removeObjectsForKeys:removedKeys];
        [self setFrozenCacheInfo:mCacheInfo];
    }
    return self;
}

- (void) dealloc {
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) clearCache {
    dispatch_sync(mCacheInfoQueue, ^{
        for(NSString* key in mCacheInfo) {
            [[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(mDirectory, key) error:NULL];
        }
        [mCacheInfo removeAllObjects];
        dispatch_sync(mFrozenCacheInfoQueue, ^{
            [self setFrozenCacheInfo:[mCacheInfo copy]];
        });
        [self setNeedsSave];
    });
}

- (BOOL) hasCacheForKey:(NSString*)key {
    __block NSDate* date = nil;
    dispatch_sync(mFrozenCacheInfoQueue, ^{
        date = mCacheInfo[key];
    });
    if(date != nil) {
        if([date compare:[NSDate date]] == NSOrderedDescending) {
            return [[NSFileManager defaultManager] fileExistsAtPath:cachePathForKey(mDirectory, key)];
        }
    }
    return NO;
}

- (void) removeCacheForKey:(NSString*)key {
    if([key isEqualToString:@"fastcache.plist"] == YES) {
#if DEBUG
        NSLog(@"fastcache.plist is a reserved key and can not be modified.");
#endif
        return;
    }
    dispatch_async(mDiskQueue, ^{
        [[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(mDirectory, key) error:NULL];
    });
    [self setCacheTimeoutInterval:0 forKey:key];
}

- (void) setCacheTimeoutInterval:(NSTimeInterval)timeout forKey:(NSString*)key {
    NSDate* date = ((timeout > 0) ? [NSDate dateWithTimeIntervalSinceNow:timeout] : nil);
    dispatch_sync(mFrozenCacheInfoQueue, ^{
        NSMutableDictionary* info = [mCacheInfo mutableCopy];
        if(date != nil) {
            info[key] = date;
        } else {
            [info removeObjectForKey:key];
        }
        [self setFrozenCacheInfo:info];
    });
    dispatch_async(mCacheInfoQueue, ^{
        if(date) {
            mCacheInfo[key] = date;
        } else {
            [mCacheInfo removeObjectForKey:key];
        }
        dispatch_sync(mFrozenCacheInfoQueue, ^{
            [self setFrozenCacheInfo:[mCacheInfo copy]];
        });
        [self setNeedsSave];
    });
}

- (void) setNeedsSave {
    dispatch_async(mCacheInfoQueue, ^{
        if(mNeedsSave == NO) {
            mNeedsSave = YES;
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, mCacheInfoQueue, ^(void){
                if(mNeedsSave == YES) {
                    [mCacheInfo writeToFile:cachePathForKey(mDirectory, @"fastcache.plist") atomically:YES];
                    mNeedsSave = NO;
                }
            });
        }
    });
}

- (void) copyFilePath:(NSString*)filePath asKey:(NSString*)key {
    [self copyFilePath:filePath asKey:key withTimeout:mDefaultTimeout];
}

- (void) copyFilePath:(NSString*)filePath asKey:(NSString*)key withTimeout:(NSTimeInterval)timeout {
    dispatch_async(mDiskQueue, ^{
        [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:cachePathForKey(mDirectory, key) error:NULL];
    });
    [self setCacheTimeoutInterval:timeout forKey:key];
}

- (void) setData:(NSData*)data forKey:(NSString*)key {
    [self setData:data forKey:key withTimeout:mDefaultTimeout];
}

- (void) setData:(NSData*)data forKey:(NSString*)key withTimeout:(NSTimeInterval)timeout {
    if([key isEqualToString:@"fastcache.plist"] == YES) {
#if DEBUG
        NSLog(@"fastcache.plist is a reserved key and can not be modified.");
#endif
        return;
    }
    NSString* cachePath = cachePathForKey(mDirectory, key);
    dispatch_async(mDiskQueue, ^{
        [data writeToFile:cachePath atomically:YES];
    });
    [self setCacheTimeoutInterval:timeout forKey:key];
}

- (NSData*) dataForKey:(NSString*)key {
    if([self hasCacheForKey:key]) {
        return [NSData dataWithContentsOfFile:cachePathForKey(mDirectory, key) options:0 error:NULL];
    } else {
        return nil;
    }
}

- (void) setString:(NSString*)aString forKey:(NSString*)key {
    [self setString:aString forKey:key withTimeout:mDefaultTimeout];
}

- (void) setString:(NSString*)aString forKey:(NSString*)key withTimeout:(NSTimeInterval)timeout {
    [self setData:[aString dataUsingEncoding:NSUTF8StringEncoding] forKey:key withTimeout:timeout];
}

- (NSString*) stringForKey:(NSString*)key {
    return [[NSString alloc] initWithData:[self dataForKey:key] encoding:NSUTF8StringEncoding];
}


- (NSString*) keyWithFilename:(NSString*)filename {
    return [NSString stringWithFormat:@"%X.%@", [filename hash], [[filename pathExtension] stringByDeletingPathExtension]];
}

#if TARGET_OS_IPHONE

- (void) setImage:(UIImage*)anImage forKey:(NSString*)key {
    [self setImage:anImage forKey:key withTimeout:mDefaultTimeout];
}

- (void) setImage:(UIImage*)anImage forKey:(NSString*)key withTimeout:(NSTimeInterval)timeout {
    @try {
        [self setData:[NSKeyedArchiver archivedDataWithRootObject:anImage] forKey:key withTimeout:timeout];
    }
    @catch(NSException* e) {
    }
}

- (UIImage*) imageForKey:(NSString*)key {
    UIImage* image = nil;
    @try {
        image = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePathForKey(mDirectory, key)];
    }
    @catch(NSException* e) {
    }
    return image;
}

#else

- (NSImage*) imageForKey:(NSString*)key {
    return [[NSImage alloc] initWithData:[self dataForKey:key]];
}

- (void) setImage:(NSImage*)anImage forKey:(NSString*)key {
    [self setImage:anImage forKey:key withTimeout:mDefaultTimeout;
}

- (void) setImage:(NSImage*)anImage forKey:(NSString*)key withTimeout:(NSTimeInterval)timeout {
    [self setData:[[[anImage representations] objectAtIndex:0] representationUsingType:NSPNGFileType properties:nil] forKey:key withTimeout:timeout];
}

#endif

- (void) setPlist:(id)plistObject forKey:(NSString*)key {
    [self setPlist:plistObject forKey:key withTimeout:mDefaultTimeout];
}

- (void) setPlist:(id)plistObject forKey:(NSString*)key withTimeout:(NSTimeInterval)timeout {
    NSData* plistData = [NSPropertyListSerialization dataFromPropertyList:plistObject format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];
    [self setData:plistData forKey:key withTimeout:timeout];
}
     
- (NSData*) plistForKey:(NSString*)key; {
    NSData* plistData = [self dataForKey:key];
    return [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:nil errorDescription:nil];
}

- (void) setObject:(id< NSCoding >)anObject forKey:(NSString*)key {
    [self setObject:anObject forKey:key withTimeout:mDefaultTimeout];
}

- (void) setObject:(id< NSCoding >)anObject forKey:(NSString*)key withTimeout:(NSTimeInterval)timeout {
    [self setData:[NSKeyedArchiver archivedDataWithRootObject:anObject] forKey:key withTimeout:timeout];
}
     
- (id< NSCoding >) objectForKey:(NSString*)key {
    if([self hasCacheForKey:key] == YES) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForKey:key]];
    }
    return nil;
}

@end

/*--------------------------------------------------*/

ItsBetaFastCache* sharedItsBetaFastCache = nil;

/*--------------------------------------------------*/
