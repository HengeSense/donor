/*--------------------------------------------------*/

#import "HSDate.h"

/*--------------------------------------------------*/

@implementation NSDate (HintSolutions)

+ (id) dateWithCalendar:(NSCalendar*)calendar component:(NSUInteger)component
{
    return [[self alloc] initWithCalendar:calendar component:component];
}

- (id) initWithCalendar:(NSCalendar*)calendar component:(NSUInteger)component
{
    NSUInteger GMT = 0;
    if(calendar != nil)
    {
        GMT = [[calendar timeZone] secondsFromGMT];
    }
    self = [self initWithTimeIntervalSinceNow:GMT];
    if(self != nil)
    {
        if(calendar != nil)
        {
            self = [calendar dateFromComponents:[calendar components:component fromDate:self]];
        }
    }
    return self;
}

- (NSDate*) changeYearWithCalendar:(NSCalendar*)calendar year:(NSUInteger)year
{
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit fromDate:self];
    if(comp != nil)
    {
        [comp setYear:year];
        return [calendar dateFromComponents:comp];
    }
    return self;
}

- (NSDate*) changeMonthWithCalendar:(NSCalendar*)calendar month:(NSUInteger)month
{
    NSDateComponents *comp = [calendar components:NSMonthCalendarUnit fromDate:self];
    if(comp != nil)
    {
        [comp setMonth:month];
        return [calendar dateFromComponents:comp];
    }
    return self;
}

- (NSDate*) changeDayWithCalendar:(NSCalendar*)calendar day:(NSUInteger)day
{
    NSDateComponents *comp = [calendar components:NSDayCalendarUnit fromDate:self];
    if(comp != nil)
    {
        [comp setDay:day];
        return [calendar dateFromComponents:comp];
    }
    return self;
}

- (NSUInteger) yearWithCalendar:(NSCalendar*)calendar
{
    return [[calendar components:NSYearCalendarUnit fromDate:self] year];
}

- (NSUInteger) monthWithCalendar:(NSCalendar*)calendar
{
    return [[calendar components:NSMonthCalendarUnit fromDate:self] month];
}

- (NSUInteger) dayWithCalendar:(NSCalendar*)calendar
{
    return [[calendar components:NSDayCalendarUnit fromDate:self] day];
}

- (NSDate*) addYearWithCalendar:(NSCalendar*)calendar year:(NSUInteger)year
{
    return [calendar dateByAddingComponents:[NSDateComponents dateComponentsWithYear:year] toDate:self options:0];
}

- (NSDate*) addMonthWithCalendar:(NSCalendar*)calendar month:(NSUInteger)month
{
    return [calendar dateByAddingComponents:[NSDateComponents dateComponentsWithMonth:month] toDate:self options:0];
}

- (NSDate*) addDayWithCalendar:(NSCalendar*)calendar day:(NSUInteger)day
{
    return [calendar dateByAddingComponents:[NSDateComponents dateComponentsWithDay:day] toDate:self options:0];
}

@end

/*--------------------------------------------------*/
