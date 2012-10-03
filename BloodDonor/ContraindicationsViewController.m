//
//  ContraindicationsViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 05.08.12.
//
//

#import "ContraindicationsViewController.h"
#import "TempContraindicationsCell.h"
#import "AbsoluteContraindicationsCell.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface ContraindicationsViewController ()

-(void)textFieldDidChange:(UITextField *)textField;

@end

@implementation ContraindicationsViewController

#pragma mark Actions

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clearButtonPressed:(id)sender
{
    emptySearchLabel.hidden = YES;
    
    if (sender == tempClearButton)
    {
        if (!timeSearchTextField.isFirstResponder)
            [timeSearchTextField becomeFirstResponder];
        timeSearchTextField.text = @"";
        tempClearButton.hidden = YES;
    }
    else
    {
        if (!absoluteSearchTextField.isFirstResponder)
            [absoluteSearchTextField becomeFirstResponder];
        absoluteSearchTextField.text = @"";
        absoluteClearButton.hidden = YES;
    }
}

- (IBAction)tabSelected:(id)sender
{
    UIButton *button = (UIButton*)sender;
        
    if (!button.selected)
    {
        button.selected = YES;
        
        if (button.tag == 0)
        {
            timeButton.selected = NO;
            [timeSearchView removeFromSuperview];
            [searchView addSubview:absoluteSearchView];
        }
        else if (button.tag == 1)
        {
            absoluteButton.selected = NO;
            [absoluteSearchView removeFromSuperview];
            [searchView addSubview:timeSearchView];
        }
        [contraindicationsTableView reloadData];
    }
}

- (IBAction)searchCancelPressed:(id)sender
{
    contraindicationsTableView.frame = CGRectMake(0.0f, 57.0f, 320.0f, 327.0f);
    hideBarView.hidden = NO;
    isSearch = NO;
    [self.view endEditing:YES];
    tempClearButton.hidden = YES;
    absoluteClearButton.hidden = YES;
    [contraindicationsTableView reloadData];
    emptySearchLabel.hidden = YES;
}

#pragma mark TextEditDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //isSearch = YES;
    
    if ([textField isEqual: absoluteSearchTextField])
    {
        contraindicationsTableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 427.0f);
        hideBarView.hidden = YES;
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [searchArray removeAllObjects];
    emptySearchLabel.hidden = YES;
        
    if ([textField.text isEqualToString:@""])
    {
        isSearch = NO;
        if ([textField isEqual: absoluteSearchTextField])
            absoluteClearButton.hidden = YES;
        else
            tempClearButton.hidden = YES;
    }
    else
    {
        if ([textField isEqual: absoluteSearchTextField])
        {
            absoluteClearButton.hidden = NO;
            
            for (PFObject *object in absoluteLevel1Array)
            {
                isSearch = YES;
                NSString *title = [object valueForKey:@"title"];
                NSRange addressResultsRange = [title rangeOfString:absoluteSearchTextField.text options:NSCaseInsensitiveSearch];
                
                if (addressResultsRange.length > 0)
                    [searchArray addObject:object];
            }
        }
        else
        {
            tempClearButton.hidden = NO;
            for (NSArray *tempArray in timeContentArray)
            {
                for (NSMutableDictionary *tempDictionary in tempArray)
                {
                    PFObject *object = [tempDictionary objectForKey:@"content"];
                    isSearch = YES;
                    NSString *title = [object valueForKey:@"title"];
                    NSRange addressResultsRange = [title rangeOfString:timeSearchTextField.text options:NSCaseInsensitiveSearch];
                    
                    if (addressResultsRange.length > 0)
                        [searchArray addObject:[NSDictionary dictionaryWithDictionary:tempDictionary]];
                }
            }
        }
    }
    if (searchArray.count == 0 && ![textField.text isEqualToString:@""])
        emptySearchLabel.hidden = NO;
    
    [contraindicationsTableView reloadData];

}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isSearch)
    {
        return 1;
    }
    else
    {
        if (timeButton.selected)
            return timeLevel0Array.count;
        else
            return absoluteLevel0Array.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearch)
    {
        return searchArray.count;
    }
    else
    {
        int rowsCount = 0;
        
        if (timeButton.selected)
        {
            return ((NSArray *)[timeContentArray objectAtIndex:section]).count;
        }
        else
        {
            for (int i = 0; i < absoluteLevel1Array.count; i++)
            {
                if ([[(PFObject *)[absoluteLevel1Array objectAtIndex:i] valueForKey:@"parent_id"]  isEqual:[(PFObject *)[absoluteLevel0Array objectAtIndex:section] valueForKey:@"objectId"]])
                    rowsCount ++;
            }
        }
        
        return rowsCount;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearch)
    {
        if (absoluteButton.selected)
        {
            return 30;
        }
        else
        {
            return [[(NSDictionary *)[searchArray objectAtIndex:indexPath.row] valueForKey:@"height"] floatValue];
        }
        
    }
    else
    {
        if (timeButton.selected)
        {
            return [[(NSDictionary *)[(NSArray *)[timeContentArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"height"] floatValue];
        }
        else
            return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 307, 40)] autorelease];
    UIImageView *background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contraindicationsSectionBackground"]] autorelease];
    UILabel *sectionText;
    UILabel *termChallengeText;
    UILabel *illText;
    
    [sectionView addSubview:background];
    
    if (timeButton.selected)
    {
        termChallengeText = [[[UILabel alloc] initWithFrame:CGRectMake(220, 7, 85, 14)] autorelease];
        illText = [[[UILabel alloc] initWithFrame:CGRectMake(15, 7, 100, 14)] autorelease];
        termChallengeText.textAlignment = UITextAlignmentRight;
        illText.textAlignment = UITextAlignmentLeft;
        illText.text = @"Заболевание";
        termChallengeText.text = @"Срок отвода";
        illText.backgroundColor = [UIColor clearColor];
        illText.textColor = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
        illText.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        termChallengeText.backgroundColor = [UIColor clearColor];
        termChallengeText.textColor = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
        termChallengeText.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [sectionView addSubview:illText];
        [sectionView addSubview:termChallengeText];
    }
    else
    {
        if(isSearch)
        {
            sectionText = [[[UILabel alloc] initWithFrame:CGRectMake(0, 7, 320, 14)] autorelease];
            sectionText.text = @"Результаты поиска";
            sectionText.textAlignment = UITextAlignmentCenter;
            sectionText.backgroundColor = [UIColor clearColor];
            sectionText.textColor = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            sectionText.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
            [sectionView addSubview:sectionText];
        }
        else
        {
            sectionText = [[[UILabel alloc] initWithFrame:CGRectMake(0, 7, 320, 14)] autorelease];
            sectionText.textAlignment = UITextAlignmentCenter;
            sectionText.text = [(PFObject *)[absoluteLevel0Array objectAtIndex:section] valueForKey:@"title"];
            sectionText.backgroundColor = [UIColor clearColor];
            sectionText.textColor = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
            sectionText.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
            [sectionView addSubview:sectionText];
        }
    }
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        
    if (!isSearch && timeButton.selected && section > 0)
        return 0.0f;
    else
        return 25.0f;//[UIImage imageNamed:@"contraindicationsSectionBackground"].size.height/2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object;
    if (timeButton.selected)
    {
        if (isSearch)
        {
            object = [(NSDictionary *)[searchArray objectAtIndex:indexPath.row] objectForKey:@"content"];
        }
        else
        {
            object = [(NSDictionary *)[(NSArray *)[timeContentArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"content"];
        }
        
        static NSString *CellIdentifier = @"timeCell";
        
        TempContraindicationsCell *cell = (TempContraindicationsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TempContraindicationsCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        UIImage *image =[UIImage imageNamed:@"dot"];
        
        if (![timeSearchTextField.text isEqualToString:@""])
        {
            cell.illnessLabel.hidden = YES;
            NSString *illness = [object valueForKey:@"title"];
            NSRange illnessRange = [illness rangeOfString:timeSearchTextField.text options:NSCaseInsensitiveSearch];
            
            NSString *outString = [illness stringByReplacingOccurrencesOfString:[illness substringWithRange:illnessRange] withString:[NSString stringWithFormat:@"<tempsearch>%@</tempsearch>", [illness substringWithRange:illnessRange]]];
            
            FTCoreTextView *coreTextView = [[FTCoreTextView alloc] initWithFrame:CGRectMake(cell.illnessLabel.frame.origin.x, cell.illnessLabel.frame.origin.y, cell.illnessLabel.frame.size.width - 10, cell.illnessLabel.frame.size.height)]; 
            coreTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [cell addSubview:coreTextView];
            [coreTextView addStyles:tempCoreTextStyle];
            [coreTextView setText:outString];
            [coreTextView fitToSuggestedHeight];
        }
        else
        {
            cell.illnessLabel.text = [object valueForKey:@"title"];
        }
        
        cell.timeAllotmentLabel.text = [object valueForKey:@"body"];
                
        if (isSearch)
        {
            for (CGFloat summ = 0.0f; summ < [[(NSDictionary *)[searchArray objectAtIndex:indexPath.row] objectForKey:@"height"] floatValue]; summ += image.size.height)
            {
                UIImageView *dotImage= [[[UIImageView alloc] initWithImage:image] autorelease];
                dotImage.frame = CGRectMake(210.0f, summ, image.size.width, image.size.height);
                [cell addSubview:dotImage];
            }
        }
        else
        {
            for (CGFloat summ = 0.0f; summ < [[(NSDictionary *)[(NSArray *)[timeContentArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"height"] floatValue]; summ += image.size.height)
            {
                UIImageView *dotImage= [[[UIImageView alloc] initWithImage:image] autorelease];
                dotImage.frame = CGRectMake(210.0f, summ, image.size.width, image.size.height);
                [cell addSubview:dotImage];
            }
        }
        
        return cell;
    }
    else
    {
        if(isSearch)
        {
            object = [searchArray objectAtIndex:indexPath.row];
        }
        else
        {
            NSMutableArray *tempArray = [NSMutableArray array];
            
            for (int i = 0; i < absoluteLevel1Array.count; i++)
            {
                if ([[(PFObject *)[absoluteLevel1Array objectAtIndex:i] valueForKey:@"parent_id"]  isEqual:[(PFObject *)[absoluteLevel0Array objectAtIndex:indexPath.section] valueForKey:@"objectId"]])
                    [tempArray addObject:[absoluteLevel1Array objectAtIndex:i]];
            }
            
            object = [tempArray objectAtIndex:indexPath.row];
        }
        
        static NSString *CellIdentifier = @"Cell";
        
        AbsoluteContraindicationsCell *cell = (AbsoluteContraindicationsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AbsoluteContraindicationsCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        if (![absoluteSearchTextField.text isEqualToString:@""])
        {
            cell.illnessLabel.hidden = YES;
            NSString *illness = [object valueForKey:@"title"];
            NSRange illnessRange = [illness rangeOfString:absoluteSearchTextField.text options:NSCaseInsensitiveSearch];
            
            NSString *outString = [illness stringByReplacingOccurrencesOfString:[illness substringWithRange:illnessRange] withString:[NSString stringWithFormat:@"<abssearch>%@</abssearch>", [illness substringWithRange:illnessRange]]];
            
            FTCoreTextView *coreTextView = [[FTCoreTextView alloc] initWithFrame:cell.illnessLabel.frame];
            coreTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [cell addSubview:coreTextView];
            [coreTextView addStyles:absCoreTextStyle];
            [coreTextView setText:outString];
            [coreTextView fitToSuggestedHeight];
        }
        else
            cell.illnessLabel.text = [object valueForKey:@"title"];
        
    
        return cell;
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
    
    FTCoreTextStyle *absDefaultStyle = [FTCoreTextStyle new];
    absDefaultStyle.name = FTCoreTextTagDefault;	//thought the default name is already set to FTCoreTextTagDefault
    absDefaultStyle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.f];
    absDefaultStyle.color = [UIColor colorWithRed:132.0f/255.0f green:113.0f/255.0f blue:104.0f/255.0f alpha:1.0f];
    absDefaultStyle.textAlignment = FTCoreTextAlignementLeft;
    
    FTCoreTextStyle *absSearchStyle = [FTCoreTextStyle styleWithName:@"abssearch"]; // using fast method
    absSearchStyle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.f];
    absSearchStyle.color = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
    absSearchStyle.textAlignment = FTCoreTextAlignementLeft;
    
    absCoreTextStyle = [[NSArray alloc] initWithObjects:absDefaultStyle, absSearchStyle, nil];
    
    FTCoreTextStyle *tempDefaultStyle = [FTCoreTextStyle new];
    tempDefaultStyle.name = FTCoreTextTagDefault;	//thought the default name is already set to FTCoreTextTagDefault
    tempDefaultStyle.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.f];
    tempDefaultStyle.color = [UIColor colorWithRed:132.0f/255.0f green:113.0f/255.0f blue:104.0f/255.0f alpha:1.0f];
    tempDefaultStyle.textAlignment = FTCoreTextAlignementLeft;
    
    FTCoreTextStyle *tempSearchStyle = [FTCoreTextStyle styleWithName:@"tempsearch"]; // using fast method
    tempSearchStyle.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.f];
    tempSearchStyle.color = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
    tempSearchStyle.textAlignment = FTCoreTextAlignementLeft;
    
    tempCoreTextStyle = [[NSArray alloc] initWithObjects:tempDefaultStyle, tempSearchStyle, nil];
    
    self.title = @"Противопоказания";
    
    [absoluteSearchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [timeSearchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
   
    absoluteLevel0Array = [NSMutableArray new];
    absoluteLevel1Array = [NSMutableArray new];
    absoluteLevel2Array = [NSMutableArray new];
    timeContentArray = [NSMutableArray new];
    timeLevel0Array = [NSMutableArray new];
    timeLevel1Array = [NSMutableArray new];
    timeLevel2Array = [NSMutableArray new];
    searchArray = [NSMutableArray new];
    
    isSearch = NO;
    
    contraindicationsTableView.contentOffset = CGPointMake(0.0f, 53.0f);
    
    [searchView addSubview:absoluteSearchView];
    
    indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 331)];
    indicatorView.backgroundColor = [UIColor blackColor];
    indicatorView.alpha = 0.5f;
    UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    indicator.frame = CGRectMake(160 - indicator.frame.size.width / 2.0f,
                                 240 - indicator.frame.size.height / 2.0f,
                                 indicator.frame.size.width,
                                 indicator.frame.size.height);
    
    [indicatorView addSubview:indicator];
    [indicator startAnimating];
    [self.navigationController.tabBarController.view addSubview:indicatorView];
        
    PFQuery *query = [PFQuery queryWithClassName:@"Contras"];
    [query findObjectsInBackgroundWithTarget:self selector:@selector(callbackWithResult:error:)];
    
}

- (void)callbackWithResult:(NSArray *)result error:(NSError *)error
{
    if (result)
    {
        [absoluteLevel0Array removeAllObjects];
        [absoluteLevel1Array removeAllObjects];
        [absoluteLevel2Array removeAllObjects];
        [timeLevel0Array removeAllObjects];
        [timeLevel1Array removeAllObjects];
        [timeLevel2Array removeAllObjects];
        [timeContentArray removeAllObjects];
       
        for (int i =0 ; i < result.count; i++)
        {
            if ([[(PFObject *)[result objectAtIndex:i] objectForKey:@"absolute"] boolValue])
            {
                if ([[(PFObject *)[result objectAtIndex:i] objectForKey:@"level"] intValue] == 0)
                    [absoluteLevel0Array addObject:[result objectAtIndex:i]];
                else if ([[(PFObject *)[result objectAtIndex:i] objectForKey:@"level"] intValue] == 1)
                    [absoluteLevel1Array addObject:[result objectAtIndex:i]];
                else if ([[(PFObject *)[result objectAtIndex:i] objectForKey:@"level"] intValue] == 2)
                    [absoluteLevel2Array addObject:[result objectAtIndex:i]];
            }
            else
            {
                if ([[(PFObject *)[result objectAtIndex:i] objectForKey:@"level"] intValue] == 0)
                    [timeLevel0Array addObject:[result objectAtIndex:i]];
                else if ([[(PFObject *)[result objectAtIndex:i] objectForKey:@"level"] intValue] == 1)
                    [timeLevel1Array addObject:[result objectAtIndex:i]];
                else if ([[(PFObject *)[result objectAtIndex:i] objectForKey:@"level"] intValue] == 2)
                    [timeLevel2Array addObject:[result objectAtIndex:i]];
            }
        }
        
        NSMutableArray *timeSectionArray = [NSMutableArray array];
        NSMutableDictionary *timeCellDictionary = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                    nil, @"content",
                                                    nil, @"height",
                                                    nil] autorelease];
        
        for (int i = 0; timeLevel0Array.count > i; i++)
        {
            
           
            for (int j = 0; j < timeLevel1Array.count; j++)
            {
                if ([[(PFObject *)[timeLevel1Array objectAtIndex:j] valueForKey:@"parent_id"]  isEqual:[(PFObject *)[timeLevel0Array objectAtIndex:i] valueForKey:@"objectId"]])
                {
                    CGSize maximumLabelSize = CGSizeMake(192.0f, 9999.0f);
                    
                    CGSize labelSize = [[(PFObject *)[timeLevel1Array objectAtIndex:j] valueForKey:@"title"] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
                    
                    NSLog(@"%f", labelSize.height);
                    
                    [timeCellDictionary setObject:[timeLevel1Array objectAtIndex:j] forKey:@"content"];
                    [timeCellDictionary setObject:[NSNumber numberWithFloat:(labelSize.height + 20.0f)] forKey:@"height"];
                    [timeSectionArray addObject:[NSDictionary dictionaryWithDictionary:timeCellDictionary]];
                    
                }
            }
            [timeContentArray addObject:[NSArray arrayWithArray:timeSectionArray]];
           // NSLog(@"%@", timeContentArray);
            [timeSectionArray removeAllObjects];
           // NSLog(@"%@", timeContentArray);
        }
    }
    
    [contraindicationsTableView reloadData];
    
    [indicatorView removeFromSuperview];
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
    [absCoreTextStyle release];
    [tempCoreTextStyle release];
    [indicatorView release];
    [searchArray release];
    [absoluteLevel0Array release];
    [absoluteLevel1Array release];
    [absoluteLevel2Array release];
    [timeContentArray release];
    [timeLevel0Array release];
    [timeLevel1Array release];
    [timeLevel2Array release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
