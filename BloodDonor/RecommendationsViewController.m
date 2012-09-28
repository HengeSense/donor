//
//  RecommendationsViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 03.08.12.
//
//

#import "RecommendationsViewController.h"

@interface RecommendationsViewController ()

@end

@implementation RecommendationsViewController

#pragma mark Actions

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)spoilerButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 1)
    {
        //NSLog(@"before: %f %f %f %f", beforeBloodDonateView.frame.origin.x, beforeBloodDonateView.frame.origin.y, beforeBloodDonateView.frame.size.width, beforeBloodDonateView.frame.size.height);
        //NSLog(@"after: %f %f %f %f", afterBloodDonateView.frame.origin.x, afterBloodDonateView.frame.origin.y, afterBloodDonateView.frame.size.width, afterBloodDonateView.frame.size.height);
        
        if (button.selected)
        {
            canBloodDonateIfSubView.hidden = YES;
            canBloodDonateIfButton.selected = NO;
            canBloodDonateIfView.frame = CGRectMake(0.0f, 7.0f, 320.0f, 42.0f);
            beforeBloodDonateView.frame = CGRectMake(0.0f, 57.0f, 320.0f, 42.0f);
            afterBloodDonateView.frame = CGRectMake(0.0f, 107.0f, 320.0f, 42.0f);
            contentScrollView.contentSize = CGSizeMake(320, 400);
        }
        else
        {
            canBloodDonateIfSubView.hidden = NO;
            beforeBloodDonateSubView.hidden = YES;
            afterBloodDonateSubView.hidden = YES;
            
            canBloodDonateIfButton.selected = YES;
            beforeBloodDonateButton.selected = NO;
            afterBloodDonateButton.selected = NO;
            
            canBloodDonateIfView.frame = CGRectMake(0.0f, 7.0f, 320.0f, canBloodDonateIfView.frame.size.height + canBloodDonateIfSubView.frame.size.height);
            beforeBloodDonateView.frame = CGRectMake(0.0f, canBloodDonateIfView.frame.size.height + 12.0f, 320.0f, 42.0f);
            afterBloodDonateView.frame = CGRectMake(0.0f, beforeBloodDonateView.frame.size.height + beforeBloodDonateView.frame.origin.y + 5.0f, 320.0f, 42.0f);
            
            contentScrollView.contentSize = CGSizeMake(320.0f, 3.0f*5.0f + canBloodDonateIfView.frame.size.height + beforeBloodDonateView.frame.size.height + afterBloodDonateView.frame.size.height);
        }
    }
    
    else if (button.tag == 2)
    {
        if (button.selected)
        {
            beforeBloodDonateSubView.hidden = YES;
            beforeBloodDonateButton.selected = NO;
            canBloodDonateIfView.frame = CGRectMake(0.0f, 7.0f, 320.0f, 42.0f);
            beforeBloodDonateView.frame = CGRectMake(0.0f, 57.0f, 320.0f, 42.0f);
            afterBloodDonateView.frame = CGRectMake(0.0f, 107.0f, 320.0f, 42.0f);
            contentScrollView.contentSize = CGSizeMake(320, 400);
        }
        else
        {
            canBloodDonateIfSubView.hidden = YES;
            beforeBloodDonateSubView.hidden = NO;
            afterBloodDonateSubView.hidden = YES;
            
            canBloodDonateIfButton.selected = NO;
            beforeBloodDonateButton.selected = YES;
            afterBloodDonateButton.selected = NO;
            
            canBloodDonateIfView.frame = CGRectMake(0.0f, 7.0f, 320.0f, 42.0f);
            beforeBloodDonateView.frame = CGRectMake(0.0f, 57.0f, 320.0f, beforeBloodDonateView.frame.size.height + beforeBloodDonateSubView.frame.size.height);
            afterBloodDonateView.frame = CGRectMake(0.0f, 57.0f + beforeBloodDonateView.frame.size.height + 5.0f, 320.0f, 42.0f);

            contentScrollView.contentSize = CGSizeMake(320.0f, 4.0f*5.0f + canBloodDonateIfView.frame.size.height + beforeBloodDonateView.frame.size.height + afterBloodDonateView.frame.size.height);
        }
    }
    
    else if (button.tag == 3)
    {
        if (button.selected)
        {
            afterBloodDonateSubView.hidden = YES;
            afterBloodDonateButton.selected = NO;
            canBloodDonateIfView.frame = CGRectMake(0.0f, 7.0f, 320.0f, 42.0f);
            beforeBloodDonateView.frame = CGRectMake(0.0f, 57.0f, 320.0f, 42.0f);
            afterBloodDonateView.frame = CGRectMake(0.0f, 107.0f, 320.0f, 42.0f);
            contentScrollView.contentSize = CGSizeMake(320, 400);
        }
        else
        {
            canBloodDonateIfSubView.hidden = YES;
            beforeBloodDonateSubView.hidden = YES;
            afterBloodDonateSubView.hidden = NO;
            
            canBloodDonateIfButton.selected = NO;
            beforeBloodDonateButton.selected = NO;
            afterBloodDonateButton.selected = YES;
            
            canBloodDonateIfView.frame = CGRectMake(0.0f, 7.0f, 320.0f, 42.0f);
            beforeBloodDonateView.frame = CGRectMake(0.0f, 57.0f, 320.0f, 42.0f);
            afterBloodDonateView.frame = CGRectMake(0.0f, 107.0f, 320.0f, afterBloodDonateView.frame.size.height + afterBloodDonateSubView.frame.size.height);
         
            contentScrollView.contentSize = CGSizeMake(320.0f, 5.0f*5.0f + canBloodDonateIfView.frame.size.height + beforeBloodDonateView.frame.size.height + afterBloodDonateView.frame.size.height);
        }
    }
        
}

#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Рекомендации";
    
    canBloodDonateIfSubView.hidden = YES;
    beforeBloodDonateSubView.hidden = YES;
    afterBloodDonateSubView.hidden = YES;
    
    contentScrollView.contentSize = CGSizeMake(320, 400);
    
    //canBloodDonateIfSubView.contentSize = CGSizeMake(320, 316);
    //beforeBloodDonateSubView.contentSize = CGSizeMake(320, 288);
    //afterBloodDonateSubView.contentSize = CGSizeMake(320, 389);
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
