/*--------------------------------------------------*/

#import "HSView.h"

/*--------------------------------------------------*/

@protocol HSCalendarWeekdaysViewDelegate;

/*--------------------------------------------------*/

enum
{
    HSCalendarWeekdaysDirectionTop,
    HSCalendarWeekdaysDirectionRight,
    HSCalendarWeekdaysDirectionBottom,
    HSCalendarWeekdaysDirectionLeft
};

typedef NSUInteger HSCalendarWeekdaysDirection;

/*--------------------------------------------------*/

@interface HSCalendarWeekdaysView : UIView
{
    id< HSCalendarWeekdaysViewDelegate > mDelegate;
    NSCalendar *mCalendar;
    NSDate *mDate;
}

@property (nonatomic, readwrite, strong) IBOutlet id< HSCalendarWeekdaysViewDelegate > delegate;
@property (nonatomic, readwrite, strong) NSCalendar* calendar;
@property (nonatomic, readwrite, strong) NSDate* date;

@end

/*--------------------------------------------------*/

@protocol HSCalendarWeekdaysViewDelegate <  NSObject >

@optional
- (BOOL) calendarWeekdaysView:(HSCalendarWeekdaysView*)calendarWeekdaysView willChangeDate:(NSDate*)date;
- (void) calendarWeekdaysView:(HSCalendarWeekdaysView*)calendarWeekdaysView didChangeDate:(NSDate*)date;

@end

/*--------------------------------------------------*/
