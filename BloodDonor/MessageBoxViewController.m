//
//  MessageBoxViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 09.08.12.
//
//

#import "MessageBoxViewController.h"

@interface MessageBoxViewController ()

@end

@implementation MessageBoxViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                title:(NSString *)title
              message:(NSString *)message
         cancelButton:(NSString *)cancelButton
             okButton:(NSString *)okButton;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        titleString = [title retain];
        textString = [message retain];
        cancelString = [cancelButton retain];
        okString = [okButton retain];
    }
    return self;
}

- (IBAction)okClick:(id)sender
{
    [self.view removeFromSuperview];
    if (delegate)
        [delegate messageBoxResult:YES controller:self message:textString];
}

- (IBAction)cancelClick:(id)sender
{
    [self.view removeFromSuperview];
    if (delegate)
        [delegate messageBoxResult:NO controller:self message:textString];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (titleString)
    {
        textWithoutTitle.hidden = YES;
        
        titleLabel.text = titleString;
        textWithTitle.text = textString;
    }
    else
    {
        titleLabel.hidden = YES;
        textWithTitle.hidden = YES;
        
        textWithoutTitle.text = textString;
    }
    
    if (okString)
    {
        singleButton.hidden = YES;
        
        [doubleButtonCancel setTitle:cancelString forState:UIControlStateNormal];
        [doubleButtonCancel setTitle:cancelString forState:UIControlStateHighlighted];
        
        [doubleButtonOk setTitle:okString forState:UIControlStateNormal];
        [doubleButtonOk setTitle:okString forState:UIControlStateHighlighted];
    }
    else
    {
        doubleButtonCancel.hidden = YES;
        doubleButtonOk.hidden = YES;
        
        [singleButton setTitle:cancelString forState:UIControlStateNormal];
        [singleButton setTitle:cancelString forState:UIControlStateHighlighted];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
