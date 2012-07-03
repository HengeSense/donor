/*--------------------------------------------------*/

#import "HSCalendarDaysView.h"

/*--------------------------------------------------*/

@implementation HSCalendarDaysView

#pragma mark Property synthesize

@synthesize delegate = mDelegate;
@synthesize displayedDate = mDisplayedDate;
@synthesize selectedDate = mSelectedDate;

#pragma mark -
#pragma mark Property override

- (void) setDisplayedDate:(NSDate*)displayedDate
{
    if([self delegateWillChangeDisplayedDate:displayedDate] == NO)
    {
        mDisplayedDate = displayedDate;
        [self delegateDidChangeDisplayedDate:displayedDate];
        
        [self reloadData];
    }
}

- (void) setSelectedDate:(NSDate*)selectedDate
{
    if([self delegateWillChangeSelectedDate:selectedDate] == NO)
    {
        mSelectedDate = selectedDate;
        [self delegateDidChangeSelectedDate:selectedDate];
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
        mDisplayedDate = [NSDate dateWithCalendar:mCalendar component:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)];
        mSelectedDate = nil;
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        mDelegate = nil;
        mDisplayedDate = [NSDate dateWithCalendar:mCalendar component:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)];
        mSelectedDate = nil;
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
#pragma mark HSCalendarDaysView

- (BOOL) delegateWillChangeDisplayedDate:(NSDate *)displayedDate
{
    if([mDelegate respondsToSelector:@selector(calendarDaysView:willChangeDisplayedDate:)])
    {
        return [mDelegate calendarDaysView:self willChangeDisplayedDate:displayedDate];
    }
    return [mDisplayedDate isEqualToDate:displayedDate];
}

- (void) delegateDidChangeDisplayedDate:(NSDate*)displayedDate
{
    if([mDelegate respondsToSelector:@selector(calendarDaysView:didChangeDisplayedDate:)])
    {
        [mDelegate calendarDaysView:self didChangeDisplayedDate:displayedDate];
    }
}

- (BOOL) delegateWillChangeSelectedDate:(NSDate *)selectedDate
{
    if([mDelegate respondsToSelector:@selector(calendarDaysView:willChangeSelectedDate:)])
    {
        return [mDelegate calendarDaysView:self willChangeSelectedDate:selectedDate];
    }
    return [mSelectedDate isEqualToDate:selectedDate];
}

- (void) delegateDidChangeSelectedDate:(NSDate*)selectedDate
{
    if([mDelegate respondsToSelector:@selector(calendarDaysView:didChangeSelectedDate:)])
    {
        [mDelegate calendarDaysView:self didChangeSelectedDate:selectedDate];
    }
}

#pragma mark -

@end

/*--------------------------------------------------*/
