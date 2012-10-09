//
//  EventPlanningViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 23.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventPlanningViewController.h"
#import "EventReminderViewController.h"
#import "MessageBoxViewController.h"
#import "CalendarViewController.h"
#import "StationsViewController.h"
#import "Common.h"
#import <Parse/Parse.h>

@interface EventPlanningViewController ()

- (void)eventResult:(PFObject *)event error:(NSError *)error;
- (void)saveResult:(PFObject *)event error:(NSError *)error;
- (void)removeResult:(PFObject *)event error:(NSError *)error;

@end

@implementation EventPlanningViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(NSString *)event date:(NSDate *)date
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        isTest = NO;
        eventId = [event retain];
        
        typeDonateArray = [[NSArray arrayWithObjects:@"Тромбоциты",
                            @"Плазма",
                            @"Цельная кровь",
                            nil] retain];
        
        daysArray = [[NSMutableArray array] retain];
        NSCalendar *currentCalendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        
        NSDateComponents *dateComponents = [currentCalendar components:unitFlags fromDate:date];
        dateComponents.day = 1;
        dateComponents.month = 1;
        year = dateComponents.year;
        
        for (int i = 0; i < 366; i++)
        {
            NSDate *currentDate = [currentCalendar dateFromComponents:dateComponents];
            dateComponents = [currentCalendar components:unitFlags fromDate:currentDate];
            
            NSString *dayString;
            NSString *monthString;
            
            if (dateComponents.day < 10)
                dayString = [NSString stringWithFormat:@"0%d", dateComponents.day];
            else
                dayString = [NSString stringWithFormat:@"%d", dateComponents.day];
            
            if (dateComponents.month < 10)
                monthString = [NSString stringWithFormat:@"0%d", dateComponents.month];
            else
                monthString = [NSString stringWithFormat:@"%d", dateComponents.month];
            
            [daysArray addObject:[NSString stringWithFormat:@"%@.%@", dayString, monthString]];
            
            dateComponents.day++;
        }
        
        hoursArray = [[NSArray arrayWithObjects:@"00", @"01", @"02", @"03", @"04", @"05",
                      @"06", @"07", @"08", @"09", @"10", @"11",
                      @"12", @"13", @"14", @"15", @"16", @"17",
                      @"18", @"19", @"20", @"21", @"22", @"23",
                      nil] retain];
        minutesArray = [[NSArray arrayWithObjects:@"00", @"05", @"10", @"15", @"20", @"25",
                      @"30", @"35", @"40", @"45", @"50", @"55",
                      nil] retain];
        
        [Common getInstance].eventTimeReminderIndex = -1;
        eventTimeReminderIndex = 0;
        typeDonate = 0;
        bloodDonateDay = [currentCalendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:date] - 1;
        testDay = bloodDonateDay;
        bloodDonateHour = [currentCalendar ordinalityOfUnit:NSHourCalendarUnit inUnit:NSDayCalendarUnit forDate:date] - 1;
        testHour = bloodDonateHour;
        bloodDonateMinute = [currentCalendar ordinalityOfUnit:NSMinuteCalendarUnit inUnit:NSHourCalendarUnit forDate:date] / 5;
        testMinute = bloodDonateMinute;
        
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
- (IBAction)cancelClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneClick:(id)sender
{
    [self.navigationController.tabBarController.view addSubview:indicatorView];
    
    if ([eventId isEqualToString:@""])
    {
        [self saveResult:nil error:nil];
    }
    else
    {
        PFQuery *eventQuery = [PFQuery queryWithClassName:@"Events"];
        [eventQuery getObjectInBackgroundWithId:eventId target:self selector:@selector(saveResult:error:)];
    }
}

- (void)saveResult:(PFObject *)event error:(NSError *)error
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *dateComponents = [currentCalendar components:unitFlags fromDate:[NSDate date]];
    dateComponents.month = 1;
    dateComponents.year = year;
    
    if (isTest)
    {
        dateComponents.day = testDay + 1;
        dateComponents.hour = testHour;
        dateComponents.minute = testMinute * 5;
    }
    else
    {
        dateComponents.day = bloodDonateDay + 1;
        dateComponents.hour = bloodDonateHour;
        dateComponents.minute = bloodDonateMinute * 5;
    }
    
    NSDate *selectedDate = [currentCalendar dateFromComponents:dateComponents];
    
    BOOL isCorrect = YES;
    BOOL isFinished = NO;
    if (selectedDate.timeIntervalSince1970 <= [[NSDate date] timeIntervalSince1970])
    {
        /*if (!event)
        {
            NSArray *viewControllers = [self.navigationController viewControllers];
            CalendarViewController *calendarViewController = [viewControllers objectAtIndex:viewControllers.count - 2];
            MessageBoxViewController *messageBox = [[MessageBoxViewController alloc] initWithNibName:@"MessageBoxViewController"
                                                                                              bundle:nil
                                                                                               title:@"Отметка недоступна"
                                                                                             message:@"Нельзя запланировать кроводачу или анализ в прошедшем времени"
                                                                                        cancelButton:@"Продолжить"
                                                                                            okButton:nil];
            messageBox.delegate = calendarViewController;
            [calendarViewController.navigationController.tabBarController.view addSubview:messageBox.view];
            
            [self.navigationController popViewControllerAnimated:YES];
            [indicatorView removeFromSuperview];
            
            return;
        }
        else
        {*/
            if (!isTest) isFinished = YES;
        //}
    }
    if (!isTest && !event)
    {
        switch (typeDonate)
        {
            case 0:
                if ([currentCalendar dateFromComponents:dateComponents].timeIntervalSince1970 < [currentCalendar dateFromComponents:[Common getInstance].availablePlateletsDateComponents].timeIntervalSince1970)
                {
                    isCorrect = NO;
                }
                break;
                
            case 1:
                if ([currentCalendar dateFromComponents:dateComponents].timeIntervalSince1970 < [currentCalendar dateFromComponents:[Common getInstance].availablePlasmaDateComponents].timeIntervalSince1970)
                {
                    isCorrect = NO;
                }
                break;
                
            case 2:
                if ([currentCalendar dateFromComponents:dateComponents].timeIntervalSince1970 < [currentCalendar dateFromComponents:[Common getInstance].availableWholeBloodDateComponents].timeIntervalSince1970)
                {
                    isCorrect = NO;
                }
                break;
                
            default:
                break;
        }
    }
    
    if (isCorrect)
    {
        PFUser *currentUser = [PFUser currentUser];
        PFRelation *eventsRelation = [currentUser relationforKey:@"events"];
        
        if (!event)
            event = [PFObject objectWithClassName:@"Events"];
        
        if (isTest)
        {
            [event setObject:testCommentTextField.text forKey:@"comment"];
            [event setObject:[NSNumber numberWithInt:0] forKey:@"type"];
        }
        else
        {
            [event setObject:bloodDonateCommentTextField.text forKey:@"comment"];
            [event setObject:[NSNumber numberWithInt:1] forKey:@"type"];
            [event setObject:[NSNumber numberWithInt:typeDonate] forKey:@"delivery"];
        }
        
        if ([Common getInstance].eventStationAddress)
            [event setObject:[Common getInstance].eventStationAddress forKey:@"adress"];
        
        [event setObject:selectedDate forKey:@"date"];
        [event setObject:[NSNumber numberWithBool:!knowReminderButton.selected] forKey:@"analysisResult"];
        [event setObject:[NSNumber numberWithBool:isFinished] forKey:@"finished"];
        [event setObject:[NSNumber numberWithInt:eventTimeReminderIndex] forKey:@"notice"];
        [event save];
        
        [eventsRelation addObject:event];
        [currentUser save];
        
        /*NSArray *viewControllers = [self.navigationController viewControllers];
        CalendarViewController *calendarViewController = [viewControllers objectAtIndex:viewControllers.count - 2];
        MessageBoxViewController *messageBox = [[MessageBoxViewController alloc] initWithNibName:@"MessageBoxViewController"
                                                                                          bundle:nil
                                                                                           title:nil
                                                                                         message:@"Запланирован анализ"
                                                                                    cancelButton:@"Продолжить"
                                                                                        okButton:nil];
        messageBox.delegate = calendarViewController;
        [calendarViewController.view addSubview:messageBox.view];*/
    }
    else
    {
        NSArray *viewControllers = [self.navigationController viewControllers];
        CalendarViewController *calendarViewController = [viewControllers objectAtIndex:viewControllers.count - 2];
        MessageBoxViewController *messageBox = [[MessageBoxViewController alloc] initWithNibName:@"MessageBoxViewController"
                                                                                           bundle:nil
                                                                                            title:@"Отметка недоступна"
                                                                                          message:@"С момента последней кроводачи прошло недостаточно времени"
                                                                                     cancelButton:@"Продолжить"
                                                                                         okButton:nil];
        messageBox.delegate = calendarViewController;
        [calendarViewController.navigationController.tabBarController.view addSubview:messageBox.view];
    }
    
    NSDateComponents *selectedDateComponents = [currentCalendar components:unitFlags fromDate:selectedDate];
    if (!isTest && [Common getInstance].isNeedClosingEvent)
    {
        if (selectedDate.timeIntervalSince1970 > [[NSDate date] timeIntervalSince1970])
        {
            selectedDateComponents.hour = 14;
            selectedDateComponents.minute = 00;
            
            UILocalNotification *localNotification = [[[UILocalNotification alloc] init] autorelease];
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            localNotification.fireDate = selectedDate;
            //localNotification.fireDate = [currentCalendar dateFromComponents:selectedDateComponents];
            localNotification.alertAction = @"Посмотреть";
            localNotification.alertBody = @"Вы сегодня сдавали кровь?";
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    }
    else if ([Common getInstance].isNeedReminders)
    {
        UILocalNotification *localNotificationReminder = [[[UILocalNotification alloc] init] autorelease];
        localNotificationReminder.timeZone = [NSTimeZone defaultTimeZone];
        localNotificationReminder.alertAction = @"Посмотреть";
        localNotificationReminder.soundName = UILocalNotificationDefaultSoundName;
        
        if (eventTimeReminderIndex > 0)
        {
            switch (eventTimeReminderIndex)
            {
                case 1:
                    selectedDateComponents.minute -= 3;
                    localNotificationReminder.alertBody = @"Через 3 минуты\nзапланирован анализ";
                    break;
                
                case 2:
                    selectedDateComponents.minute -= 5;
                    localNotificationReminder.alertBody = @"Через 5 минут\nзапланирован анализ";
                    break;
                
                case 3:
                    selectedDateComponents.minute -= 10;
                    localNotificationReminder.alertBody = @"Через 10 минут\nзапланирован анализ";
                    break;
                
                case 4:
                    selectedDateComponents.minute -= 15;
                    localNotificationReminder.alertBody = @"Через 15 минут\nзапланирован анализ";
                    break;
                
                default:
                    break;
            }
            
            localNotificationReminder.fireDate = [currentCalendar dateFromComponents:selectedDateComponents];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotificationReminder];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [indicatorView removeFromSuperview];
}

- (IBAction)eventClick:(id)sender
{
    if (isTest)
    {
        isTest = NO;
        [testView removeFromSuperview];
        scrollView.contentSize = bloodDonationView.frame.size;
        [scrollView addSubview:bloodDonationView];
    }
    else
    {
        isTest = YES;
        [bloodDonationView removeFromSuperview];
        scrollView.contentSize = testView.frame.size;
        [scrollView addSubview:testView];
    }
}

- (IBAction)typeDonateClick:(id)sender
{
    [typeDonatePickerView selectRow:typeDonate inComponent:0 animated:NO];
    
    CGRect typeDonateInputViewRect = typeDonateInputView.frame;
    typeDonateInputViewRect.origin.y = 223.0f;
    typeDonateInputView.frame = typeDonateInputViewRect;
    [self.navigationController.tabBarController.view addSubview:typeDonateInputView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    typeDonateInputViewRect.origin.y = 0.0f;
    typeDonateInputView.frame = typeDonateInputViewRect;
    
    [UIView commitAnimations];
}

- (IBAction)dateClick:(id)sender
{
    if (isTest)
    {
        [datePickerView selectRow:testDay inComponent:0 animated:NO];
        [datePickerView selectRow:testHour inComponent:1 animated:NO];
        [datePickerView selectRow:testMinute inComponent:2 animated:NO];
    }
    else
    {
        [datePickerView selectRow:bloodDonateDay inComponent:0 animated:NO];
        [datePickerView selectRow:bloodDonateHour inComponent:1 animated:NO];
        [datePickerView selectRow:bloodDonateMinute inComponent:2 animated:NO];
    }
    
    CGRect dateInputViewRect = dateInputView.frame;
    dateInputViewRect.origin.y = 223.0f;
    dateInputView.frame = dateInputViewRect;
    [self.navigationController.tabBarController.view addSubview:dateInputView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    dateInputViewRect.origin.y = 0.0f;
    dateInputView.frame = dateInputViewRect;
    
    [UIView commitAnimations];
}

- (IBAction)locationClick:(id)sender
{
    StationsViewController *stationsViewController = [[[StationsViewController alloc] initWithNibName:@"StationsViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:stationsViewController animated:YES];
}

- (IBAction)donateReminderClick:(id)sender
{
    [Common getInstance].eventTimeReminderIndex = -1;
    EventReminderViewController *eventReminderViewController = [[[EventReminderViewController alloc] initWithNibName:@"EventReminderViewController" bundle:nil reminder:eventTimeReminderIndex] autorelease];
    [self.navigationController pushViewController:eventReminderViewController animated:YES];
}

- (IBAction)knowReminderClick:(id)sender
{
    if (knowReminderButton.selected)
        knowReminderButton.selected = NO;
    else
        knowReminderButton.selected = YES;
}

- (IBAction)removeClick:(id)sender
{
    [self.navigationController.tabBarController.view addSubview:indicatorView];
    
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Events"];
    [eventQuery getObjectInBackgroundWithId:eventId target:self selector:@selector(removeResult:error:)];
}

- (void)removeResult:(PFObject *)event error:(NSError *)error
{
    [event delete];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [indicatorView removeFromSuperview];
}

- (IBAction)typeDonateCancelClick:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(typeDonateInputViewHide)];
    
    CGRect typeDonateInputViewRect = typeDonateInputView.frame;
    typeDonateInputViewRect.origin.y = 223.0f;
    typeDonateInputView.frame = typeDonateInputViewRect;
    
    [UIView commitAnimations];
}

- (IBAction)typeDonateDoneClick:(id)sender
{
    typeDonate = [typeDonatePickerView selectedRowInComponent:0];
    [typeDonateButton setTitle:[typeDonateArray objectAtIndex:typeDonate] forState:UIControlStateNormal];
    [typeDonateButton setTitle:[typeDonateArray objectAtIndex:typeDonate] forState:UIControlStateHighlighted];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(typeDonateInputViewHide)];
    
    CGRect typeDonateInputViewRect = typeDonateInputView.frame;
    typeDonateInputViewRect.origin.y = 223.0f;
    typeDonateInputView.frame = typeDonateInputViewRect;
    
    [UIView commitAnimations];
}

- (IBAction)dateCancelClick:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dateInputViewHide)];
    
    CGRect dateInputViewRect = dateInputView.frame;
    dateInputViewRect.origin.y = 223.0f;
    dateInputView.frame = dateInputViewRect;
    
    [UIView commitAnimations];
}

- (IBAction)dateDoneClick:(id)sender
{
    if (isTest)
    {
        testDay = [datePickerView selectedRowInComponent:0];
        testHour = [datePickerView selectedRowInComponent:1];
        testMinute = [datePickerView selectedRowInComponent:2];
        
        
        [testDateButton setTitle:[NSString stringWithFormat:@"%@", [daysArray objectAtIndex:testDay]] forState:UIControlStateNormal];
        [testDateButton setTitle:[NSString stringWithFormat:@"%@", [daysArray objectAtIndex:testDay]] forState:UIControlStateHighlighted];
        
        /*[testDateButton setTitle:[NSString stringWithFormat:@"%@ %@:%@",
                                  [daysArray objectAtIndex:testDay],
                                  [hoursArray objectAtIndex:testHour],
                                  [minutesArray objectAtIndex:testMinute]]
                        forState:UIControlStateNormal];
        [testDateButton setTitle:[NSString stringWithFormat:@"%@ %@:%@",
                                  [daysArray objectAtIndex:testDay],
                                  [hoursArray objectAtIndex:testHour],
                                  [minutesArray objectAtIndex:testMinute]]
                        forState:UIControlStateHighlighted];*/
    }
    else
    {
        bloodDonateDay = [datePickerView selectedRowInComponent:0];
        bloodDonateHour = [datePickerView selectedRowInComponent:1];
        bloodDonateMinute = [datePickerView selectedRowInComponent:2];
        
        [bloodDonationDateButton setTitle:[NSString stringWithFormat:@"%@", [daysArray objectAtIndex:bloodDonateDay]] forState:UIControlStateNormal];
        [bloodDonationDateButton setTitle:[NSString stringWithFormat:@"%@", [daysArray objectAtIndex:bloodDonateDay]] forState:UIControlStateHighlighted];
        
        /*[bloodDonationDateButton setTitle:[NSString stringWithFormat:@"%@ %@:%@",
                                           [daysArray objectAtIndex:bloodDonateDay],
                                           [hoursArray objectAtIndex:bloodDonateHour],
                                           [minutesArray objectAtIndex:bloodDonateMinute]]
                                 forState:UIControlStateNormal];
        [bloodDonationDateButton setTitle:[NSString stringWithFormat:@"%@ %@:%@",
                                           [daysArray objectAtIndex:bloodDonateDay],
                                           [hoursArray objectAtIndex:bloodDonateHour],
                                           [minutesArray objectAtIndex:bloodDonateMinute]]
                                 forState:UIControlStateHighlighted];*/
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dateInputViewHide)];
    
    CGRect dateInputViewRect = dateInputView.frame;
    dateInputViewRect.origin.y = 223.0f;
    dateInputView.frame = dateInputViewRect;
    
    [UIView commitAnimations];
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    scrollView.scrollEnabled = NO;
    float animationDuration = 0.3f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect scrollViewRect = scrollView.frame;
    scrollViewRect.size.height -= 216;
    scrollView.frame = scrollViewRect;
    
    CGPoint bottomOffset = CGPointMake(0, scrollView.contentOffset.y + scrollView.frame.size.height);
    [scrollView setContentOffset:bottomOffset];
    
    [UIView commitAnimations];
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"])
    {
        scrollView.scrollEnabled = YES;
        float animationDuration = 0.3f;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        CGRect scrollViewRect = scrollView.frame;
        scrollViewRect.size.height += 216;
        scrollView.frame = scrollViewRect;
        
        [UIView commitAnimations];
        
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

/*#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    scrollView.scrollEnabled = NO;
    float animationDuration = 0.3f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect scrollViewRect = scrollView.frame;
    scrollViewRect.size.height -= 216;
    scrollView.frame = scrollViewRect;
    
    CGPoint bottomOffset = CGPointMake(0, scrollView.contentOffset.y + scrollView.frame.size.height);
    [scrollView setContentOffset:bottomOffset];
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    scrollView.scrollEnabled = YES;
    float animationDuration = 0.3f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect scrollViewRect = scrollView.frame;
    scrollViewRect.size.height += 216;
    scrollView.frame = scrollViewRect;
    
    [UIView commitAnimations];
    
    return [textField resignFirstResponder];
}*/

#pragma mark Animation Stopped
- (void)typeDonateInputViewHide
{
    [typeDonateInputView removeFromSuperview];
}

- (void)dateInputViewHide
{
    [dateInputView removeFromSuperview];
}

#pragma mark UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([pickerView isEqual:datePickerView])
        return 3;
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:typeDonatePickerView])
        return typeDonateArray.count;
    else if ([pickerView isEqual:datePickerView])
    {
        switch (component)
        {
            case 0:
                return daysArray.count;
                
            case 1:
                return hoursArray.count;
                
            case 2:
                return minutesArray.count;
                
            default:
                break;
        }
    }
    
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if ([pickerView isEqual:datePickerView])
    {
        switch (component)
        {
            case 0:
                return 100;
            
            default:
                return 82;
        }
    }
    
    return 320;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([pickerView isEqual:typeDonatePickerView])
        return [typeDonateArray objectAtIndex:row];
    else if ([pickerView isEqual:datePickerView])
    {
        switch (component)
        {
            case 0:
                return [daysArray objectAtIndex:row];
                
            case 1:
                return [hoursArray objectAtIndex:row];
                
            case 2:
                return [minutesArray objectAtIndex:row];
                
            default:
                break;
        }
    }
    
    return @"";
}

#pragma mark Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Планирование";
    
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];
    
    UIImage *barImageNormal = [UIImage imageNamed:@"barButtonNormal"];
    UIImage *barImagePressed = [UIImage imageNamed:@"barButtonPressed"];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect cancelButtonFrame = CGRectMake(0, 0, barImageNormal.size.width, barImageNormal.size.height);
    [cancelButton setBackgroundImage:barImageNormal forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:barImagePressed forState:UIControlStateHighlighted];
    [cancelButton setTitle:@"Отмена" forState:UIControlStateNormal];
    [cancelButton setTitle:@"Отмена" forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    cancelButton.frame = cancelButtonFrame;
    [cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:cancelButton] autorelease];
    [cancelBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect doneButtonFrame = CGRectMake(0, 0, barImageNormal.size.width, barImageNormal.size.height);
    [doneButton setBackgroundImage:barImageNormal forState:UIControlStateNormal];
    [doneButton setBackgroundImage:barImagePressed forState:UIControlStateHighlighted];
    [doneButton setTitle:@"Готово" forState:UIControlStateNormal];
    [doneButton setTitle:@"Готово" forState:UIControlStateHighlighted];
    doneButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    doneButton.frame = doneButtonFrame;
    [doneButton addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *doneBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:doneButton] autorelease];
    [doneBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;
    
    if (![eventId isEqualToString:@""])
    {
        [self.navigationController.tabBarController.view addSubview:indicatorView];
        PFQuery *eventQuery = [PFQuery queryWithClassName:@"Events"];
        [eventQuery getObjectInBackgroundWithId:eventId target:self selector:@selector(eventResult:error:)];
    }
    else
    {
        bloodDonateRemoveButton.hidden = YES;
        testRemoveButton.hidden = YES;
        
        CGRect testViewRect = testView.frame;
        testViewRect.size.height -= 50;
        testView.frame = testViewRect;
        
        CGRect bloodDonationViewRect = bloodDonationView.frame;
        bloodDonationViewRect.size.height -= 50;
        bloodDonationView.frame = bloodDonationViewRect;
        
        scrollView.contentSize = bloodDonationView.frame.size;
        [scrollView addSubview:bloodDonationView];
    }
    
    [typeDonateButton setTitle:[typeDonateArray objectAtIndex:typeDonate] forState:UIControlStateNormal];
    [typeDonateButton setTitle:[typeDonateArray objectAtIndex:typeDonate] forState:UIControlStateHighlighted];
    
    [bloodDonationDateButton setTitle:[NSString stringWithFormat:@"%@", [daysArray objectAtIndex:bloodDonateDay]] forState:UIControlStateNormal];
    [bloodDonationDateButton setTitle:[NSString stringWithFormat:@"%@", [daysArray objectAtIndex:bloodDonateDay]] forState:UIControlStateHighlighted];
    
    [testDateButton setTitle:[NSString stringWithFormat:@"%@", [daysArray objectAtIndex:testDay]] forState:UIControlStateNormal];
    [testDateButton setTitle:[NSString stringWithFormat:@"%@", [daysArray objectAtIndex:testDay]] forState:UIControlStateHighlighted];
    
    /*[bloodDonationDateButton setTitle:[NSString stringWithFormat:@"%@ %@:%@",
                                       [daysArray objectAtIndex:bloodDonateDay],
                                       [hoursArray objectAtIndex:bloodDonateHour],
                                       [minutesArray objectAtIndex:bloodDonateMinute]]
                             forState:UIControlStateNormal];
    [bloodDonationDateButton setTitle:[NSString stringWithFormat:@"%@ %@:%@",
                                       [daysArray objectAtIndex:bloodDonateDay],
                                       [hoursArray objectAtIndex:bloodDonateHour],
                                       [minutesArray objectAtIndex:bloodDonateMinute]]
                             forState:UIControlStateHighlighted];
    
    [testDateButton setTitle:[NSString stringWithFormat:@"%@ %@:%@",
                                       [daysArray objectAtIndex:testDay],
                                       [hoursArray objectAtIndex:testHour],
                                       [minutesArray objectAtIndex:testMinute]]
                             forState:UIControlStateNormal];
    [testDateButton setTitle:[NSString stringWithFormat:@"%@ %@:%@",
                                       [daysArray objectAtIndex:testDay],
                                       [hoursArray objectAtIndex:testHour],
                                       [minutesArray objectAtIndex:testMinute]]
                             forState:UIControlStateHighlighted];*/
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([Common getInstance].eventTimeReminderIndex != -1)
        eventTimeReminderIndex = [Common getInstance].eventTimeReminderIndex;
    
    switch (eventTimeReminderIndex)
    {
        case 0:
            [timeReminderButton setTitle:@"Нет" forState:UIControlStateNormal];
            [timeReminderButton setTitle:@"Нет" forState:UIControlStateHighlighted];
            break;
        
        case 1:
            [timeReminderButton setTitle:@"За 3 мин" forState:UIControlStateNormal];
            [timeReminderButton setTitle:@"За 3 мин" forState:UIControlStateHighlighted];
            break;
        
        case 2:
            [timeReminderButton setTitle:@"За 5 мин" forState:UIControlStateNormal];
            [timeReminderButton setTitle:@"За 5 мин" forState:UIControlStateHighlighted];
            break;
        
        case 3:
            [timeReminderButton setTitle:@"За 10 мин" forState:UIControlStateNormal];
            [timeReminderButton setTitle:@"За 10 мин" forState:UIControlStateHighlighted];
            break;
        
        case 4:
            [timeReminderButton setTitle:@"За 15 мин" forState:UIControlStateNormal];
            [timeReminderButton setTitle:@"За 15 мин" forState:UIControlStateHighlighted];
            break;
        
        default:
            break;
    }
    
    [testLocationButton setTitle:[Common getInstance].eventStationAddress forState:UIControlStateNormal];
    [testLocationButton setTitle:[Common getInstance].eventStationAddress forState:UIControlStateHighlighted];
    [bloodDonateLocationButton setTitle:[Common getInstance].eventStationAddress forState:UIControlStateNormal];
    [bloodDonateLocationButton setTitle:[Common getInstance].eventStationAddress forState:UIControlStateHighlighted];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [Common getInstance].eventStationAddress = @"";
    
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [indicatorView release];
    [typeDonateArray release];
    [daysArray release];
    [hoursArray release];
    [minutesArray release];
    [eventId release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)eventResult:(PFObject *)event error:(NSError *)error
{
    if ([[event valueForKey:@"type"] intValue] == 0)
    {
        scrollView.contentSize = testView.frame.size;
        [scrollView addSubview:testView];
        
        isTest = YES;
    }
    else if ([[event valueForKey:@"type"] intValue] == 1)
    {
        scrollView.contentSize = bloodDonationView.frame.size;
        [scrollView addSubview:bloodDonationView];
        
        typeDonate = [[event valueForKey:@"delivery"] intValue];
        
        [typeDonateButton setTitle:[typeDonateArray objectAtIndex:typeDonate] forState:UIControlStateNormal];
        [typeDonateButton setTitle:[typeDonateArray objectAtIndex:typeDonate] forState:UIControlStateHighlighted];
        
        isTest = NO;
    }
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDate *eventDate = [event valueForKey:@"date"];
    
    bloodDonateDay = [currentCalendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:eventDate] - 1;
    testDay = bloodDonateDay;
    bloodDonateHour = [currentCalendar ordinalityOfUnit:NSHourCalendarUnit inUnit:NSDayCalendarUnit forDate:eventDate] - 1;
    testHour = bloodDonateHour;
    bloodDonateMinute = [currentCalendar ordinalityOfUnit:NSMinuteCalendarUnit inUnit:NSHourCalendarUnit forDate:eventDate] / 5;
    testMinute = bloodDonateMinute;
    
    testCommentTextField.text = [event valueForKey:@"comment"];
    bloodDonateCommentTextField.text = [event valueForKey:@"comment"];
    
    [Common getInstance].eventStationAddress = [event valueForKey:@"adress"];
    
    [testLocationButton setTitle:[Common getInstance].eventStationAddress forState:UIControlStateNormal];
    [testLocationButton setTitle:[Common getInstance].eventStationAddress forState:UIControlStateHighlighted];
    
    [bloodDonateLocationButton setTitle:[Common getInstance].eventStationAddress forState:UIControlStateNormal];
    [bloodDonateLocationButton setTitle:[Common getInstance].eventStationAddress forState:UIControlStateHighlighted];
    
    eventTimeReminderIndex = [[event valueForKey:@"notice"] intValue];
    
    knowReminderButton.selected = ![[event valueForKey:@"analysisResult"] boolValue];
    
    [indicatorView removeFromSuperview];
}

@end
