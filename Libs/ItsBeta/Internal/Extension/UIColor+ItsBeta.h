/*--------------------------------------------------*/

#import <Foundation/Foundation.h>

/*--------------------------------------------------*/
#if defined(TARGET_OS_IPHONE)
/*--------------------------------------------------*/

@interface UIColor (ItsBeta)

+ (UIColor*) colorWithHexString:(NSString*)hexString;

+ (CGFloat) colorComponentFrom:(NSString*)string start:(NSUInteger)start length:(NSUInteger)length;

@end

/*--------------------------------------------------*/
#endif
/*--------------------------------------------------*/
