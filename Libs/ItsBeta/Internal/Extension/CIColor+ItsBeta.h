/*--------------------------------------------------*/

#import <Foundation/Foundation.h>

/*--------------------------------------------------*/
#if !defined(TARGET_OS_IPHONE)
/*--------------------------------------------------*/

@interface CIColor (ItsBeta)

+ (CIColor*) colorWithHexString:(NSString*)hexString;

+ (CGFloat) colorComponentFrom:(NSString*)string start:(NSUInteger)start length:(NSUInteger)length;

@end

/*--------------------------------------------------*/
#endif
/*--------------------------------------------------*/
