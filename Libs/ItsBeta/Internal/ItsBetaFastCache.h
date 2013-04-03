/*--------------------------------------------------*/

#import "ItsBetaCore.h"

/*--------------------------------------------------*/

@interface ItsBetaFastCache : NSObject {
@protected
	NSString* mDirectory;
    NSTimeInterval mDefaultTimeout;
    
@protected
	dispatch_queue_t mCacheInfoQueue;
	dispatch_queue_t mFrozenCacheInfoQueue;
	dispatch_queue_t mDiskQueue;
    
@protected
	NSMutableDictionary* mCacheInfo;
	NSMutableDictionary* mFrozenCacheInfo;
    
@protected
	BOOL mNeedsSave;
}

@property(nonatomic, assign) NSTimeInterval defaultTimeout;
@property(nonatomic, copy) NSDictionary* frozenCacheInfo;

+ (instancetype) sharedItsBetaFastCache;

- (id) initWithCacheDirectory:(NSString*)cacheDirectory;

- (void) clearCache;

- (void) copyFilePath:(NSString*)filePath asKey:(NSString*)key;
- (void) copyFilePath:(NSString*)filePath asKey:(NSString*)key withTimeout:(NSTimeInterval)timeout;

- (BOOL) hasCacheForKey:(NSString*)key;
- (void) removeCacheForKey:(NSString*)key;

- (void) setData:(NSData*)data forKey:(NSString*)key;
- (void) setData:(NSData*)data forKey:(NSString*)key withTimeout:(NSTimeInterval)timeout;
- (NSData*) dataForKey:(NSString*)key;

- (void) setString:(NSString*)aString forKey:(NSString*)key;
- (void) setString:(NSString*)aString forKey:(NSString*)key withTimeout:(NSTimeInterval)timeout;
- (NSString*) stringForKey:(NSString*)key;

- (NSString*) keyWithFilename:(NSString*)filename;

#if TARGET_OS_IPHONE

- (void) setImage:(UIImage*)anImage forKey:(NSString*)key;
- (void) setImage:(UIImage*)anImage forKey:(NSString*)key withTimeout:(NSTimeInterval)timeout;
- (UIImage*) imageForKey:(NSString*)key;

#else

- (void) setImage:(NSImage*)anImage forKey:(NSString*)key;
- (void) setImage:(NSImage*)anImage forKey:(NSString*)key withTimeout:(NSTimeInterval)timeout;
- (NSImage*) imageForKey:(NSString*)key;

#endif

- (void) setPlist:(id)plistObject forKey:(NSString*)key;
- (void) setPlist:(id)plistObject forKey:(NSString*)key withTimeout:(NSTimeInterval)timeout;
- (NSData*) plistForKey:(NSString*)key;

- (void) setObject:(id< NSCoding >)anObject forKey:(NSString*)key;
- (void) setObject:(id< NSCoding >)anObject forKey:(NSString*)key withTimeout:(NSTimeInterval)timeout;
- (id< NSCoding >) objectForKey:(NSString*)key;

@end

/*--------------------------------------------------*/

extern ItsBetaFastCache * sharedItsBetaFastCache;

/*--------------------------------------------------*/
