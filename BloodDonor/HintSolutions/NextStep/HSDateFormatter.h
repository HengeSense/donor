/*--------------------------------------------------*/

#import <Foundation/Foundation.h>

/*--------------------------------------------------*/

@interface NSDateFormatter (HintSolutions)

+ (id) dateFormatter;
+ (id) dateFormatterWithCalendar:(NSCalendar*)calendar;

- (id) initWithCalendar:(NSCalendar*)calendar;

@end

/*--------------------------------------------------*/
