/*--------------------------------------------------*/

#import "HSCalendarView.h"

/*--------------------------------------------------*/

#import <QuartzCore/QuartzCore.h>

/*--------------------------------------------------*/

@implementation HSCalendarView

@synthesize delegate = mDelegate;
@synthesize calendar = mCalendar;
@synthesize selectedDate = mSelectedDate;
@synthesize displayedDate = mDisplayedDate;
@synthesize monthBarHeight = mMonthBarHeight;
@synthesize monthBarButtonWidth = mMonthBarButtonWidth;
@synthesize weekBarHeight = mWeekBarHeight;
@synthesize gridMargin = mGridMargin;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if(self != nil)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectedDate:nil];
        [self setDisplayedDate:[NSDate date]];

        mMonthBarHeight = 48;
        mMonthBarButtonWidth = 64;
        mWeekBarHeight = 32;
        mGridMargin = 4;
    }
    return self;
}

- (void) dealloc
{
    [mDisplayedDate release];
    [mSelectedDate release];
    [mCalendar release];

    [super dealloc];
}

- (NSCalendar*) calendar
{
    if(mCalendar == nil)
    {
        mCalendar = [[NSCalendar currentCalendar] retain];
    }
    return mCalendar;
}

- (void) setCalendar:(NSCalendar*)calendar
{
    if(mCalendar != calendar)
    {
        [mCalendar release];
        mCalendar = [calendar retain];
        [self setNeedsLayout];
    }
}

- (void) setSelectedDate:(NSDate*)date
{
    if([mSelectedDate isEqual: date] == NO)
    {
        [mSelectedDate release];
        mSelectedDate = [date retain];
        for(HSCalendarCellView *cell in mDayCells)
        {
            cell.selected = NO;
        }
        [[self cellForDate:date] setSelected: YES];
        if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)])
        {
            [self.delegate calendarView: self didSelectDate:mSelectedDate];
        }
    }
}

- (void) setDisplayedDate:(NSDate*)date
{
    if([mDisplayedDate isEqual: date] == NO)
    {
        [mDisplayedDate release];
        mDisplayedDate = [date retain];
        NSString *month = [[[[NSDateFormatter new] autorelease] standaloneMonthSymbols] objectAtIndex:[self displayedMonth] - 1];
        [[self monthLabel] setText:[NSString stringWithFormat: @"%@ %d", NSLocalizedString(month, @""), [self displayedYear]]];
        [self setNeedsLayout];
    }
}

- (NSUInteger) displayedYear
{
    return [[[self calendar] components:NSYearCalendarUnit
                               fromDate:[self displayedDate]] year];
}

- (NSUInteger) displayedMonth
{
    return [[[self calendar] components:NSMonthCalendarUnit
                               fromDate:[self displayedDate]] month];
}

- (void) setMonthBarHeight:(CGFloat)height
{
    if(mMonthBarHeight != height)
    {
        mMonthBarHeight = height;
        [self setNeedsLayout];
    }
}

- (void) setWeekBarHeight:(CGFloat)height
{
    if(mWeekBarHeight != height)
    {
        mWeekBarHeight = height;
        [self setNeedsLayout];
    }
}

- (UIView*) monthBar
{
    if(mMonthBar != nil)
    {
        mMonthBar = [[[UIView alloc] init] autorelease];
        [mMonthBar setBackgroundColor:[UIColor blueColor]];
        [mMonthBar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin)];
        [self addSubview:mMonthBar];
    }
    return mMonthBar;
}

- (UILabel*) monthLabel
{
    if(mMonthLabel != nil)
    {
        mMonthLabel = [[[UILabel alloc] init] autorelease];
        [mMonthLabel setFont:[UIFont systemFontOfSize:[UIFont buttonFontSize]]];
        [mMonthLabel setTextColor:[UIColor whiteColor]];
        [mMonthLabel setTextAlignment:UITextAlignmentCenter];
        [mMonthLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin)];
        [mMonthLabel setBackgroundColor:[UIColor clearColor]];
        [[self monthBar] addSubview:mMonthLabel];
    }
    return mMonthLabel;
}

- (UIButton*) monthBackButton
{
    if(mMonthBackButton != nil)
    {
        mMonthBackButton = [[[UIButton alloc] init] autorelease];
        [mMonthBackButton setTitle:@"<" forState:UIControlStateNormal];
        [[mMonthBackButton titleLabel] setFont:[UIFont systemFontOfSize: [UIFont buttonFontSize]]];
        [[mMonthBackButton titleLabel] setTextColor:[UIColor whiteColor]];
        [mMonthBackButton addTarget:self
                             action:@selector(monthBack)
                   forControlEvents:UIControlEventTouchUpInside];
        [[self monthBar] addSubview:mMonthBackButton];
    }
    return mMonthBackButton;
}

- (UIButton*) monthForwardButton
{
    if(mMonthForwardButton != nil)
    {
        mMonthForwardButton = [[[UIButton alloc] init] autorelease];
        [mMonthForwardButton setTitle:@">" forState:UIControlStateNormal];
        [[mMonthForwardButton titleLabel] setFont:[UIFont systemFontOfSize: [UIFont buttonFontSize]]];
        [[mMonthForwardButton titleLabel] setTextColor:[UIColor whiteColor]];
        [mMonthForwardButton addTarget:self
                                action:@selector(monthForward)
                      forControlEvents:UIControlEventTouchUpInside];
        [[self monthBar] addSubview:mMonthForwardButton];
    }
    return mMonthForwardButton;
}

- (UIView*) weekDayBar
{
    if(mWeekDayBar != nil)
    {
        mWeekDayBar = [[[UIView alloc] init] autorelease];
        [mWeekDayBar setBackgroundColor:[UIColor clearColor]];
    }
    return mWeekDayBar;
}

- (NSArray*) weekDayLabels
{
    if(mWeekDayLabels != nil)
    {
        NSMutableArray *labels = [NSMutableArray array];
        NSDateFormatter *fromat = [[[NSDateFormatter alloc] init] autorelease];
        [fromat setCalendar:[self calendar]];
        for(NSUInteger i = [[self calendar] firstWeekday]; i < [[self calendar] firstWeekday] + 7; ++i)
        {
            NSUInteger index = (i - 1) < 7 ? (i - 1) : ((i - 1) - 7);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            if(label != nil)
            {
                [label setText:NSLocalizedString([[fromat shortWeekdaySymbols] objectAtIndex:index], @"")];
                [label setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
                [label setTextAlignment:UITextAlignmentCenter];
                [label setTag:i];
                [labels addObject:label];
                [mWeekDayBar addSubview: label];
            }
        }
        [self addSubview:mWeekDayBar];
        mWeekDayLabels = [[NSArray alloc] initWithArray:labels];
    }
    return mWeekDayLabels;
}

- (UIView*) gridView
{
    if(mGridView != nil)
    {
        mGridView = [[[UIView alloc] init] autorelease];
        [mGridView setBackgroundColor:[UIColor clearColor]];
        [mGridView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self addSubview:mGridView];
    }
    return mGridView;
}

- (NSArray*) dayCells
{
    if(mDayCells != nil)
    {
        NSMutableArray *array = [NSMutableArray array];
        for(NSUInteger i = 1; i <= 31; ++i)
        {
            HSCalendarCellView *cellView = [[HSCalendarCellView new] autorelease];
            cellView.backgroundColor = [UIColor clearColor];
            [cellView setTitleColor:[UIColor blackColor]
                           forState:UIControlStateNormal];
            [cellView setTitleColor:[UIColor redColor]
                           forState:UIControlStateSelected];
            cellView.tag = i;
            cellView.day = i;
            [cellView addTarget:self
                         action:@selector(touchedCellView:)
               forControlEvents:UIControlEventTouchUpInside];
            [array addObject:cellView];
            [[self gridView] addSubview:cellView];
        }
        mDayCells = [[NSArray alloc] initWithArray:array];
    }
    return mDayCells;
}

- (void) touchedCellView:(HSCalendarCellView*)cell
{
    [self setSelectedDate:[cell dateWithBaseDate:[self displayedDate]
                                        calendar:[self calendar]]];
}

- (void) monthBack
{
    NSDateComponents *month = [[NSDateComponents new] autorelease];
    [month setMonth:-1];
    [self setDisplayedDate:[[self calendar] dateByAddingComponents:month
                                                            toDate:[self displayedDate]
                                                           options:0]];
}

- (void) monthForward
{
    NSDateComponents *month = [[NSDateComponents new] autorelease];
    [month setMonth:+1];
    [self setDisplayedDate:[[self calendar] dateByAddingComponents:month
                                                            toDate:[self displayedDate]
                                                           options:0]];
}

- (void) reset
{
    [self setSelectedDate:nil];
}

- (NSDate*) displayedMonthStartDate
{
    NSDateComponents *components = [[self calendar] components:(NSMonthCalendarUnit | NSYearCalendarUnit)
                                                      fromDate:[self displayedDate]];
    [components setDay:1];
    return [[self calendar] dateFromComponents:components];
}

- (HSCalendarCellView*) cellForDate:(NSDate*)date
{
    NSDateComponents *components = [[self calendar] components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)
                                                      fromDate:date];
    if(([components month] == [self displayedMonth]) && ([components year] == [self displayedYear]) && ([[self dayCells] count] >= [components day]))
    {
        return [[self dayCells] objectAtIndex:[components day] - 1];
    }
    return nil;
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    CGFloat offset = 0;
    if(mMonthBarHeight > 0.0f)
    {
        [[self monthBar] setFrame:CGRectMake(0, offset, [self bounds].size.width, mMonthBarHeight)];
        [[self monthLabel] setFrame:CGRectMake(0, offset, [self bounds].size.width, [[self monthBar] bounds].size.height)];
        [[self monthForwardButton] setFrame:CGRectMake([[self monthBar] bounds].size.width - mMonthBarButtonWidth, offset, mMonthBarButtonWidth, [[self monthBar] bounds].size.height)];
        [[self monthBackButton] setFrame:CGRectMake(0, offset, mMonthBarButtonWidth, [[self monthBar] bounds].size.height)];
        offset = [[self monthBar] frame].origin.y + [[self monthBar] frame].size.height;
    }
    else
    {
        [[self monthBar] setFrame:CGRectZero];
    }
    if(mWeekBarHeight > 0.0f)
    {
        [[self weekDayBar] setFrame:CGRectMake(0, offset, [self bounds].size.width, mWeekBarHeight)];
        for(NSUInteger i = 0; i < [[self weekDayLabels] count]; i++)
        {
            UILabel *label = [[self weekDayLabels] objectAtIndex:i];
            [label setFrame:CGRectMake(([[self weekDayBar] bounds].size.width / 7) * (i % 7), 0, [[self weekDayBar] bounds].size.width / 7, [[self weekDayBar] bounds].size.height)];
        }
        offset = [[self weekDayBar] frame].origin.y + [[self weekDayBar] frame].size.height;
    }
    else
    {
        [[self weekDayBar] setFrame:CGRectZero];
    }
    NSDateComponents *components = [[self calendar] components:NSWeekdayCalendarUnit
                                                      fromDate:[self displayedMonthStartDate]];
    NSInteger shift = [components weekday] - [[self calendar] firstWeekday];
    if(shift < 0)
    {
        shift = 7 + shift;
    }
    NSRange range = [[self calendar] rangeOfUnit:NSDayCalendarUnit
                                          inUnit:NSMonthCalendarUnit
                                         forDate:[self displayedDate]];
    [[self gridView] setFrame:CGRectMake(mGridMargin, offset, [self bounds].size.width - mGridMargin * 2, [self bounds].size.height - offset)];
    CGFloat cellHeight = [[self gridView] bounds].size.height / 6.0;
    CGFloat cellWidth = ([self bounds].size.width - mGridMargin * 2) / 7.0;
    for(NSUInteger i = 0; i < [[self dayCells] count]; i++)
    {
        HSCalendarCellView *cellView = [self.dayCells objectAtIndex:i];
        [cellView setFrame:CGRectMake(cellWidth * ((shift + i) % 7), cellHeight * ((shift + i) / 7), cellWidth, cellHeight)];
        [cellView setSelected:[[cellView dateWithBaseDate:[self displayedDate] calendar:[self calendar]] isEqualToDate:mSelectedDate]];
        [cellView setHidden:(i >= range.length)];
    }
}

@end

/*--------------------------------------------------*/

@implementation HSCalendarCellView

@synthesize day = mDay;

- (void) setDay:(NSUInteger)day
{
    if(mDay != day)
    {
        mDay = day;
        [self setTitle: [NSString stringWithFormat: @"%d", mDay] forState: UIControlStateNormal];
    }
}

- (NSDate*) dateWithBaseDate:(NSDate*)date calendar:(NSCalendar*)calendar
{
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit)
                                               fromDate:date];
    [components setDay:mDay];
    return [calendar dateFromComponents:components];
}

@end

/*--------------------------------------------------*/
