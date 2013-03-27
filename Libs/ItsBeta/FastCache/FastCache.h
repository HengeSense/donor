/*--------------------------------------------------*/

#import <Foundation/Foundation.h>

/*--------------------------------------------------*/

#if TARGET_OS_IPHONE
#   import <UIKit/UIKit.h>
#endif

/*--------------------------------------------------*/

#if __has_feature(objc_arc)
#   define NS_SAFE_AUTORELEASE(object)              object
#   define NS_SAFE_RETAIN(object)                   object
#   define NS_SAFE_RELEASE(object)                  object = nil
#else
#   define NS_SAFE_AUTORELEASE(object)              [object autorelease]
#   define NS_SAFE_RETAIN(object)                   [object retain]
#   define NS_SAFE_RELEASE(object)                  [object release]
#endif

/*--------------------------------------------------*/

@interface FastCache : NSObject {
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

+ (instancetype) sharedFastCache;

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

extern FastCache * sharedFastCache;

/*--------------------------------------------------*/
