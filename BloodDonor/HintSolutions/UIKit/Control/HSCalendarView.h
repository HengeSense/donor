/*--------------------------------------------------*/

#import <UIKit/UIKit.h>

/*--------------------------------------------------*/

@class HSCalendarCellView;

/*--------------------------------------------------*/

@protocol HSCalendarViewDelegate;

/*--------------------------------------------------*/

@interface HSCalendarView : UIView
{
    id< HSCalendarViewDelegate > mDelegate;
    NSCalendar *mCalendar;
    NSDate *mSelectedDate;
    NSDate *mDisplayedDate;
    UIView *mMonthBar;
    UILabel *mMonthLabel;
    UIButton *mMonthBackButton;
    UIButton *mMonthForwardButton;
    UIView *mWeekDayBar;
    NSArray *mWeekDayLabels;
    UIView *mGridView;
    NSArray *mDayCells;
    CGFloat mMonthBarHeight;
    CGFloat mMonthBarButtonWidth;
    CGFloat mWeekBarHeight;
    CGFloat mGridMargin;
}

@property(nonatomic, readwrite, assign) id< HSCalendarViewDelegate > delegate;
@property(nonatomic, readwrite, retain) NSCalendar *calendar;
@property(nonatomic, readwrite, retain) NSDate *selectedDate;
@property(nonatomic, readwrite, retain) NSDate *displayedDate;
@property(nonatomic, readonly, assign) NSUInteger displayedYear;
@property(nonatomic, readonly, assign) NSUInteger displayedMonth;
@property(nonatomic, readwrite, assign) CGFloat monthBarHeight;
@property(nonatomic, readwrite, assign) CGFloat monthBarButtonWidth;
@property(nonatomic, readwrite, assign) CGFloat weekBarHeight;
@property(nonatomic, readwrite, assign) CGFloat gridMargin;

@property(nonatomic, readonly) UIView *monthBar;
@property(nonatomic, readonly) UILabel *monthLabel;
@property(nonatomic, readonly) UIButton *monthBackButton;
@property(nonatomic, readonly) UIButton *monthForwardButton;
@property(nonatomic, readonly) UIView *weekDayBar;
@property(nonatomic, readonly) NSArray *weekDayLabels;
@property(nonatomic, readonly) UIView *gridView;
@property(nonatomic, readonly) NSArray *dayCells;

- (void) monthBack;
- (void) monthForward;
- (void) reset;

- (HSCalendarCellView*) cellForDate:(NSDate*)date;

@end

/*--------------------------------------------------*/

@interface HSCalendarCellView : UIButton
{
    NSUInteger mDay;
}

@property(nonatomic, assign) NSUInteger day;

- (NSDate*) dateWithBaseDate:(NSDate*)date calendar:(NSCalendar*)calendar;

@end

/*--------------------------------------------------*/

@protocol HSCalendarViewDelegate <NSObject>

@optional

- (void) calendarView:(HSCalendarView*)calendar didSelectDate:(NSDate*)date;

@end

/*--------------------------------------------------*/
