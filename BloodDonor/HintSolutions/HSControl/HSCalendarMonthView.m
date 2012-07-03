/*--------------------------------------------------*/

#import "HSCalendarMonthView.h"

/*--------------------------------------------------*/

@implementation HSCalendarMonthView

#pragma mark Property synthesize

@synthesize delegate = mDelegate;
@synthesize date = mDate;

#pragma mark -
#pragma mark Property override

- (void) setDate:(NSDate*)date
{
    if([self delegateWillChangeDate:date] == NO)
    {
        mDate = date;
        [self delegateDidChangeDate:date];
        
        [self reloadData];
    }
}

#pragma mark -
#pragma mark UIView

- (id) initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if(self != nil)
    {
        mDelegate = nil;
        mDate = [NSDate dateWithCalendar:mCalendar component:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        mDelegate = nil;
        mDate = [NSDate dateWithCalendar:mCalendar component:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)];
    }
    return self;
}

#pragma mark -
#pragma mark HSCalendarView

- (void) reloadData
{
    [super reloadData];
}

#pragma mark -
#pragma mark HSCalendarMonthView

- (void) addYearToDate:(NSUInteger)year
{
    [self setDate:[mDate addYearWithCalendar:mCalendar year:year]];
}

- (void) addMonthToDate:(NSUInteger)month
{
    [self setDate:[mDate addMonthWithCalendar:mCalendar month:month]];
}

- (void) addDayToDate:(NSUInteger)day
{
    [self setDate:[mDate addDayWithCalendar:mCalendar day:day]];
}

- (BOOL) delegateWillChangeDate:(NSDate*)date
{
    if([mDelegate respondsToSelector:@selector(calendarMonthView:willChangeDate:)])
    {
        return [mDelegate calendarMonthView:self willChangeDate:date];
    }
    return [mDate isEqualToDate:date];
}

- (void) delegateDidChangeDate:(NSDate*)date
{
    if([mDelegate respondsToSelector:@selector(calendarMonthView:didChangeDate:)])
    {
        [mDelegate calendarMonthView:self didChangeDate:date];
    }
}

#pragma mark -

@end

/*--------------------------------------------------*/
