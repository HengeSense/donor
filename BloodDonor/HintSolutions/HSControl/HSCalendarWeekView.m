/*--------------------------------------------------*/

#import "HSCalendarWeekView.h"

/*--------------------------------------------------*/

@implementation HSCalendarWeekView

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
#pragma mark HSCalendarWeekView

- (BOOL) delegateWillChangeDate:(NSDate*)date
{
    if([mDelegate respondsToSelector:@selector(calendarWeekView:willChangeDate:)])
    {
        return [mDelegate calendarWeekView:self willChangeDate:date];
    }
    return [mDate isEqualToDate:date];
}

- (void) delegateDidChangeDate:(NSDate*)date
{
    if([mDelegate respondsToSelector:@selector(calendarWeekView:didChangeDate:)])
    {
        [mDelegate calendarWeekView:self didChangeDate:date];
    }
}

#pragma mark -

@end

/*--------------------------------------------------*/
