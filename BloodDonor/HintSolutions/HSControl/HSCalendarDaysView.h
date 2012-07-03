/*--------------------------------------------------*/

#import "HSCalendarView.h"

/*--------------------------------------------------*/

@protocol HSCalendarDaysViewDelegate;

/*--------------------------------------------------*/

@interface HSCalendarDaysView : HSCalendarView
{
    id< HSCalendarDaysViewDelegate > mDelegate;
    NSDate *mDisplayedDate;
    NSDate *mSelectedDate;
}

@property (nonatomic, readwrite, strong) IBOutlet id< HSCalendarDaysViewDelegate > delegate;
@property (nonatomic, readwrite, strong) NSDate* displayedDate;
@property (nonatomic, readwrite, strong) NSDate* selectedDate;

- (BOOL) delegateWillChangeDisplayedDate:(NSDate*)displayedDate;
- (void) delegateDidChangeDisplayedDate:(NSDate*)displayedDate;
- (BOOL) delegateWillChangeSelectedDate:(NSDate*)selectedDate;
- (void) delegateDidChangeSelectedDate:(NSDate*)selectedDate;

@end

/*--------------------------------------------------*/

@protocol HSCalendarDaysViewDelegate <  NSObject >

@optional
- (BOOL) calendarDaysView:(HSCalendarDaysView*)calendarDaysView willChangeDisplayedDate:(NSDate*)displayedDate;
- (void) calendarDaysView:(HSCalendarDaysView*)calendarDaysView didChangeDisplayedDate:(NSDate*)displayedDate;
- (BOOL) calendarDaysView:(HSCalendarDaysView*)calendarDaysView willChangeSelectedDate:(NSDate*)selectedDate;
- (void) calendarDaysView:(HSCalendarDaysView*)calendarDaysView didChangeSelectedDate:(NSDate*)selectedDate;

@end

/*--------------------------------------------------*/
