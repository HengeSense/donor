/*--------------------------------------------------*/

#import "HSCalendarView.h"

/*--------------------------------------------------*/

@protocol HSCalendarMonthViewDelegate;

/*--------------------------------------------------*/

@interface HSCalendarMonthView : HSCalendarView
{
    id< HSCalendarMonthViewDelegate > mDelegate;
    NSDate *mDate;
}

@property (nonatomic, readwrite, strong) IBOutlet id< HSCalendarMonthViewDelegate > delegate;
@property (nonatomic, readwrite, strong) NSDate* date;

- (void) addYearToDate:(NSUInteger)year;
- (void) addMonthToDate:(NSUInteger)month;
- (void) addDayToDate:(NSUInteger)day;

- (BOOL) delegateWillChangeDate:(NSDate*)date;
- (void) delegateDidChangeDate:(NSDate*)date;

@end

/*--------------------------------------------------*/

@protocol HSCalendarMonthViewDelegate <  NSObject >

@optional
- (BOOL) calendarMonthView:(HSCalendarMonthView*)calendarMonthView willChangeDate:(NSDate*)date;
- (void) calendarMonthView:(HSCalendarMonthView*)calendarMonthView didChangeDate:(NSDate*)date;

@end

/*--------------------------------------------------*/
