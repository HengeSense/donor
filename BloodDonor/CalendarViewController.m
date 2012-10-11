//
//  CalendarViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 13.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarInfoViewController.h"
#import "EventPlanningViewController.h"
#import "EventViewController.h"
#import "Common.h"
#import <Parse/Parse.h>

@interface CalendarViewController ()

- (void)showSlider;
- (void)hideSlider;

- (void)loadCalendar;
- (void)loadEvents;
- (NSDate *)previousMonthDate;
- (NSDate *)nextMonthDate;
- (void)createIcon:(UIButton *)button type:(NSNumber *)type delivery:(NSNumber *)delivery finished:(NSNumber *)finished;
- (void)createHolidays;

- (void)eventsResult:(NSArray *)result error:(NSError *)error;

@end

@implementation CalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        selectedDate = [[NSDate date] retain];
        holidays = [[NSMutableDictionary alloc] init];
        
        completedArray = [[NSMutableArray alloc] init];
        availableArray = [[NSMutableArray alloc] init];
        planningArray = [[NSMutableArray alloc] init];
        
        indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        indicatorView.backgroundColor = [UIColor blackColor];
        indicatorView.alpha = 0.5f;
        UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        indicator.frame = CGRectMake(160 - indicator.frame.size.width / 2.0f,
                                     240 - indicator.frame.size.height / 2.0f,
                                     indicator.frame.size.width,
                                     indicator.frame.size.height);
        [indicatorView addSubview:indicator];
        [indicator startAnimating];
        
        [self createHolidays];
    }
    return self;
}

#pragma mark Buttons click
- (IBAction)previousMonthButtonClick:(id)sender
{
    NSDate *oldDate = selectedDate;
    selectedDate = [[self previousMonthDate] retain];
    [oldDate release];
    [self loadCalendar];
    [self loadEvents];
}

- (IBAction)nextMonthButtonClick:(id)sender
{
    NSDate *oldDate = selectedDate;
    selectedDate = [[self nextMonthDate] retain];
    [oldDate release];
    [self loadCalendar];
    [self loadEvents];
}

- (IBAction)dayClick:(id)sender
{
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser)
    {
        UIButton *button = (UIButton *)sender;
        UIImageView *topImageView = (UIImageView *)[self.view viewWithTag:100 + button.tag];
        UIImageView *bottomImageView = (UIImageView *)[self.view viewWithTag:200 + button.tag];
        
        if ([[button titleColorForState:UIControlStateNormal] isEqual:[UIColor colorWithRed:211.0f/255.0f green:60.0f/255.0f blue:110.0f/255.0f alpha:1.0f]])
        {
            NSCalendar *currentCalendar = [NSCalendar currentCalendar];
            unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
            NSDateComponents *dateComponents = [currentCalendar components:unitFlags fromDate:selectedDate];
            dateComponents.day = [button.titleLabel.text intValue];
            
            for (NSDateComponents *key in holidays)
            {
                if (dateComponents.day == key.day &&
                    dateComponents.month == key.month)
                {
                    MessageBoxViewController *messageBox = [[MessageBoxViewController alloc] initWithNibName:@"MessageBoxViewController"
                                                                                                      bundle:nil
                                                                                                       title:@"Отметка недоступна"
                                                                                                     message:[NSString stringWithFormat:@"В этот день государственный праздник \"%@\".", [holidays objectForKey:key]]
                                                                                                cancelButton:@"Продолжить"
                                                                                                    okButton:nil];
                    messageBox.delegate = self;
                    [self.navigationController.tabBarController.view addSubview:messageBox.view];
                }
            }
        }
        else if (topImageView.image || bottomImageView.image)
        {
            PFRelation *eventsRelation = [currentUser relationforKey:@"events"];
            
            NSCalendar *currentCalendar = [NSCalendar currentCalendar];
            unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
            NSDateComponents *dateComponents = [currentCalendar components:unitFlags fromDate:selectedDate];
            
            dateComponents.day = [button.titleLabel.text intValue];
            dateComponents.hour = 0;
            dateComponents.minute = 0;
            NSDate *startDayDate = [currentCalendar dateFromComponents:dateComponents];
            
            dateComponents.day = [button.titleLabel.text intValue];
            dateComponents.hour = 23;
            dateComponents.minute = 59;
            NSDate *endDayDate = [currentCalendar dateFromComponents:dateComponents];
            
            PFQuery *eventsQuery = [eventsRelation query];
            [eventsQuery whereKey:@"date" greaterThanOrEqualTo:startDayDate];
            [eventsQuery whereKey:@"date" lessThanOrEqualTo:endDayDate];
            
            NSArray *eventsArray = [eventsQuery findObjects];
            PFObject *event = [eventsArray objectAtIndex:0];
            
            EventViewController *eventViewController = [[[EventViewController alloc] initWithNibName:@"EventViewController" bundle:nil event:event.objectId] autorelease];
            [self.navigationController pushViewController:eventViewController animated:YES];
        }
        else
        {
            NSCalendar *currentCalendar = [NSCalendar currentCalendar];
            unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
            NSDateComponents *dateComponents = [currentCalendar components:unitFlags fromDate:selectedDate];
            dateComponents.day = [button.titleLabel.text intValue];
            dateComponents.hour = 8;
            dateComponents.minute = 0;
            
            EventPlanningViewController *eventPlanningViewController = [[[EventPlanningViewController alloc] initWithNibName:@"EventPlanningViewController" bundle:nil event:@"" date:[currentCalendar dateFromComponents:dateComponents]] autorelease];
            [self.navigationController pushViewController:eventPlanningViewController animated:YES];
        }
    }
}

- (void)messageBoxResult:(BOOL)result controller:(MessageBoxViewController *)controller message:(NSString *)message
{
    if ([message isEqualToString:@"Вы сегодня сдавали кровь?"])
    {
        if (result)
        {
            PFUser *currentUser = [PFUser currentUser];
            PFRelation *eventsRelation = [currentUser relationforKey:@"events"];
            
            NSCalendar *currentCalendar = [NSCalendar currentCalendar];
            unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
            NSDateComponents *dateComponents = [currentCalendar components:unitFlags fromDate:[NSDate date]];
            
            dateComponents.hour = 0;
            dateComponents.minute = 0;
            NSDate *startDayDate = [currentCalendar dateFromComponents:dateComponents];
            
            dateComponents.hour = 23;
            dateComponents.minute = 59;
            NSDate *endDayDate = [currentCalendar dateFromComponents:dateComponents];
            
            PFQuery *eventsQuery = [eventsRelation query];
            [eventsQuery whereKey:@"date" greaterThanOrEqualTo:startDayDate];
            [eventsQuery whereKey:@"date" lessThanOrEqualTo:endDayDate];
            
            NSArray *eventsArray = [eventsQuery findObjects];
            PFObject *event = [eventsArray objectAtIndex:0];
            
            [event setObject:[NSNumber numberWithBool:YES] forKey:@"finished"];
            [event save];
            
            [eventsRelation addObject:event];
            [currentUser save];
            
            [self loadEvents];
        }
        else
        {
            //удалить?
        }
    }
    
    [controller release];
}

- (void)infoButtonClick:(id)sender
{
    CalendarInfoViewController *calendarInfoViewController = [[[CalendarInfoViewController alloc] initWithNibName:@"CalendarInfoViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:calendarInfoViewController animated:YES];
}

#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return completedArray.count;
        
        case 1:
            return availableArray.count;
            
        case 2:
            return planningArray.count;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    UIImageView *background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendarSliderCellBackground"]] autorelease];
    UIImageView *icon = [[[UIImageView alloc] init] autorelease];
    UILabel *dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(29, 0, 78, 33)] autorelease];
    UILabel *descriptionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(121, 0, 186, 33)] autorelease];
    
    int day = 1;
    int month = 1;
    int year = 1900;
    
    if (indexPath.section == 0)
    {
        NSDictionary *completedItem = [completedArray objectAtIndex:indexPath.row];
        NSDate *completedDate = [completedItem objectForKey:@"date"];
        NSDateComponents *completedDateComponents = [currentCalendar components:unitFlags fromDate:completedDate];
        
        day = completedDateComponents.day;
        month = completedDateComponents.month;
        year = completedDateComponents.year;
        
        if ([[completedItem objectForKey:@"type"] intValue] == 1)
        {
            switch ([[completedItem objectForKey:@"delivery"] intValue])
            {
                case 0:
                    icon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendarCompletedWholeBloodIcon"]] autorelease];
                    //icon.image = [UIImage imageNamed:@"сalendarCompletedWholeBloodIcon"];
                    descriptionLabel.text = @"Сданы тромбоциты";
                    break;
                    
                case 1:
                    icon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendarCompletedWholeBloodIcon"]] autorelease];
                    descriptionLabel.text = @"Сдана плазма";
                    break;
                    
                case 2:
                    icon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendarCompletedWholeBloodIcon"]] autorelease];
                    descriptionLabel.text = @"Сдана цельная кровь";
                    break;
                    
                default:
                    icon = [[[UIImageView alloc] init] autorelease];
                    break;
            }
        }
    }
    else if (indexPath.section == 1)
    {
        switch ([[availableArray objectAtIndex:indexPath.row] intValue])
        {
            case 0:
                icon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendarAvailablePlateletsIcon"]] autorelease];
                
                day = [Common getInstance].availablePlateletsDateComponents.day;
                month = [Common getInstance].availablePlateletsDateComponents.month;
                year = [Common getInstance].availablePlateletsDateComponents.year;
                
                descriptionLabel.text = @"Тромбоциты";
                break;
                
            case 1:
                icon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendarAvailablePlasmaIcon"]] autorelease];
                
                day = [Common getInstance].availablePlasmaDateComponents.day;
                month = [Common getInstance].availablePlasmaDateComponents.month;
                year = [Common getInstance].availablePlasmaDateComponents.year;
                
                descriptionLabel.text = @"Плазма";
                break;
                
            case 2:
                icon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendarAvailableWholeBloodIcon"]] autorelease];
                
                day = [Common getInstance].availableWholeBloodDateComponents.day;
                month = [Common getInstance].availableWholeBloodDateComponents.month;
                year = [Common getInstance].availableWholeBloodDateComponents.year;
                
                descriptionLabel.text = @"Цельная кровь";
                break;
                
            default:
                icon = [[[UIImageView alloc] init] autorelease];
                break;
        }
    }
    else if (indexPath.section == 2)
    {
        NSDictionary *planningItem = [planningArray objectAtIndex:indexPath.row];
        NSDate *planningDate = [planningItem objectForKey:@"date"];
        NSDateComponents *planningDateComponents = [currentCalendar components:unitFlags fromDate:planningDate];
        
        day = planningDateComponents.day;
        month = planningDateComponents.month;
        year = planningDateComponents.year;
        
        if ([[planningItem objectForKey:@"type"] intValue] == 0)
        {
            icon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendarScheduledTestIcon"]] autorelease];
            descriptionLabel.text = @"Анализ";
        }
        else
        {
            switch ([[planningItem objectForKey:@"delivery"] intValue])
            {
                case 0:
                    icon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendarScheduledPlateletsIcon"]] autorelease];
                    descriptionLabel.text = @"Тромбоциты";
                    break;
                    
                case 1:
                    icon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendarScheduledPlasmaIcon"]] autorelease];
                    descriptionLabel.text = @"Плазма";
                    break;
                    
                case 2:
                    icon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendarScheduledBloodIcon"]] autorelease];
                    descriptionLabel.text = @"Цельная кровь";
                    break;
                    
                default:
                    icon = [[[UIImageView alloc] init] autorelease];
                    break;
            }
        }
    }
    
    CGRect iconRect = icon.frame;
    iconRect.origin.y = 9;
    icon.frame = iconRect;
    
    NSString *dayString;
    NSString *monthString;
    NSString *yearString = [NSString stringWithFormat:@"%d", year - (year / 100) * 100];
    
    if (day < 10)
        dayString = [NSString stringWithFormat:@"0%d", day];
    else
        dayString = [NSString stringWithFormat:@"%d", day];
    
    if (month < 10)
        monthString = [NSString stringWithFormat:@"0%d", month];
    else
        monthString = [NSString stringWithFormat:@"%d", month];
    
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:1.0f];
    dateLabel.textAlignment = UITextAlignmentCenter;
    dateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    dateLabel.text = [NSString stringWithFormat:@"%@.%@.%@", dayString, monthString, yearString];
    
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    [tableViewCell addSubview:background];
    [tableViewCell addSubview:dateLabel];
    [tableViewCell addSubview:descriptionLabel];
    [tableViewCell addSubview:icon];
    
    return tableViewCell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *currentUser = [PFUser currentUser];
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    if (currentUser)
    {
        if (indexPath.section == 1)
        {
            NSDate *date = [NSDate date];
            switch ([[availableArray objectAtIndex:indexPath.row] intValue])
            {
                case 0:
                    date = [currentCalendar dateFromComponents:[Common getInstance].availablePlateletsDateComponents];
                    break;
                    
                case 1:
                    date = [currentCalendar dateFromComponents:[Common getInstance].availablePlasmaDateComponents];
                    break;
                    
                case 2:
                    date = [currentCalendar dateFromComponents:[Common getInstance].availableWholeBloodDateComponents];
                    break;
                    
                default:
                    break;
            }
            
            EventPlanningViewController *eventPlanningViewController = [[[EventPlanningViewController alloc] initWithNibName:@"EventPlanningViewController" bundle:nil event:@"" date:date] autorelease];
            [self.navigationController pushViewController:eventPlanningViewController animated:YES];
        }
        else
        {
            PFRelation *eventsRelation = [currentUser relationforKey:@"events"];
            NSDictionary *eventDictionary;
            if (indexPath.section == 0)
                eventDictionary = [completedArray objectAtIndex:indexPath.row];
            else if (indexPath.section == 2)
                eventDictionary = [planningArray objectAtIndex:indexPath.row];
            else
                return;
            
            NSDateComponents *dateComponents = [currentCalendar components:unitFlags fromDate:[eventDictionary objectForKey:@"date"]];
            dateComponents.hour = 0;
            dateComponents.minute = 0;
            NSDate *startDayDate = [currentCalendar dateFromComponents:dateComponents];
            
            dateComponents.hour = 23;
            dateComponents.minute = 59;
            NSDate *endDayDate = [currentCalendar dateFromComponents:dateComponents];
            
            PFQuery *eventsQuery = [eventsRelation query];
            [eventsQuery whereKey:@"date" greaterThanOrEqualTo:startDayDate];
            [eventsQuery whereKey:@"date" lessThanOrEqualTo:endDayDate];
            
            NSArray *eventsArray = [eventsQuery findObjects];
            PFObject *event = [eventsArray objectAtIndex:0];
            
            EventViewController *eventViewController = [[[EventViewController alloc] initWithNibName:@"EventViewController" bundle:nil event:event.objectId] autorelease];
            [self.navigationController pushViewController:eventViewController animated:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 307, 32)] autorelease];
    
    if (section > 0)
    {
        UIImageView *background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendarSliderSectionBackground"]] autorelease];
        
        UIImageView *icon;
        if (section == 1)
            icon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CalendarAvailableSectionIcon"]] autorelease];
        else
            icon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CalendarScheduledSectionIcon"]] autorelease];
        
        CGRect iconRect = icon.frame;
        iconRect.origin.x = 4;
        iconRect.origin.y = 6;
        icon.frame = iconRect;
        
        UILabel *sectionText = [[[UILabel alloc] initWithFrame:CGRectMake(28, 9, 251, 14)] autorelease];
        if (section == 1)
            sectionText.text = @"Можно сдать";
        else
            sectionText.text = @"Запланировано";
        sectionText.backgroundColor = [UIColor clearColor];
        sectionText.textColor = [UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
        sectionText.textAlignment = UITextAlignmentCenter;
        sectionText.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        
        [sectionView addSubview:background];
        [sectionView addSubview:icon];
        [sectionView addSubview:sectionText];
    }
    
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section > 0)
        return 32;
    else
        return 0;
}

#pragma mark TapRecognizer
- (IBAction)singleTapSlider:(UITapGestureRecognizer *)gestureRecognizer
{
    if (sliderView.frame.origin.y == 6)
        [self hideSlider];
    else
        [self showSlider];
}

- (IBAction)panGestureMoveAround:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:self.view];
    CGPoint newSliderOrigin = CGPointMake(sliderView.frame.origin.x, sliderView.frame.origin.y + translation.y);
    
    if ([gesture state] == UIGestureRecognizerStateBegan || [gesture state] == UIGestureRecognizerStateChanged)
    {
        if (newSliderOrigin.y >= 6 && newSliderOrigin.y <= 333)
        {
            sliderView.frame = CGRectMake(newSliderOrigin.x, newSliderOrigin.y, sliderView.frame.size.width, sliderView.frame.size.height);
            [gesture setTranslation:CGPointZero inView:self.view];
        }
    }
    else if ([gesture state] == UIGestureRecognizerStateEnded)
    {
        if (newSliderOrigin.y >= 6 && newSliderOrigin.y <= 169)
            [self showSlider];
        else if (newSliderOrigin.y <= 333 && newSliderOrigin.y >= 169)
            [self hideSlider];
    }
}

- (void)showSlider
{
    float animationDuration = 0.0009f * (sliderView.frame.origin.y - 6);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    sliderView.frame = CGRectMake(sliderView.frame.origin.x, 6, sliderView.frame.size.width, sliderView.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)hideSlider
{
    float animationDuration = 0.0009f * (333 - sliderView.frame.origin.y);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    sliderView.frame = CGRectMake(sliderView.frame.origin.x, 333, sliderView.frame.size.width, sliderView.frame.size.height);
    
    [UIView commitAnimations];
}

#pragma mark Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Календарь";
    
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *infoImageNormal = [UIImage imageNamed:@"calendarInfoButtonNormal"];
    UIImage *infoImagePressed = [UIImage imageNamed:@"calendarInfoButtonPressed"];
    CGRect infoButtonFrame = CGRectMake(0, 0, infoImageNormal.size.width, infoImageNormal.size.height);
    [infoButton setImage:infoImageNormal forState:UIControlStateNormal];
    [infoButton setImage:infoImagePressed forState:UIControlStateHighlighted];
    infoButton.frame = infoButtonFrame;
    [infoButton addTarget:self action:@selector(infoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *infoBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
    self.navigationItem.rightBarButtonItem = infoBarButtonItem;
    
    [self loadCalendar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadEvents];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [selectedDate release];
    [holidays release];
    [indicatorView release];
    [completedArray release];
    [availableArray release];
    [planningArray release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadCalendar
{
    if (currentDay > 0)
    {
        UIImageView *topImageView = (UIImageView *)[self.view viewWithTag:100 + currentDay];
        UIImageView *bottomImageView = (UIImageView *)[self.view viewWithTag:200 + currentDay];
        
        CGRect topImageViewRect = topImageView.frame;
        topImageViewRect.size.width += 4;
        topImageViewRect.size.height += 4;
        topImageViewRect.origin.y -= 4;
        topImageView.frame = topImageViewRect;
        
        CGRect bottomImageViewRect = bottomImageView.frame;
        bottomImageViewRect.size.width += 4;
        bottomImageViewRect.size.height += 4;
        bottomImageView.frame = bottomImageViewRect;
        
        currentDay = 0;
    }
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSRange daysInMonth = [currentCalendar rangeOfUnit:NSDayCalendarUnit
                                                inUnit:NSMonthCalendarUnit
                                               forDate:selectedDate];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *dateComponents = [currentCalendar components:unitFlags fromDate:selectedDate];
    NSDateComponents *weekdayComponents = [[[NSDateComponents alloc] init] autorelease];
    weekdayComponents.day = 1;
    weekdayComponents.month = dateComponents.month;
    weekdayComponents.year = dateComponents.year;
    weekdayComponents = [currentCalendar components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:[currentCalendar dateFromComponents:weekdayComponents]];
    
    NSDate *previousDate = [self previousMonthDate];
    NSRange daysInPreviousMonth = [currentCalendar rangeOfUnit:NSDayCalendarUnit 
                                                         inUnit:NSMonthCalendarUnit
                                                        forDate:previousDate];
    
    int startTag = [weekdayComponents weekday] - 1;
    if (startTag == 0)
        startTag = 7;
    
    int iPrevious = daysInPreviousMonth.length - startTag + 2;
    int iNext = 1;
    for (int i = 0; i < 42; i++)
    {
        UIButton *button = (UIButton *)[self.view viewWithTag:i + 1];
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setBackgroundImage:nil forState:UIControlStateHighlighted];
        [button setBackgroundImage:nil forState:UIControlStateDisabled];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
        //UIImageView *imageView = (UIImageView *)[self.view viewWithTag:100 + i + 1];
        //imageView.image = nil;
        
        NSString *buttonTitle;
        if (i < startTag - 1)
        {
            buttonTitle = [NSString stringWithFormat:@"%d", iPrevious];
            button.enabled = NO;
            iPrevious++;
        }
        else if (i > daysInMonth.length + startTag - 2)
        {
            buttonTitle = [NSString stringWithFormat:@"%d", iNext];
            button.enabled = NO;
            iNext++;
        }
        else
        {
            NSDateComponents *currentDateComponents = [currentCalendar components:unitFlags fromDate:[NSDate date]];
            
            if (currentDateComponents.day  == i - startTag + 2 &&
                currentDateComponents.month == dateComponents.month &&
                currentDateComponents.year == dateComponents.year)
            {
                [button setBackgroundImage:[UIImage imageNamed:@"calendarItemBorder"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"calendarItemBorder"] forState:UIControlStateHighlighted];
                [button setBackgroundImage:[UIImage imageNamed:@"calendarItemBorder"] forState:UIControlStateDisabled];
                
                currentDay = button.tag;
            }
            
            for (NSDateComponents *key in holidays)
            {
                if (i - startTag + 2 == key.day &&
                    dateComponents.month == key.month)
                {
                    [button setTitleColor:[UIColor colorWithRed:211.0f/255.0f green:60.0f/255.0f blue:110.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithRed:211.0f/255.0f green:60.0f/255.0f blue:110.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
                }
            }
            
            buttonTitle = [NSString stringWithFormat:@"%d", i - startTag + 2];
            button.enabled = YES;
        }
        
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitle:buttonTitle forState:UIControlStateHighlighted];
        [button setTitle:buttonTitle forState:UIControlStateDisabled];
    }
    
    NSString *monthString;
    int month = dateComponents.month;
    switch (month)
    {
        case 1:
            monthString = @"Январь";
            break;
            
        case 2:
            monthString = @"Февраль";
            break;
            
        case 3:
            monthString = @"Март";
            break;
            
        case 4:
            monthString = @"Апрель";
            break;
            
        case 5:
            monthString = @"Май";
            break;
            
        case 6:
            monthString = @"Июнь";
            break;
            
        case 7:
            monthString = @"Июль";
            break;
            
        case 8:
            monthString = @"Август";
            break;
            
        case 9:
            monthString = @"Сентябрь";
            break;
            
        case 10:
            monthString = @"Октябрь";
            break;
            
        case 11:
            monthString = @"Ноябрь";
            break;
            
        case 12:
            monthString = @"Декабрь";
            break;
            
        default:
            monthString = @"";
            break;
    }
    
    monthLabel.text = monthString;
    sliderMonthLabel.text = [NSString stringWithFormat:@"%@ %d", monthString, dateComponents.year];
    
    if (currentDay > 0)
    {
        UIImageView *topImageView = (UIImageView *)[self.view viewWithTag:100 + currentDay];
        UIImageView *bottomImageView = (UIImageView *)[self.view viewWithTag:200 + currentDay];
        
        CGRect topImageViewRect = topImageView.frame;
        topImageViewRect.size.width -= 4;
        topImageViewRect.size.height -= 4;
        topImageViewRect.origin.y += 4;
        topImageView.frame = topImageViewRect;
        
        CGRect bottomImageViewRect = bottomImageView.frame;
        bottomImageViewRect.size.width -= 4;
        bottomImageViewRect.size.height -= 4;
        bottomImageView.frame = bottomImageViewRect;
    }
}

- (void)loadEvents
{
    [completedArray removeAllObjects];
    [planningArray removeAllObjects];
    
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *eventsRelation;
    if (currentUser)
    {
        eventsRelation = [currentUser relationforKey:@"events"];
        
        PFQuery *eventsQuery = [eventsRelation query];
        [eventsQuery orderByDescending:@"date"];
        
        [self.navigationController.tabBarController.view addSubview:indicatorView];
        [eventsQuery findObjectsInBackgroundWithTarget:self selector:@selector(eventsResult:error:)];
    }
    else
    {
        MessageBoxViewController *messageBox = [[MessageBoxViewController alloc] initWithNibName:@"MessageBoxViewController"
                                                                                          bundle:nil
                                                                                           title:@""
                                                                                         message:@"Для добавления события в календарь необходимо пройти регистрацию"
                                                                                    cancelButton:@"Ok"
                                                                                        okButton:nil];
        
        messageBox.delegate = self;
        
        [self.navigationController.tabBarController.view addSubview:messageBox.view];
        [self eventsResult:[NSArray array] error:nil];
    }
}

- (void)eventsResult:(NSArray *)result error:(NSError *)error
{
    NSMutableArray *plateletsDateArray = [NSMutableArray array];
    NSMutableArray *plasmaDateArray = [NSMutableArray array];
    NSMutableArray *wholeBloodDateArray = [NSMutableArray array];
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [currentCalendar components:unitFlags fromDate:selectedDate];
    
    NSDateComponents *lastPlateletsDateComponents = nil;
    NSDateComponents *lastPlasmaDateComponents = nil;
    NSDateComponents *lastWholeBloodDateComponents = nil;
    
    int plateletsCount = 0;
    int plasmaCount = 0;
    int wholeBloodCount = 0;
    
    int allWholeBloodCount = 0;
    
    NSDate *lastAllWholeBloodDate = nil;
    int lastIndex = -1;
    
    for (int i = 0; i < 42; i++)
    {
        UIImageView *topImageView = (UIImageView *)[self.view viewWithTag:100 + i + 1];
        topImageView.image = nil;
        UIImageView *bottomImageView = (UIImageView *)[self.view viewWithTag:200 + i + 1];
        bottomImageView.image = nil;
        
        UIButton *button = (UIButton *)[self.view viewWithTag:i + 1];
        if (button.enabled)
        {
            for (int j = 0; j < result.count; j++)
            {
                if (lastIndex < 0)
                    lastIndex = i;
                
                PFObject *event = [result objectAtIndex:j];
                NSDateComponents *eventDateComponents = [currentCalendar components:unitFlags fromDate:[event valueForKey:@"date"]];
                
                if (i == lastIndex)
                {
                    int eventDelivery = [[event valueForKey:@"delivery"] intValue];
                    int eventType = [[event valueForKey:@"type"] intValue];
                    
                    //для статистики//
                    if (eventType != 0 && [[event valueForKey:@"finished"] boolValue])
                    {
                        allWholeBloodCount++;
                        lastAllWholeBloodDate = [event valueForKey:@"date"];
                    }
                    //////////////////

                    
                    eventDateComponents.year += 1;
                    NSDate *eventDatePlusYear = [currentCalendar dateFromComponents:eventDateComponents];
                    eventDateComponents.year -= 1;
                    
                    if (eventDatePlusYear.timeIntervalSince1970 > [[NSDate date] timeIntervalSince1970] && eventType != 0)
                    {
                        switch (eventDelivery)
                        {
                            case 0:
                                [plateletsDateArray addObject:[currentCalendar dateFromComponents:eventDateComponents]];
                                plateletsCount++;
                                break;
                                
                            case 1:
                                [plasmaDateArray addObject:[currentCalendar dateFromComponents:eventDateComponents]];
                                plasmaCount++;
                                break;
                                
                            case 2:
                                [wholeBloodDateArray addObject:[currentCalendar dateFromComponents:eventDateComponents]];
                                wholeBloodCount++;
                                break;
                                
                            default:
                                break;
                        }
                    }
                    
                    if (eventType != 0)
                    {
                        if (!lastPlateletsDateComponents && eventDelivery == 0)
                            lastPlateletsDateComponents = eventDateComponents;
                        else if (!lastPlasmaDateComponents && eventDelivery == 1)
                            lastPlasmaDateComponents = eventDateComponents;
                        else if (!lastWholeBloodDateComponents && eventDelivery == 2)
                            lastWholeBloodDateComponents = eventDateComponents;
                    }
                }
                
                if (eventDateComponents.day == [button.titleLabel.text intValue] &&
                    dateComponents.month == eventDateComponents.month &&
                    dateComponents.year == eventDateComponents.year)
                {
                    if ([[event valueForKey:@"finished"] boolValue])
                    {
                        NSDictionary *completedItem = [NSDictionary dictionaryWithObjectsAndKeys:[event valueForKey:@"type"], @"type",
                                                       [event valueForKey:@"delivery"], @"delivery",
                                                       [event valueForKey:@"date"], @"date",
                                                       nil];
                        [completedArray addObject:completedItem];
                    }
                    else
                    {
                        NSDictionary *planningItem;
                        if ([[event valueForKey:@"type"] intValue] == 0)
                            planningItem = [NSDictionary dictionaryWithObjectsAndKeys:[event valueForKey:@"type"], @"type",
                                            [event valueForKey:@"date"], @"date",
                                            nil];
                        else
                            planningItem = [NSDictionary dictionaryWithObjectsAndKeys:[event valueForKey:@"type"], @"type",
                                            [event valueForKey:@"delivery"], @"delivery",
                                            [event valueForKey:@"date"], @"date",
                                            nil];
                        
                        [planningArray addObject:planningItem];
                    }
                    
                    [self createIcon:button
                                type:[event valueForKey:@"type"]
                            delivery:[event valueForKey:@"delivery"]
                            finished:[event valueForKey:@"finished"]];
                }
            }
        }
    }
    
    NSDate *availablePlateletsDate1 = [NSDate dateWithTimeIntervalSince1970:0];
    NSDate *availablePlateletsDate2 = [NSDate dateWithTimeIntervalSince1970:0];
    NSDate *availablePlateletsDate3 = [NSDate dateWithTimeIntervalSince1970:0];
    NSDate *availablePlasmaDate1 = [NSDate dateWithTimeIntervalSince1970:0];
    NSDate *availablePlasmaDate2 = [NSDate dateWithTimeIntervalSince1970:0];
    NSDate *availablePlasmaDate3 = [NSDate dateWithTimeIntervalSince1970:0];
    NSDate *availableWholeBloodDate1 = [NSDate dateWithTimeIntervalSince1970:0];
    NSDate *availableWholeBloodDate2 = [NSDate dateWithTimeIntervalSince1970:0];
    NSDate *availableWholeBloodDate3 = [NSDate dateWithTimeIntervalSince1970:0];
    
    //для статистики
    
    [Common getInstance].lastWholeBloodDate = lastAllWholeBloodDate;
    
    [Common getInstance].wholeBloodCount = allWholeBloodCount;
    
    if (lastPlateletsDateComponents)
    {
        //плазма
        lastPlateletsDateComponents.day += 15;
        availablePlateletsDate1 = [currentCalendar dateFromComponents:lastPlateletsDateComponents];
        availablePlasmaDate1 = [currentCalendar dateFromComponents:lastPlateletsDateComponents];
        lastPlateletsDateComponents.day -= 15;
        
        //цельная кровь
        lastPlateletsDateComponents.day += 31;
        availableWholeBloodDate1 = [currentCalendar dateFromComponents:lastPlateletsDateComponents];
        lastPlateletsDateComponents.day -= 31;
    }
    
    if (lastPlasmaDateComponents)
    {
        lastPlasmaDateComponents.day += 15;
        availablePlateletsDate2 = [currentCalendar dateFromComponents:lastPlasmaDateComponents];
        availablePlasmaDate2 = [currentCalendar dateFromComponents:lastPlasmaDateComponents];
        availableWholeBloodDate2 = [currentCalendar dateFromComponents:lastPlasmaDateComponents];
        lastPlasmaDateComponents.day -= 15;
    }
    
    if (lastWholeBloodDateComponents)
    {
        //Тромбоциты и плазма
        lastWholeBloodDateComponents.day += 31;
        availablePlateletsDate3 = [currentCalendar dateFromComponents:lastWholeBloodDateComponents];
        availablePlasmaDate3 = [currentCalendar dateFromComponents:lastWholeBloodDateComponents];
        lastWholeBloodDateComponents.day -= 31;
        
        //Цельная кровь
        lastWholeBloodDateComponents.day += 61;
        availableWholeBloodDate3 = [currentCalendar dateFromComponents:lastWholeBloodDateComponents];
        lastWholeBloodDateComponents.day -= 61;
    }
    
    if (availablePlateletsDate1.timeIntervalSince1970 > availablePlateletsDate2.timeIntervalSince1970)
    {
        if (availablePlateletsDate1.timeIntervalSince1970 > availablePlateletsDate3.timeIntervalSince1970)
            [Common getInstance].availablePlateletsDateComponents = [currentCalendar components:unitFlags fromDate:availablePlateletsDate1];
        else
            [Common getInstance].availablePlateletsDateComponents = [currentCalendar components:unitFlags fromDate:availablePlateletsDate3];
    }
    else
    {
        if (availablePlateletsDate2.timeIntervalSince1970 > availablePlateletsDate3.timeIntervalSince1970)
            [Common getInstance].availablePlateletsDateComponents = [currentCalendar components:unitFlags fromDate:availablePlateletsDate2];
        else
            [Common getInstance].availablePlateletsDateComponents = [currentCalendar components:unitFlags fromDate:availablePlateletsDate3];
    }
    
    if (availablePlasmaDate1.timeIntervalSince1970 > availablePlasmaDate2.timeIntervalSince1970)
    {
        if (availablePlasmaDate1.timeIntervalSince1970 > availablePlasmaDate3.timeIntervalSince1970)
            [Common getInstance].availablePlasmaDateComponents = [currentCalendar components:unitFlags fromDate:availablePlasmaDate1];
        else
            [Common getInstance].availablePlasmaDateComponents = [currentCalendar components:unitFlags fromDate:availablePlasmaDate3];
    }
    else
    {
        if (availablePlasmaDate2.timeIntervalSince1970 > availablePlasmaDate3.timeIntervalSince1970)
            [Common getInstance].availablePlasmaDateComponents = [currentCalendar components:unitFlags fromDate:availablePlasmaDate2];
        else
            [Common getInstance].availablePlasmaDateComponents = [currentCalendar components:unitFlags fromDate:availablePlasmaDate3];
    }
    
    if (availableWholeBloodDate1.timeIntervalSince1970 > availableWholeBloodDate2.timeIntervalSince1970)
    {
        if (availableWholeBloodDate1.timeIntervalSince1970 > availableWholeBloodDate3.timeIntervalSince1970)
            [Common getInstance].availableWholeBloodDateComponents = [currentCalendar components:unitFlags fromDate:availableWholeBloodDate1];
        else
            [Common getInstance].availableWholeBloodDateComponents = [currentCalendar components:unitFlags fromDate:availableWholeBloodDate3];
    }
    else
    {
        if (availableWholeBloodDate2.timeIntervalSince1970 > availableWholeBloodDate3.timeIntervalSince1970)
            [Common getInstance].availableWholeBloodDateComponents = [currentCalendar components:unitFlags fromDate:availableWholeBloodDate2];
        else
            [Common getInstance].availableWholeBloodDateComponents = [currentCalendar components:unitFlags fromDate:availableWholeBloodDate3];
    }
    
    if (plateletsCount >= 10)
    {
        NSDate *availablePlateletsDateYear = [plateletsDateArray objectAtIndex:plateletsDateArray.count - 10];
        NSDateComponents *availablePlateletsDateComponentsYear = [currentCalendar components:unitFlags fromDate:availablePlateletsDateYear];
        availablePlateletsDateComponentsYear.year += 1;
        availablePlateletsDateYear = [currentCalendar dateFromComponents:availablePlateletsDateComponentsYear];
        if (availablePlateletsDateYear.timeIntervalSince1970 > [currentCalendar dateFromComponents:[Common getInstance].availablePlateletsDateComponents].timeIntervalSince1970)
            [Common getInstance].availablePlateletsDateComponents = [currentCalendar components:unitFlags fromDate:availablePlateletsDateYear];
    }
    
    if (plasmaCount >= 12)
    {
        NSDate *availablePlasmaDateYear = [plasmaDateArray objectAtIndex:plasmaDateArray.count - 12];
        NSDateComponents *availablePlasmaDateComponentsYear = [currentCalendar components:unitFlags fromDate:availablePlasmaDateYear];
        availablePlasmaDateComponentsYear.year += 1;
        availablePlasmaDateYear = [currentCalendar dateFromComponents:availablePlasmaDateComponentsYear];
        if (availablePlasmaDateYear.timeIntervalSince1970 > [currentCalendar dateFromComponents:[Common getInstance].availablePlasmaDateComponents].timeIntervalSince1970)
            [Common getInstance].availablePlasmaDateComponents = [currentCalendar components:unitFlags fromDate:availablePlasmaDateYear];
    }
    
    int sex = [[[PFUser currentUser] objectForKey:@"Sex"] intValue];
    
    if (sex == 0)
    {
        if (wholeBloodCount >= 5)
        {
            NSDate *availableWholeBloodDateYear = [wholeBloodDateArray objectAtIndex:wholeBloodDateArray.count - 5];
            NSDateComponents *availableWholeBloodDateComponentsYear = [currentCalendar components:unitFlags fromDate:availableWholeBloodDateYear];
            availableWholeBloodDateComponentsYear.year += 1;
            availableWholeBloodDateYear = [currentCalendar dateFromComponents:availableWholeBloodDateComponentsYear];
            if (availableWholeBloodDateYear.timeIntervalSince1970 > [currentCalendar dateFromComponents:[Common getInstance].availableWholeBloodDateComponents].timeIntervalSince1970)
                [Common getInstance].availableWholeBloodDateComponents = [currentCalendar components:unitFlags fromDate:availableWholeBloodDateYear];
        }
    }
    else
    {
        if (wholeBloodCount >= 4)
        {
            NSDate *availableWholeBloodDateYear = [wholeBloodDateArray objectAtIndex:wholeBloodDateArray.count - 4];
            NSDateComponents *availableWholeBloodDateComponentsYear = [currentCalendar components:unitFlags fromDate:availableWholeBloodDateYear];
            availableWholeBloodDateComponentsYear.year += 1;
            availableWholeBloodDateYear = [currentCalendar dateFromComponents:availableWholeBloodDateComponentsYear];
            if (availableWholeBloodDateYear.timeIntervalSince1970 > [currentCalendar dateFromComponents:[Common getInstance].availableWholeBloodDateComponents].timeIntervalSince1970)
                [Common getInstance].availableWholeBloodDateComponents = [currentCalendar components:unitFlags fromDate:availableWholeBloodDateYear];
        }
    }
    
    if ([PFUser currentUser])
    
    [availableArray removeAllObjects];
    if ([Common getInstance].availablePlateletsDateComponents.month == dateComponents.month && [Common getInstance].isNeedPlateletsPush)
        [availableArray addObject:[NSNumber numberWithInt:0]];
    if ([Common getInstance].availablePlasmaDateComponents.month == dateComponents.month && [Common getInstance].isNeedPlasmaPush)
        [availableArray addObject:[NSNumber numberWithInt:1]];
    if ([Common getInstance].availableWholeBloodDateComponents.month == dateComponents.month && [Common getInstance].isNeedWholeBloodPush)
        [availableArray addObject:[NSNumber numberWithInt:2]];
    
    [sliderTableView reloadData];
    
    [indicatorView removeFromSuperview];
}

- (NSDate *)previousMonthDate
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [currentCalendar components:unitFlags fromDate:selectedDate];
    NSDateComponents *previousDateComponents = [[[NSDateComponents alloc] init] autorelease];
    previousDateComponents.day = 1;
    if (dateComponents.month - 1 < 1)
    {
        previousDateComponents.month = 12;
        previousDateComponents.year = dateComponents.year - 1;
    }
    else
    {
        previousDateComponents.month = dateComponents.month - 1;
        previousDateComponents.year = dateComponents.year;
    }
    return [currentCalendar dateFromComponents:previousDateComponents];
}

- (NSDate *)nextMonthDate
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [currentCalendar components:unitFlags fromDate:selectedDate];
    NSDateComponents *previousDateComponents = [[[NSDateComponents alloc] init] autorelease];
    previousDateComponents.day = 1;
    if (dateComponents.month + 1 > 12)
    {
        previousDateComponents.month = 1;
        previousDateComponents.year = dateComponents.year + 1;
    }
    else
    {
        previousDateComponents.month = dateComponents.month + 1;
        previousDateComponents.year = dateComponents.year;
    }
    return [currentCalendar dateFromComponents:previousDateComponents];
}

- (void)createIcon:(UIButton *)button type:(NSNumber *)type delivery:(NSNumber *)delivery finished:(NSNumber *)finished
{
    UIImageView *topImageView = (UIImageView *)[self.view viewWithTag:100 + button.tag];
    UIImageView *bottomImageView = (UIImageView *)[self.view viewWithTag:200 + button.tag];
    
    if ([finished boolValue])
    {
        bottomImageView.image = [UIImage imageNamed:@"calendarCompletedWholeBloodIcon"];
    }
    else
    {
        if (type)
        {
            switch ([type intValue])
            {
                case 0:
                    topImageView.image = [UIImage imageNamed:@"calendarScheduledTestIcon"];
                    break;
                    
                case 1:
                    if (delivery)
                    {
                        switch ([delivery intValue])
                        {
                            case 0:
                                bottomImageView.image = [UIImage imageNamed:@"calendarScheduledPlateletsIcon"];
                                break;
                                
                            case 1:
                                bottomImageView.image = [UIImage imageNamed:@"calendarScheduledPlasmaIcon"];
                                break;
                                
                            case 2:
                                bottomImageView.image = [UIImage imageNamed:@"calendarScheduledBloodIcon"];
                                break;
                                
                            default:
                                break;
                        }
                    }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void)createHolidays
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    unsigned holidayFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [currentCalendar components:holidayFlags fromDate:[NSDate date]];
    
    //1 января
    dateComponents.day = 1;
    dateComponents.month = 1;
    [holidays setObject:@"Новогодние каникулы" forKey:dateComponents];
    
    //2 января
    dateComponents.day = 2;
    dateComponents.month = 1;
    [holidays setObject:@"Новогодние каникулы" forKey:dateComponents];
    
    //3 января
    dateComponents.day = 3;
    dateComponents.month = 1;
    [holidays setObject:@"Новогодние каникулы" forKey:dateComponents];
    
    //4 января
    dateComponents.day = 4;
    dateComponents.month = 1;
    [holidays setObject:@"Новогодние каникулы" forKey:dateComponents];
    
    //5 января
    dateComponents.day = 5;
    dateComponents.month = 1;
    [holidays setObject:@"Новогодние каникулы" forKey:dateComponents];
    
    //6 января
    dateComponents.day = 6;
    dateComponents.month = 1;
    [holidays setObject:@"Новогодние каникулы" forKey:dateComponents];
    
    //7 января
    dateComponents.day = 7;
    dateComponents.month = 1;
    [holidays setObject:@"Рождество Христово" forKey:dateComponents];
    
    //8 января
    dateComponents.day = 8;
    dateComponents.month = 1;
    [holidays setObject:@"Новогодние каникулы" forKey:dateComponents];
    
    //23 февраля
    dateComponents.day = 23;
    dateComponents.month = 2;
    [holidays setObject:@"День защитника Отечества" forKey:dateComponents];
    
    //8 марта
    dateComponents.day = 8;
    dateComponents.month = 3;
    [holidays setObject:@"Международный женский день" forKey:dateComponents];
    
    //1 мая
    dateComponents.day = 1;
    dateComponents.month = 5;
    [holidays setObject:@"Праздник весны и труда" forKey:dateComponents];
    
    //9 мая
    dateComponents.day = 9;
    dateComponents.month = 5;
    [holidays setObject:@"День Победы" forKey:dateComponents];
    
    //12 июня
    dateComponents.day = 12;
    dateComponents.month = 6;
    [holidays setObject:@"День России" forKey:dateComponents];
    
    //4 ноября
    dateComponents.day = 4;
    dateComponents.month = 11;
    [holidays setObject:@"День народного единства" forKey:dateComponents];
}

@end
