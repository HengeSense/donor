/*--------------------------------------------------*/

#import "HSControl.h"
#import "HSDate.h"

/*--------------------------------------------------*/

enum
{
    HSCalendarDirectionTop,
    HSCalendarDirectionRight,
    HSCalendarDirectionBottom,
    HSCalendarDirectionLeft
};

typedef NSUInteger HSCalendarDirection;

/*--------------------------------------------------*/

@interface HSCalendarView : HSControl
{
    HSCalendarDirection mDirection;
    NSCalendar *mCalendar;
}

@property (nonatomic, readwrite, strong) NSCalendar* calendar;
@property (nonatomic, readwrite, assign) HSCalendarDirection direction;

- (void) reloadData;

@end

/*--------------------------------------------------*/
