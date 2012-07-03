/*--------------------------------------------------*/

#import "HSDateComponents.h"
#import "HSDateFormatter.h"

/*--------------------------------------------------*/

@interface NSDate (HintSolutions)

+ (id) dateWithCalendar:(NSCalendar*)calendar component:(NSUInteger)component;
- (id) initWithCalendar:(NSCalendar*)calendar component:(NSUInteger)component;

- (NSDate*) changeYearWithCalendar:(NSCalendar*)calendar year:(NSUInteger)year;
- (NSDate*) changeMonthWithCalendar:(NSCalendar*)calendar month:(NSUInteger)month;
- (NSDate*) changeDayWithCalendar:(NSCalendar*)calendar day:(NSUInteger)day;

- (NSUInteger) yearWithCalendar:(NSCalendar*)calendar;
- (NSUInteger) monthWithCalendar:(NSCalendar*)calendar;
- (NSUInteger) dayWithCalendar:(NSCalendar*)calendar;

- (NSDate*) addYearWithCalendar:(NSCalendar*)calendar year:(NSUInteger)year;
- (NSDate*) addMonthWithCalendar:(NSCalendar*)calendar month:(NSUInteger)month;
- (NSDate*) addDayWithCalendar:(NSCalendar*)calendar day:(NSUInteger)day;

@end

/*--------------------------------------------------*/
