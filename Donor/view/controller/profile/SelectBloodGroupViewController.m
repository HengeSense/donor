//
//  SelectBloodGroupViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectBloodGroupViewController.h"
#import "Common.h"
#import <Parse/Parse.h>

@implementation SelectBloodGroupViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)cancelClick:(id)sender
{
    [delegate bloodGroupChanged:nil];
    [self hideModal];
}

- (IBAction)doneClick:(id)sender;
{
    [delegate bloodGroupChanged:[NSString stringWithFormat:@"%@%@", group,rh]];
    [Common getInstance].bloodGroup  = [NSNumber numberWithInt:bloodGroupInt];
    [Common getInstance].bloodRH = [NSNumber numberWithInt:bloodRHInt];
    [self hideModal];
}

- (IBAction)bloodGroupSelected:(id)sender
{
    UIButton *button = (UIButton *)sender;
        
    if (!button.selected)
        [self setSelectedBloodGroupButton:button];
}

- (IBAction)rhSelected:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (!button.selected)
    {
        [self setSelectedBloodRhButton:button]; 
    }
}

- (void)setSelectedBloodGroupButton:(UIButton *)button
{
    bloodGroupInt = button.tag;
    
    NSMutableArray *tempButtonsArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempLablesArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < bloodGroupButtonsArray.count; i++)
    {
        UIButton *arrayButton = (UIButton *)[bloodGroupButtonsArray objectAtIndex:i];
        UILabel *arrayLabel = (UILabel *)[bloodGroupLablesArray objectAtIndex:i];
        
        if (button.tag == arrayButton.tag)
        {
            arrayButton.selected = YES;
            [arrayButton setImage:[UIImage imageNamed:@"radioButtonSelected.png"] forState:UIControlStateHighlighted];
            arrayLabel.textColor = [UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1];
            group = arrayLabel.text;
        }
        else
        {
            arrayButton.selected = NO;
            [arrayButton setImage:[UIImage imageNamed:@"radioButtonNotSelected.png"] forState:UIControlStateHighlighted];
            arrayLabel.textColor = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1]; 
        }
        
        [tempButtonsArray addObject:arrayButton];
        [tempLablesArray addObject:arrayLabel];
    }
    
    [bloodGroupButtonsArray removeAllObjects];
    [bloodGroupButtonsArray addObjectsFromArray:tempButtonsArray];
    [bloodGroupLablesArray removeAllObjects];
    [bloodGroupLablesArray addObjectsFromArray:tempLablesArray];
}

- (void)setSelectedBloodRhButton:(UIButton *)button
{
    if (button.tag == 5)
    {
        buttonRhP.selected = YES;
        buttonRhN.selected = NO;
        [buttonRhP setImage:[UIImage imageNamed:@"radioButtonSelected.png"] forState:UIControlStateHighlighted];
        [buttonRhN setImage:[UIImage imageNamed:@"radioButtonNotSelected.png"] forState:UIControlStateHighlighted];
        labelRhP.textColor = [UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1];
        labelRhN.textColor = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1];
        rh = labelRhP.text;
        bloodRHInt = 0;
    }
    else if (button.tag == 6)
    {
        buttonRhP.selected = NO;
        buttonRhN.selected = YES;
        [buttonRhP setImage:[UIImage imageNamed:@"radioButtonNotSelected.png"] forState:UIControlStateHighlighted];
        [buttonRhN setImage:[UIImage imageNamed:@"radiobBsuttonSelected.png"] forState:UIControlStateHighlighted];
        labelRhP.textColor = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1]; 
        labelRhN.textColor = [UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1];
        rh = labelRhN.text;
        bloodRHInt = 1;
    }
}

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    bloodGroupButtonsArray = [[NSMutableArray alloc] initWithObjects: buttonOI, buttonAII, buttonBIII, buttonABIV, nil];
    bloodGroupLablesArray = [[NSMutableArray alloc] initWithObjects: labelOI, labelAII, labelBIII, labelABIV, nil];
    
    bloodGroupInt = 0;
    bloodRHInt = 0;
    group = @"O(I)";
    rh = @"RH+";
    
    [self configureUIAndStates];
    
}

- (void)configureUIAndStates
{
    if ([PFUser currentUser])
    {
        PFUser *user = [PFUser currentUser];
        
        switch ([[user objectForKey:@"BloodGroup"] intValue])
        {
            case 0:
                [self setSelectedBloodGroupButton:buttonOI];
                bloodGroupInt = 0;
                break;
            case 1:
                [self setSelectedBloodGroupButton:buttonAII];
                bloodGroupInt = 1;
                break;
            case 2:
                [self setSelectedBloodGroupButton:buttonBIII];
                bloodGroupInt = 2;
                break;
            case 3:
                [self setSelectedBloodGroupButton:buttonABIV];
                bloodGroupInt = 3;
                break;
            default:
                [self setSelectedBloodGroupButton:buttonOI];
                break;
        }
        
        if ([[user objectForKey:@"BloodRh"] intValue] == 0)
        {
            [self setSelectedBloodRhButton:buttonRhP];
            bloodRHInt = 0;
        }
        else
        {
            [self setSelectedBloodRhButton:buttonRhN];
            bloodRHInt = 1;
        }
        
    }
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
