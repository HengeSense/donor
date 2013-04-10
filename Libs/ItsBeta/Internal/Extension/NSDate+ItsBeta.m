/*--------------------------------------------------*/

#import "NSDate+ItsBeta.h"

/*--------------------------------------------------*/
#if defined(TARGET_OS_IPHONE)
/*--------------------------------------------------*/

@implementation NSDate (ItsBeta)

+ (NSDateFormatter*) dateFormatterWithISO8601 {
    static NSDateFormatter* formatter = nil;
    if(formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    return formatter;
}

+ (NSDate*) dateFromISO8601:(NSString*)iso8601 {
    return [[self dateFormatterWithISO8601] dateFromString:iso8601];
}

+ (NSString*) iso8601FromDate:(NSDate*)date {
    return [[self dateFormatterWithISO8601] stringFromDate:date];
}

@end

/*--------------------------------------------------*/
#endif
/*--------------------------------------------------*/