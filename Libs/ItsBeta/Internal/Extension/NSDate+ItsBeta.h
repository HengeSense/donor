/*--------------------------------------------------*/

#import <Foundation/Foundation.h>

/*--------------------------------------------------*/

@interface NSDate (ItsBeta)

+ (NSDate*) dateFromISO8601:(NSString*)iso8601;
+ (NSString*) iso8601FromDate:(NSDate*)date;

@end

/*--------------------------------------------------*/
