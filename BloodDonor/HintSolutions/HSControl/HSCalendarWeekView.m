/*--------------------------------------------------*/

#import "HSCalendarWeekdaysView.h"

/*--------------------------------------------------*/

@implementation HSCalendarWeekdaysView

#pragma mark Property synthesize

@synthesize delegate = mDelegate;
@synthesize calendar = mCalendar;
@synthesize date = mDate;

#pragma mark -
#pragma mark UIView

- (id) initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if(self != nil)
    {
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
    }
    return self;
}

#pragma mark -

@end

/*--------------------------------------------------*/
