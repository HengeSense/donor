/*--------------------------------------------------*/

#import "HSCalendarView.h"

/*--------------------------------------------------*/

@implementation HSCalendarView

#pragma mark Property synthesize

@synthesize calendar = mCalendar;
@synthesize direction = mDirection;

#pragma mark -
#pragma mark Property override

- (void) setCalendar:(NSCalendar*)calendar
{
    if([mCalendar isEqual:calendar] == NO)
    {
        mCalendar = calendar;
        
        [self reloadData];
    }
}

#pragma mark -
#pragma mark UIView

- (id) initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if(self != nil)
    {
        mDirection = HSCalendarDirectionTop;
        mCalendar = [NSCalendar currentCalendar];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        mDirection = HSCalendarDirectionTop;
        mCalendar = [NSCalendar currentCalendar];
    }
    return self;
}

#pragma mark -
#pragma mark HSCalendarView

- (void) reloadData
{
    for(UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
}

#pragma mark -

@end

/*--------------------------------------------------*/
