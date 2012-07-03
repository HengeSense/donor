/*--------------------------------------------------*/

#import "HSCalendarView.h"

/*--------------------------------------------------*/

@protocol HSCalendarWeekViewDelegate;

/*--------------------------------------------------*/

@interface HSCalendarWeekView : HSCalendarView
{
    id< HSCalendarWeekViewDelegate > mDelegate;
    NSDate *mDate;
}

@property (nonatomic, readwrite, strong) IBOutlet id< HSCalendarWeekViewDelegate > delegate;
@property (nonatomic, readwrite, strong) NSDate* date;

- (BOOL) delegateWillChangeDate:(NSDate*)date;
- (void) delegateDidChangeDate:(NSDate*)date;

@end

/*--------------------------------------------------*/

@protocol HSCalendarWeekViewDelegate <  NSObject >

@optional
- (BOOL) calendarWeekView:(HSCalendarWeekView*)calendarWeekView willChangeDate:(NSDate*)date;
- (void) calendarWeekView:(HSCalendarWeekView*)calendarWeekView didChangeDate:(NSDate*)date;

@end

/*--------------------------------------------------*/
