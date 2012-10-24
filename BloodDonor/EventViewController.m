//
//  EventViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 23.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventViewController.h"
#import "EventPlanningViewController.h"

@interface EventViewController ()

- (void)eventResult:(PFObject *)event error:(NSError *)error;

@end

@implementation EventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(NSString *)event
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        eventId = [event retain];
        
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
    }
    return self;
}

#pragma mark Buttons click
- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editButtonClick:(id)sender
{
    EventPlanningViewController *eventPlanningViewController = [[[EventPlanningViewController alloc] initWithNibName:@"EventPlanningViewController" bundle:nil event:eventId date:eventDate] autorelease];
    [self.navigationController pushViewController:eventPlanningViewController animated:YES];
}

#pragma mark Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Событие";
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *barImageNormal = [UIImage imageNamed:@"barButtonNormal"];
    UIImage *barImagePressed = [UIImage imageNamed:@"barButtonPressed"];
    CGRect editButtonFrame = CGRectMake(0, 0, barImageNormal.size.width, barImageNormal.size.height);
    [editButton setBackgroundImage:barImageNormal forState:UIControlStateNormal];
    [editButton setBackgroundImage:barImagePressed forState:UIControlStateHighlighted];
    [editButton setTitle:@"Изменить" forState:UIControlStateNormal];
    [editButton setTitle:@"Изменить" forState:UIControlStateHighlighted];
    editButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    editButton.frame = editButtonFrame;
    [editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *editBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editButton] autorelease];
    [editBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = editBarButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController.tabBarController.view addSubview:indicatorView];
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Events"];
    [eventQuery getObjectInBackgroundWithId:eventId target:self selector:@selector(eventResult:error:)];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [eventId release];
    [eventDate release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)eventResult:(PFObject *)event error:(NSError *)error
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    eventDate = [event valueForKey:@"date"];
    
    NSString *dayString;
    NSString *monthString;
    NSString *hourString;
    NSString *minuteString;
    
    int day = [currentCalendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:eventDate];
    int month = [currentCalendar ordinalityOfUnit:NSMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:eventDate];
    int hour = [currentCalendar ordinalityOfUnit:NSHourCalendarUnit inUnit:NSDayCalendarUnit forDate:eventDate] - 1;
    int minute = [currentCalendar ordinalityOfUnit:NSMinuteCalendarUnit inUnit:NSHourCalendarUnit forDate:eventDate] - 1;
    
    if (day < 10)
        dayString = [NSString stringWithFormat:@"0%d", day];
    else
        dayString = [NSString stringWithFormat:@"%d", day];
    
    if (month < 10)
        monthString = [NSString stringWithFormat:@"0%d", month];
    else
        monthString = [NSString stringWithFormat:@"%d", month];
    
    if (hour < 10)
        hourString = [NSString stringWithFormat:@"0%d", hour];
    else
        hourString = [NSString stringWithFormat:@"%d", hour];
    
    if (minute < 10)
        minuteString = [NSString stringWithFormat:@"0%d", minute];
    else
        minuteString = [NSString stringWithFormat:@"%d", minute];
    
    NSString *dateString = [NSString stringWithFormat:@"%@.%@. %@:%@", dayString, monthString, hourString, minuteString];
    [eventTestDateButton setTitle:dateString forState:UIControlStateNormal];
    [eventTestDateButton setTitle:dateString forState:UIControlStateHighlighted];
    [eventBloodDonateDateButton setTitle:dateString forState:UIControlStateNormal];
    [eventBloodDonateDateButton setTitle:dateString forState:UIControlStateHighlighted];
    
    eventTestLocationLabel.text = [event valueForKey:@"adress"];
    eventBloodDonateLocationLabel.text = [event valueForKey:@"adress"];
    
    eventTestCommentLabel.text = [event valueForKey:@"comment"];
    eventBloodDonateCommentLabel.text = [event valueForKey:@"comment"];
    
    if ([[event valueForKey:@"type"] intValue] == 0)
    {
        [bloodDonateView removeFromSuperview];
        
        scrollView.contentSize = testView.frame.size;
        [scrollView addSubview:testView];
        
        int notice = [[event valueForKey:@"notice"] intValue];
        NSString *noticeString;
        switch (notice)
        {
            case 0:
                noticeString = @"нет";
                break;
                
            case 1:
                noticeString = @"за 3 мин";
                break;
                
            case 2:
                noticeString = @"за 5 мин";
                break;
                
            case 3:
                noticeString = @"за 10 мин";
                break;
                
            case 4:
                noticeString = @"за 15 мин";
                break;
                
            default:
                noticeString = @"";
                break;
        }
        
        [eventTestReminderDateButton setTitle:noticeString forState:UIControlStateNormal];
        [eventTestReminderDateButton setTitle:noticeString forState:UIControlStateHighlighted];
        
        BOOL isKnow = [[event valueForKey:@"analysisResult"] boolValue];
        if (isKnow)
        {
            [eventTestReminderKnowButton setTitle:@"да" forState:UIControlStateNormal];
            [eventTestReminderKnowButton setTitle:@"да" forState:UIControlStateHighlighted];
        }
        else
        {
            [eventTestReminderKnowButton setTitle:@"нет" forState:UIControlStateNormal];
            [eventTestReminderKnowButton setTitle:@"нет" forState:UIControlStateHighlighted];
        }
    }
    else if ([[event valueForKey:@"type"] intValue] == 1)
    {
        [testView removeFromSuperview];
        
        scrollView.contentSize = bloodDonateView.frame.size;
        [scrollView addSubview:bloodDonateView];
        
        int delivery = [[event valueForKey:@"delivery"] intValue];
        switch (delivery)
        {
            case 0:
                eventBloodDonateTypeLabel.text = @"Тромбоциты";
                break;
                
            case 1:
                eventBloodDonateTypeLabel.text = @"Плазма";
                break;
                
            case 2:
                eventBloodDonateTypeLabel.text = @"Цельная кровь";
                break;
                
            default:
                break;
        }
    }
    
    [indicatorView removeFromSuperview];
}

@end
