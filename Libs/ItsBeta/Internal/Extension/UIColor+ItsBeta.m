/*--------------------------------------------------*/

#import "UIColor+ItsBeta.h"

/*--------------------------------------------------*/
#if defined(TARGET_OS_IPHONE)
/*--------------------------------------------------*/

@implementation UIColor (ItsBeta)

+ (UIColor*) colorWithHexString:(NSString*)hexString {
    CGFloat alpha = 0.0f, red = 0.0f, blue = 0.0f, green = 0.0f;
    if([hexString isKindOfClass:[NSString class]] == YES) {
        NSString* colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
        switch([colorString length]) {
            case 3:
                red = [self colorComponentFrom:colorString start:0 length:1];
                green = [self colorComponentFrom:colorString start:1 length:1];
                blue = [self colorComponentFrom:colorString start:2 length:1];
                alpha = 1.0f;
                break;
            case 4:
                red = [self colorComponentFrom:colorString start:1 length:1];
                green = [self colorComponentFrom:colorString start:2 length:1];
                blue = [self colorComponentFrom:colorString start:3 length:1];
                alpha = [self colorComponentFrom:colorString start:0 length:1];
                break;
            case 6:
                red = [self colorComponentFrom:colorString start:0 length:2];
                green = [self colorComponentFrom:colorString start:2 length:2];
                blue = [self colorComponentFrom:colorString start:4 length:2];
                alpha = 1.0f;
                break;
            case 8:
                red = [self colorComponentFrom:colorString start:2 length:2];
                green = [self colorComponentFrom:colorString start:4 length:2];
                blue = [self colorComponentFrom:colorString start:6 length:2];
                alpha = [self colorComponentFrom:colorString start:0 length:2];
                break;
        }
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat) colorComponentFrom:(NSString*)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring :[NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

@end

/*--------------------------------------------------*/
#endif
/*--------------------------------------------------*/