/*--------------------------------------------------*/

#import "ItsBetaCore.h"

/*--------------------------------------------------*/

@interface ItsBetaImage : NSObject< NSCoding >

@property(nonatomic, readonly) NSString* URL; // Удаленный путь до изображения
@property(nonatomic, readonly) NSString* key; // Локальный ключ изображения
#if defined(TARGET_OS_IPHONE)
@property(nonatomic, readonly) UIImage* data; // Изображение
#else
@property(nonatomic, readonly) NSImage* data; // Изображение
#endif

+ (ItsBetaImage*) imageWithImageURL:(NSString*)imageURL;

- (id) initWithImageURL:(NSString*)imageURL;

- (BOOL) synchronizeSync;

@end

/*--------------------------------------------------*/
