/*--------------------------------------------------*/

#import "HSDateFormatter.h"

/*--------------------------------------------------*/

@implementation NSDateFormatter (HintSolutions)

+ (id) dateFormatter
{
    return [[self alloc] init];
}

+ (id) dateFormatterWithCalendar:(NSCalendar*)calendar
{
    return [[self alloc] initWithCalendar:calendar];
}

- (id) initWithCalendar:(NSCalendar*)calendar
{
    self = [super init];
    if(self != nil)
    {
        [self setCalendar:calendar];
    }
    return self;
}

@end

/*--------------------------------------------------*/
