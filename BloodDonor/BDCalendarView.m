/*--------------------------------------------------*/

#import "BDCalendarView.h"

/*--------------------------------------------------*/

@implementation BDCalendarView 

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [pullView setDirection:HSPullDirectionBottom];
    [pullView setOffset:338.0f];
    
    if([[BloodDonor shared] isAuthenticated] == NO)
    {
        [[self tabBarController] setSelectedIndex:3];
    }
}

- (void) viewDidUnload
{
    listView = nil;
    calendarDaysView = nil;
    calendarWeekView = nil;
    calendarMonthView = nil;
    pullableView = nil;
    pullView = nil;
    
    [super viewDidUnload];
}

#pragma mark HSPullViewDelegate
#pragma mark -

- (void) pullView:(HSPullView*)view didChangeState:(BOOL)opened
{
}

#pragma mark HSCalendarMonthViewDelegate
#pragma mark -

- (void) calendarMonthView:(HSCalendarMonthView*)calendarMonthView didChangeDate:(NSDate*)date
{
    [calendarWeekView setDate:date];
    [calendarDaysView setDisplayedDate:date];
}

#pragma mark HSCalendarWeekViewDelegate
#pragma mark -

- (void) calendarWeekView:(HSCalendarWeekView*)calendarWeekView didChangeDate:(NSDate*)date
{
    [calendarMonthView setDate:date];
    [calendarDaysView setDisplayedDate:date];
}

#pragma mark HSCalendarDaysViewDelegate
#pragma mark -

- (void) calendarDaysView:(HSCalendarDaysView*)calendarDaysView didChangeDate:(NSDate*)date
{
    [calendarMonthView setDate:date];
    [calendarWeekView setDate:date];
}

#pragma mark UITableViewDelegate
#pragma mark -

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
}

#pragma mark UITableViewDataSource
#pragma mark -

- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
	return 1;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return 0;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}

@end

/*--------------------------------------------------*/
