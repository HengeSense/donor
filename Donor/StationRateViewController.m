//
//  StationRateViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 08.08.12.
//
//

#import "StationRateViewController.h"
#import "HSAlertViewController.h"

#import "MBProgressHUD.h"

@implementation StationRateViewController

#pragma mark Actions

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonPressed:(id)sender
{
    [commentTextField resignFirstResponder];
    PFObject *review = [PFObject objectWithClassName:@"StationReviews"];
    if (![nameField.text isEqualToString:@""])
        [review setObject:nameField.text forKey:@"username"];
    if (![commentTextField.text isEqualToString:@""])
        [review setObject:commentTextField.text forKey:@"body"];
    if ([PFUser currentUser])
       [review setObject:[PFUser currentUser].objectId forKey:@"user_id"];
    
    [review setObject:[station valueForKey:@"objectId"] forKey:@"station_id"];
    [review setObject:[NSNumber numberWithInt:workOfRegistryVote] forKey:@"vote_registry"];
    [review setObject:[NSNumber numberWithInt:workOfTherapistVote] forKey:@"vote_physician"];
    [review setObject:[NSNumber numberWithInt:workOfBuffetVote] forKey:@"vote_buffet"];
    [review setObject:[NSNumber numberWithInt:workOfLabVote] forKey:@"vote_laboratory"];
    [review setObject:[NSNumber numberWithInt:scheduleVote] forKey:@"vote_schedule"];
    [review setObject:[NSNumber numberWithInt:bloodDonateOrganizationVote] forKey:@"vote_organization_donation"];
    [review setObject:[NSNumber numberWithInt:pointOfDonationSpaceVote] forKey:@"vote_room"];
    
    
    float rateFloat =  ((float)workOfRegistryVote + (float)workOfTherapistVote + (float)workOfBuffetVote + (float)workOfLabVote + (float)scheduleVote + (float)bloodDonateOrganizationVote + (float)pointOfDonationSpaceVote)/7.0f;
    int rateInt;
    
    if (rateFloat == 0)
        rateInt = 0;
    else if (rateFloat <= 1.0f)
        rateInt = 1;
    else if ((rateFloat >= 1.0f) && (rateFloat <= 2.0f))
        rateInt = 2;
    else if ((rateFloat >= 2.0f) && (rateFloat <= 3.0f))
        rateInt = 3;
    else if ((rateFloat >= 3.0f) && (rateFloat <= 4.0f))
        rateInt = 4;
    else if (rateFloat > 4.0f)
        rateInt = 5;
    
    [review setObject:[NSNumber numberWithInt:rateInt] forKey:@"vote"];
    
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [review saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [progressHud hide:YES];
        if (succeeded) {
            [HSAlertViewController showWithMessage:@"Спасибо за отзыв!" resultBlock:^(BOOL isOkButtonPressed) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [HSAlertViewController showWithTitle:@"Ошибка" message:@"Не удалось сохранить отзыв!"
                                     resultBlock:^(BOOL isOkButtonPressed) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}

- (IBAction)workOfRegistryRatePressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    workOfRegistryVote = button.tag;
   
    switch (button.tag)
    {
        case 1:
            if (button.selected)
                workOfRegistryVote = 0;
            workOfRegistryRateButton1.selected = !workOfRegistryRateButton1.selected;
            workOfRegistryRateButton2.selected = NO;
            workOfRegistryRateButton3.selected = NO;
            workOfRegistryRateButton4.selected = NO;
            workOfRegistryRateButton5.selected = NO;
            break;
        case 2:
            workOfRegistryRateButton1.selected = YES;
            workOfRegistryRateButton2.selected = YES;
            workOfRegistryRateButton3.selected = NO;
            workOfRegistryRateButton4.selected = NO;
            workOfRegistryRateButton5.selected = NO;
            break;
        case 3:
            workOfRegistryRateButton1.selected = YES;
            workOfRegistryRateButton2.selected = YES;
            workOfRegistryRateButton3.selected = YES;
            workOfRegistryRateButton4.selected = NO;
            workOfRegistryRateButton5.selected = NO;
            break;
        case 4:
            workOfRegistryRateButton1.selected = YES;
            workOfRegistryRateButton2.selected = YES;
            workOfRegistryRateButton3.selected = YES;
            workOfRegistryRateButton4.selected = YES;
            workOfRegistryRateButton5.selected = NO;
            break;
        case 5:
            workOfRegistryRateButton1.selected = YES;
            workOfRegistryRateButton2.selected = YES;
            workOfRegistryRateButton3.selected = YES;
            workOfRegistryRateButton4.selected = YES;
            workOfRegistryRateButton5.selected = YES;
            break;
        default:
            break;
    }
}

- (IBAction)workOfTherapistRatePressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    workOfTherapistVote = button.tag;
    
    switch (button.tag)
    {
        case 1:
            if (button.selected)
                workOfTherapistVote = 0;
            workOfTherapistRateButton1.selected = !workOfTherapistRateButton1.selected;
            workOfTherapistRateButton2.selected = NO;
            workOfTherapistRateButton3.selected = NO;
            workOfTherapistRateButton4.selected = NO;
            workOfTherapistRateButton5.selected = NO;
            break;
        case 2:
            workOfTherapistRateButton1.selected = YES;
            workOfTherapistRateButton2.selected = YES;
            workOfTherapistRateButton3.selected = NO;
            workOfTherapistRateButton4.selected = NO;
            workOfTherapistRateButton5.selected = NO;
            break;
        case 3:
            workOfTherapistRateButton1.selected = YES;
            workOfTherapistRateButton2.selected = YES;
            workOfTherapistRateButton3.selected = YES;
            workOfTherapistRateButton4.selected = NO;
            workOfTherapistRateButton5.selected = NO;
            break;
        case 4:
            workOfTherapistRateButton1.selected = YES;
            workOfTherapistRateButton2.selected = YES;
            workOfTherapistRateButton3.selected = YES;
            workOfTherapistRateButton4.selected = YES;
            workOfTherapistRateButton5.selected = NO;
            break;
        case 5:
            workOfTherapistRateButton1.selected = YES;
            workOfTherapistRateButton2.selected = YES;
            workOfTherapistRateButton3.selected = YES;
            workOfTherapistRateButton4.selected = YES;
            workOfTherapistRateButton5.selected = YES;
            break;
        default:
            break;
    }
}

- (IBAction)workOfLabRatePressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    workOfLabVote = button.tag;
    
    switch (button.tag)
    {
        case 1:
            if (button.selected)
                workOfLabVote = 0;
            workOfLabRateButton1.selected = !workOfLabRateButton1.selected;
            workOfLabRateButton2.selected = NO;
            workOfLabRateButton3.selected = NO;
            workOfLabRateButton4.selected = NO;
            workOfLabRateButton5.selected = NO;
            break;
        case 2:
            workOfLabRateButton1.selected = YES;
            workOfLabRateButton2.selected = YES;
            workOfLabRateButton3.selected = NO;
            workOfLabRateButton4.selected = NO;
            workOfLabRateButton5.selected = NO;
            break;
        case 3:
            workOfLabRateButton1.selected = YES;
            workOfLabRateButton2.selected = YES;
            workOfLabRateButton3.selected = YES;
            workOfLabRateButton4.selected = NO;
            workOfLabRateButton5.selected = NO;
            break;
        case 4:
            workOfLabRateButton1.selected = YES;
            workOfLabRateButton2.selected = YES;
            workOfLabRateButton3.selected = YES;
            workOfLabRateButton4.selected = YES;
            workOfLabRateButton5.selected = NO;
            break;
        case 5:
            workOfLabRateButton1.selected = YES;
            workOfLabRateButton2.selected = YES;
            workOfLabRateButton3.selected = YES;
            workOfLabRateButton4.selected = YES;
            workOfLabRateButton5.selected = YES;
            break;
        default:
            break;
    }
}

- (IBAction)workOfBuffetRatePressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    workOfBuffetVote = button.tag;
    
    switch (button.tag)
    {
        case 1:
            if (button.selected)
                workOfBuffetVote = 0;
            workOfBuffetRateButton1.selected = !workOfBuffetRateButton1.selected;
            workOfBuffetRateButton2.selected = NO;
            workOfBuffetRateButton3.selected = NO;
            workOfBuffetRateButton4.selected = NO;
            workOfBuffetRateButton5.selected = NO;
            break;
        case 2:
            workOfBuffetRateButton1.selected = YES;
            workOfBuffetRateButton2.selected = YES;
            workOfBuffetRateButton3.selected = NO;
            workOfBuffetRateButton4.selected = NO;
            workOfBuffetRateButton5.selected = NO;
            break;
        case 3:
            workOfBuffetRateButton1.selected = YES;
            workOfBuffetRateButton2.selected = YES;
            workOfBuffetRateButton3.selected = YES;
            workOfBuffetRateButton4.selected = NO;
            workOfBuffetRateButton5.selected = NO;
            break;
        case 4:
            workOfBuffetRateButton1.selected = YES;
            workOfBuffetRateButton2.selected = YES;
            workOfBuffetRateButton3.selected = YES;
            workOfBuffetRateButton4.selected = YES;
            workOfBuffetRateButton5.selected = NO;
            break;
        case 5:
            workOfBuffetRateButton1.selected = YES;
            workOfBuffetRateButton2.selected = YES;
            workOfBuffetRateButton3.selected = YES;
            workOfBuffetRateButton4.selected = YES;
            workOfBuffetRateButton5.selected = YES;
            break;
        default:
            break;
    }
}

- (IBAction)scheduleRatePressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    scheduleVote = button.tag;
    
    switch (button.tag)
    {
        case 1:
            if (button.selected)
                scheduleVote = 0;
            scheduleRateButton1.selected = !scheduleRateButton1.selected;
            scheduleRateButton2.selected = NO;
            scheduleRateButton3.selected = NO;
            scheduleRateButton4.selected = NO;
            scheduleRateButton5.selected = NO;
            break;
        case 2:
            scheduleRateButton1.selected = YES;
            scheduleRateButton2.selected = YES;
            scheduleRateButton3.selected = NO;
            scheduleRateButton4.selected = NO;
            scheduleRateButton5.selected = NO;
            break;
        case 3:
            scheduleRateButton1.selected = YES;
            scheduleRateButton2.selected = YES;
            scheduleRateButton3.selected = YES;
            scheduleRateButton4.selected = NO;
            scheduleRateButton5.selected = NO;
            break;
        case 4:
            scheduleRateButton1.selected = YES;
            scheduleRateButton2.selected = YES;
            scheduleRateButton3.selected = YES;
            scheduleRateButton4.selected = YES;
            scheduleRateButton5.selected = NO;
            break;
        case 5:
            scheduleRateButton1.selected = YES;
            scheduleRateButton2.selected = YES;
            scheduleRateButton3.selected = YES;
            scheduleRateButton4.selected = YES;
            scheduleRateButton5.selected = YES;
            break;
        default:
            break;
    }
}

- (IBAction)bloodDonateOrganizationRatePressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    workOfBuffetVote = button.tag;
    
    switch (button.tag)
    {
        case 1:
            if (button.selected)
                workOfBuffetVote = 0;
            bloodDonateOrganizationRateButton1.selected = !bloodDonateOrganizationRateButton1.selected;
            bloodDonateOrganizationRateButton2.selected = NO;
            bloodDonateOrganizationRateButton3.selected = NO;
            bloodDonateOrganizationRateButton4.selected = NO;
            bloodDonateOrganizationRateButton5.selected = NO;
            break;
        case 2:
            bloodDonateOrganizationRateButton1.selected = YES;
            bloodDonateOrganizationRateButton2.selected = YES;
            bloodDonateOrganizationRateButton3.selected = NO;
            bloodDonateOrganizationRateButton4.selected = NO;
            bloodDonateOrganizationRateButton5.selected = NO;
            break;
        case 3:
            bloodDonateOrganizationRateButton1.selected = YES;
            bloodDonateOrganizationRateButton2.selected = YES;
            bloodDonateOrganizationRateButton3.selected = YES;
            bloodDonateOrganizationRateButton4.selected = NO;
            bloodDonateOrganizationRateButton5.selected = NO;
            break;
        case 4:
            bloodDonateOrganizationRateButton1.selected = YES;
            bloodDonateOrganizationRateButton2.selected = YES;
            bloodDonateOrganizationRateButton3.selected = YES;
            bloodDonateOrganizationRateButton4.selected = YES;
            bloodDonateOrganizationRateButton5.selected = NO;
            break;
        case 5:
            bloodDonateOrganizationRateButton1.selected = YES;
            bloodDonateOrganizationRateButton2.selected = YES;
            bloodDonateOrganizationRateButton3.selected = YES;
            bloodDonateOrganizationRateButton4.selected = YES;
            bloodDonateOrganizationRateButton5.selected = YES;
            break;
        default:
            break;
    }
}

- (IBAction)pointOfDonationSpaceRatePressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    pointOfDonationSpaceVote = button.tag;
    
    switch (button.tag)
    {
        case 1:
            if (button.selected)
                pointOfDonationSpaceVote = 0;
            pointOfDonationSpaceRateButton1.selected = !pointOfDonationSpaceRateButton1.selected;
            pointOfDonationSpaceRateButton2.selected = NO;
            pointOfDonationSpaceRateButton3.selected = NO;
            pointOfDonationSpaceRateButton4.selected = NO;
            pointOfDonationSpaceRateButton5.selected = NO;
            break;
        case 2:
            pointOfDonationSpaceRateButton1.selected = YES;
            pointOfDonationSpaceRateButton2.selected = YES;
            pointOfDonationSpaceRateButton3.selected = NO;
            pointOfDonationSpaceRateButton4.selected = NO;
            pointOfDonationSpaceRateButton5.selected = NO;
            break;
        case 3:
            pointOfDonationSpaceRateButton1.selected = YES;
            pointOfDonationSpaceRateButton2.selected = YES;
            pointOfDonationSpaceRateButton3.selected = YES;
            pointOfDonationSpaceRateButton4.selected = NO;
            pointOfDonationSpaceRateButton5.selected = NO;
            break;
        case 4:
            pointOfDonationSpaceRateButton1.selected = YES;
            pointOfDonationSpaceRateButton2.selected = YES;
            pointOfDonationSpaceRateButton3.selected = YES;
            pointOfDonationSpaceRateButton4.selected = YES;
            pointOfDonationSpaceRateButton5.selected = NO;
            break;
        case 5:
            pointOfDonationSpaceRateButton1.selected = YES;
            pointOfDonationSpaceRateButton2.selected = YES;
            pointOfDonationSpaceRateButton3.selected = YES;
            pointOfDonationSpaceRateButton4.selected = YES;
            pointOfDonationSpaceRateButton5.selected = YES;
            break;
        default:
            break;
    }
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
    scrollViewRect.origin.y -= 138;
    scrollView.frame = scrollViewRect;
    
    //CGPoint bottomOffset = CGPointMake(0, scrollView.contentOffset.y + scrollView.frame.size.height);
    //[scrollView setContentOffset:bottomOffset];
    
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
        scrollViewRect.origin.y += 138;
        scrollView.frame = scrollViewRect;
        
        [UIView commitAnimations];
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark TextEditDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 2)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        
        scrollView.center = CGPointMake(scrollView.center.x, scrollView.center.y + 120);
        [UIView commitAnimations];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 2)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        
        scrollView.center = CGPointMake(scrollView.center.x, scrollView.center.y - 120);
        [UIView commitAnimations];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)object rate:(float)rate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        station = object;
        fullRate = rate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Станции";
    
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
    [cancelButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:cancelButton] autorelease];
    [cancelBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect doneButtonFrame = CGRectMake(0, 0, barImageNormal.size.width, barImageNormal.size.height);
    [doneButton setBackgroundImage:barImageNormal forState:UIControlStateNormal];
    [doneButton setBackgroundImage:barImagePressed forState:UIControlStateHighlighted];
    [doneButton setTitle:@"Отправить" forState:UIControlStateNormal];
    [doneButton setTitle:@"Отправить" forState:UIControlStateHighlighted];
    doneButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    doneButton.frame = doneButtonFrame;
    [doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *doneBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:doneButton] autorelease];
    [doneBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;
        
    workOfRegistryVote = 1;
    workOfLabVote = 1;
    workOfBuffetVote = 1;
    workOfTherapistVote = 1;
    scheduleVote = 1;
    bloodDonateOrganizationVote = 1;
    pointOfDonationSpaceVote = 1;
    
    if(fullRate <= 1.0f)
        [ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    else if ((1.0f < fullRate) && (fullRate <= 2.0f))
    {
        [ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    else if ((2.0f < fullRate) && (fullRate <= 3.0f))
    {
        [ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    else if ((3.0f < fullRate) && (fullRate <= 4.0f))
    {
        [ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar4 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    else if (4.0f < fullRate)
    {
        [ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar4 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [ratedStar5 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    
    stationTitleLable.text = [station objectForKey:@"title"];
    
    scrollView.contentSize = backgroundImage.frame.size;
    
    [nameField setValue:[UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    PFUser *user = [PFUser currentUser];
    if (user)
        nameField.text = [user valueForKey:@"Name"];
    else
        nameField.text = @"";
    commentTextField.text = @"";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
