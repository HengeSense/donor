/*--------------------------------------------------*/

#import "HSViewController.h"
#import "HSPullView.h"
#import "HSCalendarMonthView.h"
#import "HSCalendarWeekView.h"
#import "HSCalendarDaysView.h"

/*--------------------------------------------------*/

#import "BloodDonor.h"

/*--------------------------------------------------*/

@class BDCalendarMonthView;

/*--------------------------------------------------*/

@interface BDCalendarView : UIViewController< HSPullViewDelegate, HSCalendarMonthViewDelegate, HSCalendarWeekViewDelegate, HSCalendarDaysViewDelegate, UITableViewDelegate, UITableViewDataSource >
{
    IBOutlet UIView *pullableView;
    IBOutlet HSPullView *pullView;
    IBOutlet HSCalendarMonthView *calendarMonthView;
    IBOutlet HSCalendarWeekView *calendarWeekView;
    IBOutlet HSCalendarDaysView *calendarDaysView;
    IBOutlet UITableView *listView;
}

@end

/*--------------------------------------------------*/

