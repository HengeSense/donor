//
//  StationsViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 13.07.12.
//  Modified by Sergey Seroshtan on 21.11.12
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "StationsViewController.h"
#import "StationDescriptionViewController.h"
#import "FilterViewController.h"
#import "StationsCell.h"
#import <Parse/Parse.h>
#import "Common.h"
#import "StationsAnnotation.h"
#import "NewsViewController.h"
#import "MBProgressHUD.h"

@interface StationsViewController ()

@property (nonatomic, strong) UIView *fadeView;

@property (nonatomic, strong) NSMutableDictionary *tableDictionary;
@property (nonatomic, strong) NSMutableDictionary *searchTableDictionary;
@property (nonatomic, strong) NSMutableArray *stationsArrayList;

@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, assign) BOOL isShowOneStation;

@property (nonatomic, strong) PFObject *selectedStationToShowOnMap;
@property (nonatomic, strong) PFObject *objectForEvent;

@property (nonatomic, strong) NSArray *coreTextStyle;

@property (nonatomic, retain) CoreLocationController *coreLocationController;

- (void)textFieldDidChange;
- (void)doneButtonPressed:(id)snder;

@end

@implementation StationsViewController

@synthesize coreLocationController;

#pragma mark Actions

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneButtonPressed:(id)snder
{
    if (self.objectForEvent)
    {
        [Common getInstance].eventStationAddress = [self.objectForEvent valueForKey:@"small_adress"];
        
        BOOL isInLastStations = NO;
        for (int i = 0; [Common getInstance].lastStations.count > i; i++)
        {
            if ([[self.objectForEvent valueForKey:@"objectId"] isEqualToString:[[Common getInstance].lastStations objectAtIndex:i]])
                isInLastStations = YES;
        }
        if (!isInLastStations)
            [Common getInstance].lastStations = [NSArray arrayWithObject:[self.objectForEvent valueForKey:@"objectId"]];
        
        [self.navigationController popViewControllerAnimated:YES];
    }    
}

- (IBAction)searchPressed:(id)sender
{
    [self.barView removeFromSuperview];
    [self.searchContainerView addSubview:self.searchView];
    [self.searchField becomeFirstResponder];
    self.searchField.text = @"";
}

- (IBAction)searchCancelPressed:(id)sender
{
    [self.searchView removeFromSuperview];
    [self.searchContainerView addSubview:self.barView];
    self.searchField.text = @"";
    [self textFieldDidChange];
    [self.searchField resignFirstResponder];
    [self reloadMapAnnotations];
    
    if ([self.view.subviews containsObject:self.fadeView])
        [self.fadeView removeFromSuperview];
    self.clearButton.hidden = YES;
    self.emptySearchLabel.hidden = YES;
}

- (IBAction)clearButtonPressed:(id)sender
{
    if (!self.searchField.isFirstResponder)
        [self.searchField becomeFirstResponder];
    self.searchField.text = @"";
    self.clearButton.hidden = YES;
    [self textFieldDidChange];
}

- (IBAction)switchView:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 1 && !button.selected)
    {
        button.selected = YES;
        self.mapButton.selected = NO;
        
        for(UIView *subview in [self.contentView subviews])
        {
            [subview removeFromSuperview];
        }
        
        [self.contentView addSubview:self.stationsTableView];
    }
    else if (button.tag == 2 && !button.selected)
    {
        button.selected = YES;
        self.tableButton.selected = NO;
        
        for(UIView *subview in [self.contentView subviews])
        {
            [subview removeFromSuperview];
        }
        
        self.stationsMap.frame = self.contentView.bounds;
        [self.contentView addSubview:self.stationsMapView];
      
        [self reloadMapAnnotations];
    }
    else if (button.tag == 3)
    {
        FilterViewController *controller =
                [[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark TextEditDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""] && ![self.view.subviews containsObject:self.fadeView])
    {
        [self.view addSubview:self.fadeView];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([self.view.subviews containsObject:self.fadeView])
        [self.fadeView removeFromSuperview];
    return YES;
}

- (void)textFieldDidChange
{
    self.emptySearchLabel.hidden = YES;
    
    if (![self.searchField.text isEqualToString:@""])
    {
        if ([self.view.subviews containsObject:self.fadeView])
            [self.fadeView removeFromSuperview];
        self.clearButton.hidden = NO;
        
        NSMutableArray *insertIndexPathsArray = [NSMutableArray array];
        NSMutableArray *deleteIndexPathsArray = [NSMutableArray array];
        NSMutableIndexSet *deleteIndexSet = [NSMutableIndexSet indexSet];
        NSMutableIndexSet *insertIndexSet = [NSMutableIndexSet indexSet];
        
        int sectionNumber = 0;
        
        if ([self.searchTableDictionary objectForKey:@"last"] != [NSNull null])
        {
            NSMutableArray *currentArray;
            if ([self.tableDictionary objectForKey:@"last"] != [NSNull null])
                currentArray = [NSMutableArray arrayWithArray:[self.tableDictionary objectForKey:@"last"]];
            else
                currentArray = [NSMutableArray array];
                
            NSMutableArray *fullArray = [NSMutableArray arrayWithArray:[self.searchTableDictionary objectForKey:@"last"]];
            
            for (PFObject *object in fullArray)
            {
                NSString *address = [object valueForKey:@"small_adress"];
                NSRange addressResultsRange = [address rangeOfString:self.searchField.text options:NSCaseInsensitiveSearch];
                
                if (addressResultsRange.length <= 0)
                {
                    if ([currentArray containsObject:object])
                    {
                        //delete
                        [deleteIndexPathsArray addObject:[NSIndexPath indexPathForRow:[currentArray indexOfObject:object] inSection:sectionNumber]];
                        [currentArray removeObject:object];
                    }
                }
                else
                {
                    if (![currentArray containsObject:object])
                    {
                        //insert
                        [currentArray addObject:object];
                        [insertIndexPathsArray addObject:[NSIndexPath indexPathForRow:[currentArray indexOfObject:object] inSection:sectionNumber]];
                     }
                }
            }
            
            if (currentArray.count == 0)
            {
                [deleteIndexSet addIndex:sectionNumber];
                [self.tableDictionary setObject:[NSNull null] forKey:@"last"];
            }
            else
            {
                if ([self.tableDictionary objectForKey:@"last"] != [NSNull null])
                    [insertIndexSet addIndex:sectionNumber];
                [self.tableDictionary setObject:currentArray forKey:@"last"];
            }
            sectionNumber ++;
        }
        
        if ([self.searchTableDictionary objectForKey:@"one"] != [NSNull null])
        {
            NSMutableArray *currentArray;
            if ([self.tableDictionary objectForKey:@"one"] != [NSNull null])
                currentArray = [NSMutableArray arrayWithArray:[self.tableDictionary objectForKey:@"one"]];
            else
                currentArray = [NSMutableArray array];
            
            NSMutableArray *fullArray = [NSMutableArray arrayWithArray:[self.searchTableDictionary objectForKey:@"one"]];
            
            for (PFObject *object in fullArray)
            {
                NSString *address = [object valueForKey:@"small_adress"];
                NSRange addressResultsRange = [address rangeOfString:self.searchField.text options:NSCaseInsensitiveSearch];
                
                if (addressResultsRange.length <= 0)
                {
                    if ([currentArray containsObject:object])
                    {
                        //delete
                        [deleteIndexPathsArray addObject:[NSIndexPath indexPathForRow:[currentArray indexOfObject:object] inSection:sectionNumber]];
                        [currentArray removeObject:object];
                    }
                }
                else
                {
                    if (![currentArray containsObject:object])
                    {
                        //insert
                        [currentArray addObject:object];
                        [insertIndexPathsArray addObject:[NSIndexPath indexPathForRow:[currentArray indexOfObject:object] inSection:sectionNumber]];
                    }
                }
            }
            
            if (currentArray.count == 0)
            {
                [deleteIndexSet addIndex:sectionNumber];
                [self.tableDictionary setObject:[NSNull null] forKey:@"one"];
            }
            else
            {
                if ([self.tableDictionary objectForKey:@"one"] != [NSNull null])
                    [insertIndexSet addIndex:sectionNumber];
                [self.tableDictionary setObject:currentArray forKey:@"one"];
            }
            sectionNumber ++;
        }
        
        if ([self.searchTableDictionary objectForKey:@"three"] != [NSNull null])
        {
            NSMutableArray *currentArray;
            if ([self.tableDictionary objectForKey:@"three"] != [NSNull null])
                currentArray = [NSMutableArray arrayWithArray:[self.tableDictionary objectForKey:@"three"]];
            else
                currentArray = [NSMutableArray array];
            
            NSMutableArray *fullArray = [NSMutableArray arrayWithArray:[self.searchTableDictionary objectForKey:@"three"]];
            
            for (PFObject *object in fullArray)
            {
                NSString *address = [object valueForKey:@"small_adress"];
                NSRange addressResultsRange = [address rangeOfString:self.searchField.text options:NSCaseInsensitiveSearch];
                
                if (addressResultsRange.length <= 0)
                {
                    if ([currentArray containsObject:object])
                    {
                        //delete
                        [deleteIndexPathsArray addObject:[NSIndexPath indexPathForRow:[currentArray indexOfObject:object] inSection:sectionNumber]];
                        [currentArray removeObject:object];
                    }
                }
                else
                {
                    if (![currentArray containsObject:object])
                    {
                        //insert
                        [currentArray addObject:object];
                        [insertIndexPathsArray addObject:[NSIndexPath indexPathForRow:[currentArray indexOfObject:object] inSection:sectionNumber]];
                    }
                }
            }
            
            if (currentArray.count == 0)
            {
                [deleteIndexSet addIndex:sectionNumber];
                [self.tableDictionary setObject:[NSNull null] forKey:@"three"];
            }
            else
            {
                if ([self.tableDictionary objectForKey:@"three"] != [NSNull null])
                    [insertIndexSet addIndex:sectionNumber];
                [self.tableDictionary setObject:currentArray forKey:@"three"];
            }
            sectionNumber ++;
        }
        
        if ([self.searchTableDictionary objectForKey:@"five"] != [NSNull null])
        {
            NSMutableArray *currentArray;
            if ([self.tableDictionary objectForKey:@"five"] != [NSNull null])
                currentArray = [NSMutableArray arrayWithArray:[self.tableDictionary objectForKey:@"five"]];
            else
                currentArray = [NSMutableArray array];
            
            NSMutableArray *fullArray = [NSMutableArray arrayWithArray:[self.searchTableDictionary objectForKey:@"five"]];
            
            for (PFObject *object in fullArray)
            {
                NSString *address = [object valueForKey:@"small_adress"];
                NSRange addressResultsRange = [address rangeOfString:self.searchField.text options:NSCaseInsensitiveSearch];
                
                if (addressResultsRange.length <= 0)
                {
                    if ([currentArray containsObject:object])
                    {
                        //delete
                        [deleteIndexPathsArray addObject:[NSIndexPath indexPathForRow:[currentArray indexOfObject:object] inSection:sectionNumber]];
                        [currentArray removeObject:object];
                    }
                }
                else
                {
                    if (![currentArray containsObject:object])
                    {
                        //insert
                        [currentArray addObject:object];
                        [insertIndexPathsArray addObject:[NSIndexPath indexPathForRow:[currentArray indexOfObject:object] inSection:sectionNumber]];
                    }
                }
            }
            
            if (currentArray.count == 0)
            {
                [deleteIndexSet addIndex:sectionNumber];
                [self.tableDictionary setObject:[NSNull null] forKey:@"five"];
            }
            else
            {
                if ([self.tableDictionary objectForKey:@"five"] != [NSNull null])
                    [insertIndexSet addIndex:sectionNumber];
                [self.tableDictionary setObject:currentArray forKey:@"five"];
            }
            sectionNumber ++;
        }
        
        if ([self.searchTableDictionary objectForKey:@"ten"] != [NSNull null])
        {
            NSMutableArray *currentArray;
            if ([self.tableDictionary objectForKey:@"ten"] != [NSNull null])
                currentArray = [NSMutableArray arrayWithArray:[self.tableDictionary objectForKey:@"ten"]];
            else
                currentArray = [NSMutableArray array];
            
            NSMutableArray *fullArray = [NSMutableArray arrayWithArray:[self.searchTableDictionary objectForKey:@"ten"]];
            
            for (PFObject *object in fullArray)
            {
                NSString *address = [object valueForKey:@"small_adress"];
                NSRange addressResultsRange = [address rangeOfString:self.searchField.text options:NSCaseInsensitiveSearch];
                
                if (addressResultsRange.length <= 0)
                {
                    if ([currentArray containsObject:object])
                    {
                        //delete
                        [deleteIndexPathsArray addObject:[NSIndexPath indexPathForRow:[currentArray indexOfObject:object] inSection:sectionNumber]];
                        [currentArray removeObject:object];
                    }
                }
                else
                {
                    if (![currentArray containsObject:object])
                    {
                        //insert
                        [currentArray addObject:object];
                        [insertIndexPathsArray addObject:[NSIndexPath indexPathForRow:[currentArray indexOfObject:object] inSection:sectionNumber]];
                    }
                }
            }
            
            if (currentArray.count == 0)
            {
                [deleteIndexSet addIndex:sectionNumber];
                [self.tableDictionary setObject:[NSNull null] forKey:@"ten"];
            }
            else
            {
                if ([self.tableDictionary objectForKey:@"ten"] != [NSNull null])
                    [insertIndexSet addIndex:sectionNumber];
                [self.tableDictionary setObject:currentArray forKey:@"ten"];
            }
            sectionNumber ++;
        }
        
        if ([self.searchTableDictionary objectForKey:@"fifteen"] != [NSNull null])
        {
            NSMutableArray *currentArray;
            if ([self.tableDictionary objectForKey:@"fifteen"] != [NSNull null])
                currentArray = [NSMutableArray arrayWithArray:[self.tableDictionary objectForKey:@"fifteen"]];
            else
                currentArray = [NSMutableArray array];
            
            NSMutableArray *fullArray = [NSMutableArray arrayWithArray:[self.searchTableDictionary objectForKey:@"fifteen"]];
            
            for (PFObject *object in fullArray)
            {
                NSString *address = [object valueForKey:@"small_adress"];
                NSRange addressResultsRange = [address rangeOfString:self.searchField.text options:NSCaseInsensitiveSearch];
                
                if (addressResultsRange.length <= 0)
                {
                    if ([currentArray containsObject:object])
                    {
                        //delete
                        [deleteIndexPathsArray addObject:[NSIndexPath indexPathForRow:[currentArray indexOfObject:object] inSection:sectionNumber]];
                        [currentArray removeObject:object];
                    }
                }
                else
                {
                    if (![currentArray containsObject:object])
                    {
                        //insert
                        [currentArray addObject:object];
                        [insertIndexPathsArray addObject:[NSIndexPath indexPathForRow:[currentArray indexOfObject:object] inSection:sectionNumber]];
                    }
                }
            }
            
            if (currentArray.count == 0)
            {
                [deleteIndexSet addIndex:sectionNumber];
                [self.tableDictionary setObject:[NSNull null] forKey:@"fifteen"];
            }
            else
            {
                if ([self.tableDictionary objectForKey:@"fifteen"] != [NSNull null])
                    [insertIndexSet addIndex:sectionNumber];
                [self.tableDictionary setObject:currentArray forKey:@"fifteen"];
            }
            sectionNumber ++;
        }
        
        if ([self.searchTableDictionary objectForKey:@"other"] != [NSNull null])
        {
            NSMutableArray *currentArray;
            if ([self.tableDictionary objectForKey:@"other"] != [NSNull null])
                currentArray = [NSMutableArray arrayWithArray:[self.tableDictionary objectForKey:@"other"]];
            else
                currentArray = [NSMutableArray array];
            
            NSMutableArray *fullArray = [NSMutableArray arrayWithArray:[self.searchTableDictionary objectForKey:@"other"]];
            
            for (PFObject *object in fullArray)
            {
                NSString *address = [object valueForKey:@"small_adress"];
                NSRange addressResultsRange = [address rangeOfString:self.searchField.text options:NSCaseInsensitiveSearch];
                
                if (addressResultsRange.length <= 0)
                {
                    if ([currentArray containsObject:object])
                    {
                        //delete
                        [deleteIndexPathsArray addObject:[NSIndexPath indexPathForRow:[currentArray indexOfObject:object] inSection:sectionNumber]];
                        [currentArray removeObject:object];
                    }
                }
                else
                {
                    if (![currentArray containsObject:object])
                    {
                        //insert
                        [currentArray addObject:object];
                        [insertIndexPathsArray addObject:[NSIndexPath indexPathForRow:[currentArray indexOfObject:object] inSection:sectionNumber]];
                    }
                }
            }
            
            if (currentArray.count == 0)
            {
                [deleteIndexSet addIndex:sectionNumber];
                [self.tableDictionary setObject:[NSNull null] forKey:@"other"];
            }
            else
            {
                if ([self.tableDictionary objectForKey:@"other"] != [NSNull null])
                    [insertIndexSet addIndex:sectionNumber];
                [self.tableDictionary setObject:currentArray forKey:@"other"];
            }
        }
        if ([self.tableDictionary objectForKey:@"last"] != [NSNull null] || [self.tableDictionary objectForKey:@"one"] != [NSNull null] || [self.tableDictionary objectForKey:@"three"] != [NSNull null] || [self.tableDictionary objectForKey:@"five"] != [NSNull null] || [self.tableDictionary objectForKey:@"ten"] != [NSNull null] || [self.tableDictionary objectForKey:@"fifteen"] != [NSNull null] || [self.tableDictionary objectForKey:@"other"] != [NSNull null])
            self.emptySearchLabel.hidden = YES;
        else
            self.emptySearchLabel.hidden = NO;
        
        [self reloadData];
    }
    else
    {
        if (![self.view.subviews containsObject:self.fadeView])
            [self.view addSubview:self.fadeView];
        self.clearButton.hidden = YES;
       
        if (![self.searchTableDictionary isEqualToDictionary:self.tableDictionary])
        {
            [self.tableDictionary removeAllObjects];
            [self.tableDictionary setDictionary:self.searchTableDictionary];
            [self reloadData];
        }
    }
}

#pragma mark TableView

- (void)reloadData
{
    self.emptySearchLabel.hidden = YES;
    [self.stationsTable reloadData];
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNull null], @"last",
                                            [NSNull null], @"one",
                                            [NSNull null], @"three",
                                            [NSNull null], @"five",
                                            [NSNull null], @"ten",
                                            [NSNull null], @"fifteen",
                                            [NSNull null], @"other",
                                            nil];
    
    if ([self.tableDictionary isEqual:tempDictionary]) {
        self.emptySearchLabel.hidden = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    switch (section)
    {
        case 0:
            if ([self.tableDictionary objectForKey:@"last"] != [NSNull null])
                return ((NSArray *)[self.tableDictionary objectForKey:@"last"]).count;
            else
                return 0;
            
        case 1:
            if ([self.tableDictionary objectForKey:@"one"] != [NSNull null])
                return ((NSArray *)[self.tableDictionary objectForKey:@"one"]).count;
            else 
                return 0;
            
        case 2:
            if ([self.tableDictionary objectForKey:@"three"] != [NSNull null])
                return ((NSArray *)[self.tableDictionary objectForKey:@"three"]).count;
            else 
                return 0;
            
        case 3:
            if ([self.tableDictionary objectForKey:@"five"] != [NSNull null])
                return ((NSArray *)[self.tableDictionary objectForKey:@"five"]).count;
            else  
                return 0;
            
        case 4:
            if ([self.tableDictionary objectForKey:@"ten"] != [NSNull null])
                return ((NSArray *)[self.tableDictionary objectForKey:@"ten"]).count;
            else 
                return 0;
            
        case 5:
            if ([self.tableDictionary objectForKey:@"fifteen"] != [NSNull null])
                return ((NSArray *)[self.tableDictionary objectForKey:@"fifteen"]).count;
            else
                return 0;
            
        case 6:
            if ([self.tableDictionary objectForKey:@"other"] != [NSNull null])
                return ((NSArray *)[self.tableDictionary objectForKey:@"other"]).count;
            else
                return 0;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object;
  
    if (indexPath.section == 0)
        object = (PFObject *)[(NSArray *)[self.tableDictionary objectForKey:@"last"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 1)
        object = (PFObject *)[(NSArray *)[self.tableDictionary objectForKey:@"one"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 2)
        object = (PFObject *)[(NSArray *)[self.tableDictionary objectForKey:@"three"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 3)
        object = (PFObject *)[(NSArray *)[self.tableDictionary objectForKey:@"five"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 4)
        object = (PFObject *)[(NSArray *)[self.tableDictionary objectForKey:@"ten"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 5)
        object = (PFObject *)[(NSArray *)[self.tableDictionary objectForKey:@"fifteen"] objectAtIndex:indexPath.row];
    else
        object = (PFObject *)[(NSArray *)[self.tableDictionary objectForKey:@"other"] objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    StationsCell *cell = (StationsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StationsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if ([[object objectForKey:@"saturdayWork"] boolValue])
        [cell.workAtSaturdayImageView setImage:[UIImage imageNamed:@"workAtSaturdayIcon"]];
    else
        [cell.workAtSaturdayImageView setImage:[UIImage imageNamed:@"workAtSaturdayIconDisabled"]];
    
    if ([[object objectForKey: @"donorsForChildrens"] boolValue])
        [cell.donorsForChildrenImageView setImage:[UIImage imageNamed:@"donorForChildrenIcon"]];
    else
        [cell.donorsForChildrenImageView setImage:[UIImage imageNamed:@"donorForChildrenIconDisabled"]];
    
    if ([[object objectForKey: @"regionalRegistration"] boolValue])
        [cell.regionalRegistrationImageView setImage:[UIImage imageNamed:@"regionalRegistrationIcon"]];
    else
        [cell.regionalRegistrationImageView setImage:[UIImage imageNamed:@"regionalRegistrationIconDisabled"]];
    
    
    if (![self.searchField.text isEqualToString:@""])
    {
        cell.addressLabel.hidden = YES;
        NSString *address = [object valueForKey:@"small_adress"];
        NSRange addressRange = [address rangeOfString:self.searchField.text options:NSCaseInsensitiveSearch];
        
        NSString *outString = [address stringByReplacingOccurrencesOfString:[address substringWithRange:addressRange] withString:[NSString stringWithFormat:@"<search>%@</search>", [address substringWithRange:addressRange]]];
        FTCoreTextView *coreTextView = [[FTCoreTextView alloc] initWithFrame:cell.addressLabel.frame];
        coreTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [coreTextView addStyles:self.coreTextStyle];
        [coreTextView setText:outString];
        [coreTextView fitToSuggestedHeight];
        [cell addSubview:coreTextView];
    }
    else
    {
        cell.addressLabel.hidden = NO;
        cell.addressLabel.text = [object valueForKey:@"small_adress"];
    }

    cell.isEvent = NO;
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object;
    
    if (indexPath.section == 0)
        object = (PFObject *)[(NSArray *)[self.tableDictionary objectForKey:@"last"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 1)
        object = (PFObject *)[(NSArray *)[self.tableDictionary objectForKey:@"one"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 2)
        object = (PFObject *)[(NSArray *)[self.tableDictionary objectForKey:@"three"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 3)
        object = (PFObject *)[(NSArray *)[self.tableDictionary objectForKey:@"five"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 4)
        object = (PFObject *)[(NSArray *)[self.tableDictionary objectForKey:@"ten"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 5)
        object = (PFObject *)[(NSArray *)[self.tableDictionary objectForKey:@"fifteen"] objectAtIndex:indexPath.row];
    else
        object = (PFObject *)[(NSArray *)[self.tableDictionary objectForKey:@"other"] objectAtIndex:indexPath.row];
    
 
    StationDescriptionViewController *controller = [[StationDescriptionViewController alloc]
            initWithNibName:@"StationDescriptionViewController" bundle:nil station:object];
    [self.navigationController pushViewController:controller animated:YES];
    [self searchCancelPressed:nil];
    
    return indexPath;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 307, 32)];
    
    UIImageView *background =
            [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contraindicationsSectionBackground"]];
    UILabel *sectionText = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 320, 14)];
    sectionText.textAlignment = UITextAlignmentCenter;
    
    if (section == 0)
        sectionText.text = @"Последние использованые";
    else if (section == 1)
        sectionText.text = @"До 1 км";
    else if (section == 2)
        sectionText.text = @"До 3 км";
    else if (section == 3)
        sectionText.text = @"До 5 км";
    else if (section == 4)
        sectionText.text = @"До 10 км";
    else if (section == 5)
        sectionText.text = @"До 15 км";
    else
        sectionText.text = @"Более 15 км";
    
    sectionText.backgroundColor = [UIColor clearColor];
    sectionText.textColor = [UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
    sectionText.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    [sectionView addSubview:background];
    [sectionView addSubview:sectionText];
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            if ([self.tableDictionary objectForKey:@"last"] != [NSNull null])
                return 32;
            else
                return 0;
            
        case 1:
            if ([self.tableDictionary objectForKey:@"one"] != [NSNull null])
                return 32;
            else
                return 0;
            
        case 2:
            if ([self.tableDictionary objectForKey:@"three"] != [NSNull null])
                return 32;
            else
                return 0;
            
        case 3:
            if ([self.tableDictionary objectForKey:@"five"] != [NSNull null])
                return 32;
            else
                return 0;
            
        case 4:
            if ([self.tableDictionary objectForKey:@"ten"] != [NSNull null])
                return 32;
            else
                return 0;
            
        case 5:
            if ([self.tableDictionary objectForKey:@"fifteen"] != [NSNull null])
                return 32;
            else
                return 0;
            
        case 6:
            if ([self.tableDictionary objectForKey:@"other"] != [NSNull null])
                return 32;
            else
                return 0;
            
        default:
            return 32;
    }
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if (!self.isShowOneStation)
    {
        NSMutableArray *mapArray = [NSMutableArray array];
        if ([self.tableDictionary objectForKey:@"last"] != [NSNull null])
            [mapArray addObjectsFromArray:[self.tableDictionary objectForKey:@"last"]];
        if ([self.tableDictionary objectForKey:@"one"] != [NSNull null])
            [mapArray addObjectsFromArray:[self.tableDictionary objectForKey:@"one"]];
        if ([self.tableDictionary objectForKey:@"three"] != [NSNull null])
            [mapArray addObjectsFromArray:[self.tableDictionary objectForKey:@"three"]];
        if ([self.tableDictionary objectForKey:@"five"] != [NSNull null])
            [mapArray addObjectsFromArray:[self.tableDictionary objectForKey:@"five"]];
        if ([self.tableDictionary objectForKey:@"ten"] != [NSNull null])
            [mapArray addObjectsFromArray:[self.tableDictionary objectForKey:@"ten"]];
        if ([self.tableDictionary objectForKey:@"fifteen"] != [NSNull null])
            [mapArray addObjectsFromArray:[self.tableDictionary objectForKey:@"fifteen"]];
        if ([self.tableDictionary objectForKey:@"other"] != [NSNull null])
            [mapArray addObjectsFromArray:[self.tableDictionary objectForKey:@"other"]];
        
        PFObject *object = (PFObject *)[mapArray objectAtIndex:((StationsAnnotation *)view.annotation).tag];
        
        StationDescriptionViewController *controller = [[StationDescriptionViewController alloc]
                initWithNibName:@"StationDescriptionViewController" bundle:nil station:object];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation
{
    MKAnnotationView *annotationView =
            [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"stationLoation"];
    
    if (annotation == self.stationsMap.userLocation)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userLocation"]];
        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y,
                imageView.frame.size.width, imageView.frame.size.height);
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(-5, 5);
        [annotationView addSubview:imageView];
    }
    else
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapAnnotationIcon"]];
        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y,
                imageView.frame.size.width, imageView.frame.size.height);
        annotationView.canShowCallout = YES;
        
        annotationView.calloutOffset = CGPointMake(-5, 5);
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = infoButton;
        [annotationView addSubview:imageView];
    }
    return annotationView;
}

- (void)reloadMapAnnotations
{
    if (self.isShowOneStation)
    {
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        PFGeoPoint *stationPoint = [self.selectedStationToShowOnMap objectForKey:@"latlon"];
        CLLocation *location =
                [[CLLocation alloc] initWithLatitude:stationPoint.latitude longitude:stationPoint.longitude];
        
        StationsAnnotation *annotation = [StationsAnnotation new];
        annotation.coordinate = location.coordinate;
        annotation.title = [self.selectedStationToShowOnMap objectForKey:@"small_adress"];
        [self.stationsMap addAnnotation:annotation];
        
        region.center = annotation.coordinate;
        
        span.latitudeDelta = 0.5;
        span.longitudeDelta = 0.5;
        region.span = span;
        [self.stationsMap setRegion:region animated:TRUE];
        [self.stationsMap regionThatFits:region];
    }
    else
    {
        [self.stationsMap removeAnnotations:[self.stationsMap.annotations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"!(self isKindOfClass: %@)", [MKUserLocation class]]]];
        NSMutableArray *mapArray = [NSMutableArray array];
        if ([self.tableDictionary objectForKey:@"last"] != [NSNull null])
            [mapArray addObjectsFromArray:[self.tableDictionary objectForKey:@"last"]];
        if ([self.tableDictionary objectForKey:@"one"] != [NSNull null])
            [mapArray addObjectsFromArray:[self.tableDictionary objectForKey:@"one"]];
        if ([self.tableDictionary objectForKey:@"three"] != [NSNull null])
            [mapArray addObjectsFromArray:[self.tableDictionary objectForKey:@"three"]];
        if ([self.tableDictionary objectForKey:@"five"] != [NSNull null])
            [mapArray addObjectsFromArray:[self.tableDictionary objectForKey:@"five"]];
        if ([self.tableDictionary objectForKey:@"ten"] != [NSNull null])
            [mapArray addObjectsFromArray:[self.tableDictionary objectForKey:@"ten"]];
        if ([self.tableDictionary objectForKey:@"fifteen"] != [NSNull null])
            [mapArray addObjectsFromArray:[self.tableDictionary objectForKey:@"fifteen"]];
        if ([self.tableDictionary objectForKey:@"other"] != [NSNull null])
            [mapArray addObjectsFromArray:[self.tableDictionary objectForKey:@"other"]];
        
        for (int i = 0; mapArray.count > i; i++)
        {
            PFGeoPoint *stationPoint = [[mapArray objectAtIndex:i] objectForKey:@"latlon"];
            CLLocation *location =
                    [[CLLocation alloc] initWithLatitude:stationPoint.latitude longitude:stationPoint.longitude];
            
            StationsAnnotation *annotation = [StationsAnnotation new];
            annotation.coordinate = location.coordinate;
            
            annotation.tag = i;
            annotation.title = [[mapArray objectAtIndex:i] objectForKey:@"small_adress"];
            
            [self.stationsMap addAnnotation:annotation];
        }
       
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        region.center = CLLocationCoordinate2DMake(55.77, 37.60);
        region.span = MKCoordinateSpanMake(0.1, 0.1);
        span.latitudeDelta = 0.5;
        span.longitudeDelta = 0.5;
        region.span=span;
        [self.stationsMap setRegion:region animated:TRUE];
        [self.stationsMap regionThatFits:region];
    }
}

- (void)locationUpdate:(CLLocation *)location
{
    [self.coreLocationController.locationManager stopUpdatingHeading];
    [self.coreLocationController.locationManager stopUpdatingLocation];
	(void)[self.currentLocation initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
   
    if (!self.isShowOneStation)
    {
        MBProgressHUD  *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        PFQuery *stations = [PFQuery queryWithClassName:@"Stations"];
        [stations findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [self processLocationUpdateWitResult:objects error:error];
            [progressHud hide:YES];
        }];
    }
    else
    {
        if (self.navigationController.isBeingPresented) {
            [self reloadMapAnnotations];
        }
    }
}

- (void)locationError:(NSError *)error
{
   [coreLocationController.locationManager stopUpdatingLocation];
}


#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.tableDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNull null], @"last",
                           [NSNull null], @"one",
                           [NSNull null], @"three",
                           [NSNull null], @"five",
                           [NSNull null], @"ten",
                           [NSNull null], @"fifteen",
                           [NSNull null], @"other",
                           nil];
        
        self.searchTableDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNull null], @"last",
                                 [NSNull null], @"one",
                                 [NSNull null], @"three",
                                 [NSNull null], @"five",
                                 [NSNull null], @"ten",
                                 [NSNull null], @"fifteen",
                                 [NSNull null], @"other",
                                 nil];
        
        self.stationsArrayList = [NSMutableArray new];
        
        self.currentLocation = [[CLLocation alloc] init];
        self.coreLocationController = [[CoreLocationController alloc] init];
        [self.coreLocationController setDelegate:self];

    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)station
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.selectedStationToShowOnMap = station;
        
        self.tableDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNull null], @"last",
                           [NSNull null], @"one",
                           [NSNull null], @"three",
                           [NSNull null], @"five",
                           [NSNull null], @"ten",
                           [NSNull null], @"fifteen",
                           [NSNull null], @"other",
                           nil];
        
        self.searchTableDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNull null], @"last",
                                 [NSNull null], @"one",
                                 [NSNull null], @"three",
                                 [NSNull null], @"five",
                                 [NSNull null], @"ten",
                                 [NSNull null], @"fifteen",
                                 [NSNull null], @"other",
                                 nil];
        
        self.stationsArrayList = [NSMutableArray new];
        
        self.currentLocation = [[CLLocation alloc] init];
        self.coreLocationController = [[CoreLocationController alloc] init];
        [self.coreLocationController setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
    defaultStyle.name = FTCoreTextTagDefault;	//thought the default name is already set to FTCoreTextTagDefault
    defaultStyle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.f];
    defaultStyle.color = [UIColor colorWithRed:100.0f/255.0f green:91.0f/255.0f blue:84.0f/255.0f alpha:1.0f];
    defaultStyle.textAlignment = FTCoreTextAlignementLeft;
    
    FTCoreTextStyle *searchStyle = [FTCoreTextStyle styleWithName:@"search"]; // using fast method
    searchStyle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.f];
    searchStyle.color = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1.0f];
    searchStyle.textAlignment = FTCoreTextAlignementLeft;
    
    self.coreTextStyle = [[NSArray alloc] initWithObjects:defaultStyle, searchStyle, nil];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.fadeView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.searchView.frame.origin.y + self.searchView.frame.size.height, screenSize.width, screenSize.height)];
    self.fadeView.backgroundColor = [UIColor blackColor];
    self.fadeView.alpha = 0.7f;
    
    self.title = @"Станции";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
            style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [self.searchContainerView addSubview:self.barView];
    
    [self.searchField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    self.stationsMap.showsUserLocation = YES;
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    if (viewControllers.count > 1)
    {
        self.backButton.hidden = NO;
        self.isShowOneStation = YES;
        self.tableButton.enabled = NO;
        self.mapButton.selected = YES;
        [self.contentView addSubview:self.stationsMapView];
        self.filterButton.enabled = NO;
        self.searchField.enabled = NO;
    }
    else
    {
        self.isShowOneStation = NO;
        [self.contentView addSubview:self.stationsTableView];
        [self.coreLocationController.locationManager startUpdatingLocation];
    }
    [self reloadMapAnnotations];
}

- (void)processLocationUpdateWitResult:(NSArray *)result error:(NSError *)error
{
    if (result)
    {
        NSMutableArray *oneKmStationsArray = [NSMutableArray array];
        NSMutableArray *threeKmStationsArray = [NSMutableArray array];
        NSMutableArray *fiveKmStationsArray = [NSMutableArray array];
        NSMutableArray *tenKmStationsArray = [NSMutableArray array];
        NSMutableArray *fifteenKmStationsArray = [NSMutableArray array];
        NSMutableArray *lastStations = [NSMutableArray array];
        NSMutableArray *otherStationsArray = [NSMutableArray array];
        
        [self.stationsArrayList removeAllObjects];
        [self.stationsArrayList addObjectsFromArray:result];
                
        for (int i = 0; self.stationsArrayList.count > i; i++)
        {
            if ([Common getInstance].isMoscow && ![[(PFObject *)[self.stationsArrayList objectAtIndex:i] valueForKey:@"city"] isEqualToString:@"Москва"])
            {
                
                [self.stationsArrayList removeObjectAtIndex:i];
                i--;
            }
            else if ([Common getInstance].isPeterburg && ![[(PFObject *)[self.stationsArrayList objectAtIndex:i] valueForKey:@"city"] isEqualToString:@"Санкт-Петербург"])
            {
                [self.stationsArrayList removeObjectAtIndex:i];
                i--;
            }
            
            else if ([Common getInstance].isRegionalRegistration && ![[(PFObject *)[self.stationsArrayList objectAtIndex:i] valueForKey:@"regionalRegistration"] boolValue])
            {
                [self.stationsArrayList removeObjectAtIndex:i];
                i--;
            }
            
            else if ([Common getInstance].isWorkAtSaturday && ![[(PFObject *)[self.stationsArrayList objectAtIndex:i] valueForKey:@"saturdayWork"] boolValue])
            {
                [self.stationsArrayList removeObjectAtIndex:i];
                i--;
            }
            
            else if ([Common getInstance].isDonorsForChildren && ![[(PFObject *)[self.stationsArrayList objectAtIndex:i] valueForKey:@"donorsForChildrens"] boolValue])
            {
                [self.stationsArrayList removeObjectAtIndex:i];
                i--;
            }
        }
        
        if ([Common getInstance].lastStations.count != 0)
        {
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.stationsArrayList];
            int deleteIndex = 0;
            for (int i = 0; i < self.stationsArrayList.count; i++)
            {
                for (int j = 0; [Common getInstance].lastStations.count > j; j++)
                {
                    if ([[[self.stationsArrayList objectAtIndex:i] valueForKey:@"objectId"] isEqualToString:[[Common getInstance].lastStations objectAtIndex:j]])
                    {
                        [lastStations addObject:[self.stationsArrayList objectAtIndex:i]];
                        [tempArray removeObjectAtIndex:(i - deleteIndex)];
                        deleteIndex ++;
                    }
                }
            }
            [self.stationsArrayList removeAllObjects];
            [self.stationsArrayList addObjectsFromArray:tempArray];
        }
        
        for (int i = 0; self.stationsArrayList.count > i; i++)
        {
            PFGeoPoint *stationPoint = [[self.stationsArrayList objectAtIndex:i] objectForKey:@"latlon"];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:stationPoint.latitude longitude:stationPoint.longitude];
                
            double distance = [self.currentLocation distanceFromLocation:location]/1000.0f;
               
            if (distance <= 1.0f)
                [oneKmStationsArray addObject:[self.stationsArrayList objectAtIndex:i]];
            else if (distance > 1.0f && distance <= 3.0f)
                [threeKmStationsArray addObject:[self.stationsArrayList objectAtIndex:i]];
            else if (distance > 3.0f && distance <= 5.0f)
                [fiveKmStationsArray addObject:[self.stationsArrayList objectAtIndex:i]];
            else if (distance > 5.0f && distance <= 10.0f)
                [tenKmStationsArray addObject:[self.stationsArrayList objectAtIndex:i]];
            else if (distance > 10.0f && distance <= 15.0f)
                [fifteenKmStationsArray addObject:[self.stationsArrayList objectAtIndex:i]];
            else
                [otherStationsArray addObject:[self.stationsArrayList objectAtIndex:i]];
        }
        
        if (lastStations.count > 0)
            [self.tableDictionary setObject:lastStations forKey:@"last"];
        else
            [self.tableDictionary setObject:[NSNull null] forKey:@"last"];
        if (oneKmStationsArray.count > 0)
            [self.tableDictionary setObject:oneKmStationsArray forKey:@"one"];
        else
            [self.tableDictionary setObject:[NSNull null] forKey:@"one"];
        if (threeKmStationsArray.count > 0)
            [self.tableDictionary setObject:threeKmStationsArray forKey:@"three"];
        else
            [self.tableDictionary setObject:[NSNull null] forKey:@"three"];
        if (fiveKmStationsArray.count > 0)
            [self.tableDictionary setObject:fiveKmStationsArray forKey:@"five"];
        else
            [self.tableDictionary setObject:[NSNull null] forKey:@"five"];
        if (tenKmStationsArray.count > 0)
            [self.tableDictionary setObject:tenKmStationsArray forKey:@"ten"];
        else
            [self.tableDictionary setObject:[NSNull null] forKey:@"ten"];
        if (fifteenKmStationsArray.count > 0)
            [self.tableDictionary setObject:fifteenKmStationsArray forKey:@"fifteen"];
        else
            [self.tableDictionary setObject:[NSNull null] forKey:@"fifteen"];
        if (otherStationsArray.count > 0)
            [self.tableDictionary setObject:otherStationsArray forKey:@"other"];
        else
            [self.tableDictionary setObject:[NSNull null] forKey:@"other"];
        
        [self.searchTableDictionary removeAllObjects];
        [self.searchTableDictionary setDictionary:self.tableDictionary];
    }
    
    [self reloadData];
    [self reloadMapAnnotations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [coreLocationController.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [coreLocationController.locationManager stopUpdatingLocation];
}

@end
