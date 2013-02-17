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
    [self.commentTextField resignFirstResponder];
    PFObject *review = [PFObject objectWithClassName:@"StationReviews"];
    if (![self.nameField.text isEqualToString:@""])
        [review setObject:self.nameField.text forKey:@"username"];
    if (![self.commentTextField.text isEqualToString:@""])
        [review setObject:self.commentTextField.text forKey:@"body"];
    if ([PFUser currentUser])
       [review setObject:[PFUser currentUser].objectId forKey:@"user_id"];
    
    [review setObject:[self.station valueForKey:@"objectId"] forKey:@"station_id"];
    [review setObject:[NSNumber numberWithInt:self.workOfRegistryVote] forKey:@"vote_registry"];
    [review setObject:[NSNumber numberWithInt:self.workOfTherapistVote] forKey:@"vote_physician"];
    [review setObject:[NSNumber numberWithInt:self.workOfBuffetVote] forKey:@"vote_buffet"];
    [review setObject:[NSNumber numberWithInt:self.workOfLabVote] forKey:@"vote_laboratory"];
    [review setObject:[NSNumber numberWithInt:self.scheduleVote] forKey:@"vote_schedule"];
    [review setObject:[NSNumber numberWithInt:self.bloodDonateOrganizationVote] forKey:@"vote_organization_donation"];
    [review setObject:[NSNumber numberWithInt:self.pointOfDonationSpaceVote] forKey:@"vote_room"];
    
    
    float rateFloat =  (self.workOfRegistryVote + self.workOfTherapistVote + self.workOfBuffetVote + self.workOfLabVote
            + self.scheduleVote + self.bloodDonateOrganizationVote + self.pointOfDonationSpaceVote) / 7.0f;
    int rateInt = 0;
    
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
    self.workOfRegistryVote = button.tag;
   
    switch (button.tag)
    {
        case 1:
            if (button.selected)
                self.workOfRegistryVote = 0;
            self.workOfRegistryRateButton1.selected = !self.workOfRegistryRateButton1.selected;
            self.workOfRegistryRateButton2.selected = NO;
            self.workOfRegistryRateButton3.selected = NO;
            self.workOfRegistryRateButton4.selected = NO;
            self.workOfRegistryRateButton5.selected = NO;
            break;
        case 2:
            self.workOfRegistryRateButton1.selected = YES;
            self.workOfRegistryRateButton2.selected = YES;
            self.workOfRegistryRateButton3.selected = NO;
            self.workOfRegistryRateButton4.selected = NO;
            self.workOfRegistryRateButton5.selected = NO;
            break;
        case 3:
            self.workOfRegistryRateButton1.selected = YES;
            self.workOfRegistryRateButton2.selected = YES;
            self.workOfRegistryRateButton3.selected = YES;
            self.workOfRegistryRateButton4.selected = NO;
            self.workOfRegistryRateButton5.selected = NO;
            break;
        case 4:
            self.workOfRegistryRateButton1.selected = YES;
            self.workOfRegistryRateButton2.selected = YES;
            self.workOfRegistryRateButton3.selected = YES;
            self.workOfRegistryRateButton4.selected = YES;
            self.workOfRegistryRateButton5.selected = NO;
            break;
        case 5:
            self.workOfRegistryRateButton1.selected = YES;
            self.workOfRegistryRateButton2.selected = YES;
            self.workOfRegistryRateButton3.selected = YES;
            self.workOfRegistryRateButton4.selected = YES;
            self.workOfRegistryRateButton5.selected = YES;
            break;
        default:
            break;
    }
}

- (IBAction)workOfTherapistRatePressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    self.workOfTherapistVote = button.tag;
    
    switch (button.tag)
    {
        case 1:
            if (button.selected)
                self.workOfTherapistVote = 0;
            self.workOfTherapistRateButton1.selected = !self.workOfTherapistRateButton1.selected;
            self.workOfTherapistRateButton2.selected = NO;
            self.workOfTherapistRateButton3.selected = NO;
            self.workOfTherapistRateButton4.selected = NO;
            self.workOfTherapistRateButton5.selected = NO;
            break;
        case 2:
            self.workOfTherapistRateButton1.selected = YES;
            self.workOfTherapistRateButton2.selected = YES;
            self.workOfTherapistRateButton3.selected = NO;
            self.workOfTherapistRateButton4.selected = NO;
            self.workOfTherapistRateButton5.selected = NO;
            break;
        case 3:
            self.workOfTherapistRateButton1.selected = YES;
            self.workOfTherapistRateButton2.selected = YES;
            self.workOfTherapistRateButton3.selected = YES;
            self.workOfTherapistRateButton4.selected = NO;
            self.workOfTherapistRateButton5.selected = NO;
            break;
        case 4:
            self.workOfTherapistRateButton1.selected = YES;
            self.workOfTherapistRateButton2.selected = YES;
            self.workOfTherapistRateButton3.selected = YES;
            self.workOfTherapistRateButton4.selected = YES;
            self.workOfTherapistRateButton5.selected = NO;
            break;
        case 5:
            self.workOfTherapistRateButton1.selected = YES;
            self.workOfTherapistRateButton2.selected = YES;
            self.workOfTherapistRateButton3.selected = YES;
            self.workOfTherapistRateButton4.selected = YES;
            self.workOfTherapistRateButton5.selected = YES;
            break;
        default:
            break;
    }
}

- (IBAction)workOfLabRatePressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    self.workOfLabVote = button.tag;
    
    switch (button.tag)
    {
        case 1:
            if (button.selected) {
                self.workOfLabVote = 0;
            }
            self.workOfLabRateButton1.selected = !self.workOfLabRateButton1.selected;
            self.workOfLabRateButton2.selected = NO;
            self.workOfLabRateButton3.selected = NO;
            self.workOfLabRateButton4.selected = NO;
            self.workOfLabRateButton5.selected = NO;
            break;
        case 2:
            self.workOfLabRateButton1.selected = YES;
            self.workOfLabRateButton2.selected = YES;
            self.workOfLabRateButton3.selected = NO;
            self.workOfLabRateButton4.selected = NO;
            self.workOfLabRateButton5.selected = NO;
            break;
        case 3:
            self.workOfLabRateButton1.selected = YES;
            self.workOfLabRateButton2.selected = YES;
            self.workOfLabRateButton3.selected = YES;
            self.workOfLabRateButton4.selected = NO;
            self.workOfLabRateButton5.selected = NO;
            break;
        case 4:
            self.workOfLabRateButton1.selected = YES;
            self.workOfLabRateButton2.selected = YES;
            self.workOfLabRateButton3.selected = YES;
            self.workOfLabRateButton4.selected = YES;
            self.workOfLabRateButton5.selected = NO;
            break;
        case 5:
            self.workOfLabRateButton1.selected = YES;
            self.workOfLabRateButton2.selected = YES;
            self.workOfLabRateButton3.selected = YES;
            self.workOfLabRateButton4.selected = YES;
            self.workOfLabRateButton5.selected = YES;
            break;
        default:
            break;
    }
}

- (IBAction)workOfBuffetRatePressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    self.workOfBuffetVote = button.tag;
    
    switch (button.tag)
    {
        case 1:
            if (button.selected)
                self.workOfBuffetVote = 0;
            self.workOfBuffetRateButton1.selected = !self.workOfBuffetRateButton1.selected;
            self.workOfBuffetRateButton2.selected = NO;
            self.workOfBuffetRateButton3.selected = NO;
            self.workOfBuffetRateButton4.selected = NO;
            self.workOfBuffetRateButton5.selected = NO;
            break;
        case 2:
            self.workOfBuffetRateButton1.selected = YES;
            self.workOfBuffetRateButton2.selected = YES;
            self.workOfBuffetRateButton3.selected = NO;
            self.workOfBuffetRateButton4.selected = NO;
            self.workOfBuffetRateButton5.selected = NO;
            break;
        case 3:
            self.workOfBuffetRateButton1.selected = YES;
            self.workOfBuffetRateButton2.selected = YES;
            self.workOfBuffetRateButton3.selected = YES;
            self.workOfBuffetRateButton4.selected = NO;
            self.workOfBuffetRateButton5.selected = NO;
            break;
        case 4:
            self.workOfBuffetRateButton1.selected = YES;
            self.workOfBuffetRateButton2.selected = YES;
            self.workOfBuffetRateButton3.selected = YES;
            self.workOfBuffetRateButton4.selected = YES;
            self.workOfBuffetRateButton5.selected = NO;
            break;
        case 5:
            self.workOfBuffetRateButton1.selected = YES;
            self.workOfBuffetRateButton2.selected = YES;
            self.workOfBuffetRateButton3.selected = YES;
            self.workOfBuffetRateButton4.selected = YES;
            self.workOfBuffetRateButton5.selected = YES;
            break;
        default:
            break;
    }
}

- (IBAction)scheduleRatePressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
   self. scheduleVote = button.tag;
    
    switch (button.tag)
    {
        case 1:
            if (button.selected) {
               self. scheduleVote = 0;
            }
           self. scheduleRateButton1.selected = !self.scheduleRateButton1.selected;
           self. scheduleRateButton2.selected = NO;
           self. scheduleRateButton3.selected = NO;
           self. scheduleRateButton4.selected = NO;
           self. scheduleRateButton5.selected = NO;
            break;
        case 2:
           self. scheduleRateButton1.selected = YES;
           self. scheduleRateButton2.selected = YES;
           self. scheduleRateButton3.selected = NO;
           self. scheduleRateButton4.selected = NO;
           self. scheduleRateButton5.selected = NO;
            break;
        case 3:
           self. scheduleRateButton1.selected = YES;
           self. scheduleRateButton2.selected = YES;
           self. scheduleRateButton3.selected = YES;
           self. scheduleRateButton4.selected = NO;
           self. scheduleRateButton5.selected = NO;
            break;
        case 4:
           self. scheduleRateButton1.selected = YES;
           self. scheduleRateButton2.selected = YES;
           self. scheduleRateButton3.selected = YES;
           self. scheduleRateButton4.selected = YES;
           self. scheduleRateButton5.selected = NO;
            break;
        case 5:
           self. scheduleRateButton1.selected = YES;
           self. scheduleRateButton2.selected = YES;
           self. scheduleRateButton3.selected = YES;
           self. scheduleRateButton4.selected = YES;
           self. scheduleRateButton5.selected = YES;
            break;
        default:
            break;
    }
}

- (IBAction)bloodDonateOrganizationRatePressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    self.workOfBuffetVote = button.tag;
    
    switch (button.tag)
    {
        case 1:
            if (button.selected) {
                self.workOfBuffetVote = 0;
            }
            self.bloodDonateOrganizationRateButton1.selected = !self.bloodDonateOrganizationRateButton1.selected;
            self.bloodDonateOrganizationRateButton2.selected = NO;
            self.bloodDonateOrganizationRateButton3.selected = NO;
            self.bloodDonateOrganizationRateButton4.selected = NO;
            self.bloodDonateOrganizationRateButton5.selected = NO;
            break;
        case 2:
            self.bloodDonateOrganizationRateButton1.selected = YES;
            self.bloodDonateOrganizationRateButton2.selected = YES;
            self.bloodDonateOrganizationRateButton3.selected = NO;
            self.bloodDonateOrganizationRateButton4.selected = NO;
            self.bloodDonateOrganizationRateButton5.selected = NO;
            break;
        case 3:
            self.bloodDonateOrganizationRateButton1.selected = YES;
            self.bloodDonateOrganizationRateButton2.selected = YES;
            self.bloodDonateOrganizationRateButton3.selected = YES;
            self.bloodDonateOrganizationRateButton4.selected = NO;
            self.bloodDonateOrganizationRateButton5.selected = NO;
            break;
        case 4:
            self.bloodDonateOrganizationRateButton1.selected = YES;
            self.bloodDonateOrganizationRateButton2.selected = YES;
            self.bloodDonateOrganizationRateButton3.selected = YES;
            self.bloodDonateOrganizationRateButton4.selected = YES;
            self.bloodDonateOrganizationRateButton5.selected = NO;
            break;
        case 5:
            self.bloodDonateOrganizationRateButton1.selected = YES;
            self.bloodDonateOrganizationRateButton2.selected = YES;
            self.bloodDonateOrganizationRateButton3.selected = YES;
            self.bloodDonateOrganizationRateButton4.selected = YES;
            self.bloodDonateOrganizationRateButton5.selected = YES;
            break;
        default:
            break;
    }
}

- (IBAction)pointOfDonationSpaceRatePressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    self.pointOfDonationSpaceVote = button.tag;
    
    switch (button.tag)
    {
        case 1:
            if (button.selected)
                self.pointOfDonationSpaceVote = 0;
            self.pointOfDonationSpaceRateButton1.selected = !self.pointOfDonationSpaceRateButton1.selected;
            self.pointOfDonationSpaceRateButton2.selected = NO;
            self.pointOfDonationSpaceRateButton3.selected = NO;
            self.pointOfDonationSpaceRateButton4.selected = NO;
            self.pointOfDonationSpaceRateButton5.selected = NO;
            break;
        case 2:
            self.pointOfDonationSpaceRateButton1.selected = YES;
            self.pointOfDonationSpaceRateButton2.selected = YES;
            self.pointOfDonationSpaceRateButton3.selected = NO;
            self.pointOfDonationSpaceRateButton4.selected = NO;
            self.pointOfDonationSpaceRateButton5.selected = NO;
            break;
        case 3:
            self.pointOfDonationSpaceRateButton1.selected = YES;
            self.pointOfDonationSpaceRateButton2.selected = YES;
            self.pointOfDonationSpaceRateButton3.selected = YES;
            self.pointOfDonationSpaceRateButton4.selected = NO;
            self.pointOfDonationSpaceRateButton5.selected = NO;
            break;
        case 4:
            self.pointOfDonationSpaceRateButton1.selected = YES;
            self.pointOfDonationSpaceRateButton2.selected = YES;
            self.pointOfDonationSpaceRateButton3.selected = YES;
            self.pointOfDonationSpaceRateButton4.selected = YES;
            self.pointOfDonationSpaceRateButton5.selected = NO;
            break;
        case 5:
            self.pointOfDonationSpaceRateButton1.selected = YES;
            self.pointOfDonationSpaceRateButton2.selected = YES;
            self.pointOfDonationSpaceRateButton3.selected = YES;
            self.pointOfDonationSpaceRateButton4.selected = YES;
            self.pointOfDonationSpaceRateButton5.selected = YES;
            break;
        default:
            break;
    }
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.scrollView.scrollEnabled = NO;
    float animationDuration = 0.3f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect scrollViewRect = self.scrollView.frame;
    scrollViewRect.origin.y -= 138;
    self.scrollView.frame = scrollViewRect;
    
    [UIView commitAnimations];
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"])
    {
        self.scrollView.scrollEnabled = YES;
        float animationDuration = 0.3f;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        CGRect scrollViewRect = self.scrollView.frame;
        scrollViewRect.origin.y += 138;
        self.scrollView.frame = scrollViewRect;
        
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
        
        self.scrollView.center = CGPointMake(self.scrollView.center.x, self.scrollView.center.y + 120);
        [UIView commitAnimations];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 2)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        
        self.scrollView.center = CGPointMake(self.scrollView.center.x, self.scrollView.center.y - 120);
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
        
        self.station = object;
        self.fullRate = rate;
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
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
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
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    [doneBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;
        
    self.workOfRegistryVote = 1;
    self.workOfLabVote = 1;
    self.workOfBuffetVote = 1;
    self.workOfTherapistVote = 1;
    self.scheduleVote = 1;
    self.bloodDonateOrganizationVote = 1;
    self.pointOfDonationSpaceVote = 1;
    
    if(self.fullRate <= 1.0f)
        [self.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    else if ((1.0f < self.fullRate) && (self.fullRate <= 2.0f))
    {
        [self.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    else if ((2.0f < self.fullRate) && (self.fullRate <= 3.0f))
    {
        [self.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    else if ((3.0f < self.fullRate) && (self.fullRate <= 4.0f))
    {
        [self.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar4 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    else if (4.0f < self.fullRate)
    {
        [self.ratedStar1 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar2 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar3 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar4 setImage:[UIImage imageNamed:@"ratedStarFill"]];
        [self.ratedStar5 setImage:[UIImage imageNamed:@"ratedStarFill"]];
    }
    
    self.stationTitleLable.text = [self.station objectForKey:@"title"];
    
    self.scrollView.contentSize = self.backgroundImage.frame.size;
    
    [self.nameField setValue:[UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    PFUser *user = [PFUser currentUser];
    if (user) {
        self.nameField.text = [user valueForKey:@"Name"];
    } else {
        self.nameField.text = @"";
    }
    self.commentTextField.text = @"";
}


@end
