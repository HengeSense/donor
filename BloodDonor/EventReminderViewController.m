//
//  EventReminderViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 02.08.12.
//
//

#import "EventReminderViewController.h"
#import "Common.h"

@interface EventReminderViewController ()

@end

@implementation EventReminderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil reminder:(int)indexReminder
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        selectedReminder = indexReminder;
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
    [Common getInstance].eventTimeReminderIndex = selectedReminder;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(22, 0, 276, 28)] autorelease];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    label.textColor = [UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
    label.backgroundColor = [UIColor clearColor];
    
    UIImageView *circle = [[[UIImageView alloc] initWithFrame:CGRectMake(293, 11, 8, 8)] autorelease];
    circle.image = [UIImage imageNamed:@"eventReminderCircle"];
    
    if (indexPath.row != selectedReminder)
    {
        label.textColor = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
        circle.hidden = YES;
    }
    
    switch (indexPath.row)
    {
        case 0:
            label.text = @"Нет";
            break;
        
        case 1:
            label.text = @"За 3 мин";
            break;
        
        case 2:
            label.text = @"За 5 мин";
            break;
        
        case 3:
            label.text = @"За 10 мин";
            break;
        
        case 4:
            label.text = @"За 15 мин";
            break;
        
        default:
            break;
    }
    
    UIImageView *dottedLine = [[[UIImageView alloc] initWithFrame:CGRectMake(9, 28, 301, 3)] autorelease];
    dottedLine.image = [UIImage imageNamed:@"dottedLine"];
    
    [tableViewCell addSubview:label];
    [tableViewCell addSubview:circle];
    [tableViewCell addSubview:dottedLine];
    
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedReminder = indexPath.row;
    [tableView reloadData];
}

#pragma mark Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Напоминание";
    
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
