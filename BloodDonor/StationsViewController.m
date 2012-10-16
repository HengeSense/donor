//
//  StationsViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 13.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StationsViewController.h"
#import "StationDescriptionViewController.h"
#import "FilterViewController.h"
#import "StationsCell.h"
#import <Parse/Parse.h>
#import "Common.h"
#import "StationsAnnotation.h"
#import "EventPlanningViewController.h"
#import "NewsViewController.h"

@interface StationsViewController ()

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
    if (objectForEvent)
    {
        [Common getInstance].eventStationAddress = [objectForEvent valueForKey:@"small_adress"];
        
        BOOL isInLastStations = NO;
        for (int i = 0; [Common getInstance].lastStations.count > i; i++)
        {
            if ([[objectForEvent valueForKey:@"objectId"] isEqualToString:[[Common getInstance].lastStations objectAtIndex:i]])
                isInLastStations = YES;
        }
        if (!isInLastStations)
            [Common getInstance].lastStations = [NSArray arrayWithObject:[objectForEvent valueForKey:@"objectId"]];
        
        [self.navigationController popViewControllerAnimated:YES];
    }    
}

- (IBAction)searchPressed:(id)sender
{
    [barView removeFromSuperview];
    [searchContainerView addSubview:searchView];
    [searchField becomeFirstResponder];
    searchField.text = @"";
}

- (IBAction)searchCancelPressed:(id)sender
{
    [searchView removeFromSuperview];
    [searchContainerView addSubview:barView];
    searchField.text = @"";
    [self textFieldDidChange];
    [searchField resignFirstResponder];
    [self reloadMapAnnotations];
    
    if ([self.view.subviews containsObject:fadeView])
        [fadeView removeFromSuperview];
    clearButton.hidden = YES;
    emptySearchLabel.hidden = YES;
}

- (IBAction)clearButtonPressed:(id)sender
{
    if (!searchField.isFirstResponder)
        [searchField becomeFirstResponder];
    searchField.text = @"";
    clearButton.hidden = YES;
    [self textFieldDidChange];
}

- (IBAction)switchView:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 1 && !button.selected)
    {
        button.selected = YES;
        mapButton.selected = NO;
        
        for(UIView *subview in [contentView subviews])
        {
            [subview removeFromSuperview];
        }
        
        [contentView addSubview:stationsTableView];
    }
    else if (button.tag == 2 && !button.selected)
    {
        button.selected = YES;
        tableButton.selected = NO;
        
        for(UIView *subview in [contentView subviews])
        {
            [subview removeFromSuperview];
        }
        [contentView addSubview:stationsMapView];
      
        [self reloadMapAnnotations];
    }
    else if (button.tag == 3)
    {
        FilterViewController *controller = [[[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark TextEditDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""] && ![self.view.subviews containsObject:fadeView])
    {
        [self.view addSubview:fadeView];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([self.view.subviews containsObject:fadeView])
        [fadeView removeFromSuperview];
    return YES;
}

- (void)textFieldDidChange
{
    emptySearchLabel.hidden = YES;
    
    if (![searchField.text isEqualToString:@""])
    {
        if ([self.view.subviews containsObject:fadeView])
            [fadeView removeFromSuperview];
        clearButton.hidden = NO;
        
        NSMutableArray *insertIndexPathsArray = [NSMutableArray array];
        NSMutableArray *deleteIndexPathsArray = [NSMutableArray array];
        NSMutableIndexSet *deleteIndexSet = [NSMutableIndexSet indexSet];
        NSMutableIndexSet *insertIndexSet = [NSMutableIndexSet indexSet];
        
        int sectionNumber = 0;
        
        if ([searchTableDictionary objectForKey:@"last"] != [NSNull null])
        {
            NSMutableArray *currentArray;
            if ([tableDictionary objectForKey:@"last"] != [NSNull null])
                currentArray = [NSMutableArray arrayWithArray:[tableDictionary objectForKey:@"last"]];
            else
                currentArray = [NSMutableArray array];
                
            NSMutableArray *fullArray = [NSMutableArray arrayWithArray:[searchTableDictionary objectForKey:@"last"]];
            
            for (PFObject *object in fullArray)
            {
                NSString *address = [object valueForKey:@"small_adress"];
                NSRange addressResultsRange = [address rangeOfString:searchField.text options:NSCaseInsensitiveSearch];
                
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
                [tableDictionary setObject:[NSNull null] forKey:@"last"];
            }
            else
            {
                if ([tableDictionary objectForKey:@"last"] != [NSNull null])
                    [insertIndexSet addIndex:sectionNumber];
                [tableDictionary setObject:currentArray forKey:@"last"];
            }
            sectionNumber ++;
        }
        
        if ([searchTableDictionary objectForKey:@"one"] != [NSNull null])
        {
            NSMutableArray *currentArray;
            if ([tableDictionary objectForKey:@"one"] != [NSNull null])
                currentArray = [NSMutableArray arrayWithArray:[tableDictionary objectForKey:@"one"]];
            else
                currentArray = [NSMutableArray array];
            
            NSMutableArray *fullArray = [NSMutableArray arrayWithArray:[searchTableDictionary objectForKey:@"one"]];
            
            for (PFObject *object in fullArray)
            {
                NSString *address = [object valueForKey:@"small_adress"];
                NSRange addressResultsRange = [address rangeOfString:searchField.text options:NSCaseInsensitiveSearch];
                
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
                [tableDictionary setObject:[NSNull null] forKey:@"one"];
            }
            else
            {
                if ([tableDictionary objectForKey:@"one"] != [NSNull null])
                    [insertIndexSet addIndex:sectionNumber];
                [tableDictionary setObject:currentArray forKey:@"one"];
            }
            sectionNumber ++;
        }
        
        if ([searchTableDictionary objectForKey:@"three"] != [NSNull null])
        {
            NSMutableArray *currentArray;
            if ([tableDictionary objectForKey:@"three"] != [NSNull null])
                currentArray = [NSMutableArray arrayWithArray:[tableDictionary objectForKey:@"three"]];
            else
                currentArray = [NSMutableArray array];
            
            NSMutableArray *fullArray = [NSMutableArray arrayWithArray:[searchTableDictionary objectForKey:@"three"]];
            
            for (PFObject *object in fullArray)
            {
                NSString *address = [object valueForKey:@"small_adress"];
                NSRange addressResultsRange = [address rangeOfString:searchField.text options:NSCaseInsensitiveSearch];
                
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
                [tableDictionary setObject:[NSNull null] forKey:@"three"];
            }
            else
            {
                if ([tableDictionary objectForKey:@"three"] != [NSNull null])
                    [insertIndexSet addIndex:sectionNumber];
                [tableDictionary setObject:currentArray forKey:@"three"];
            }
            sectionNumber ++;
        }
        
        if ([searchTableDictionary objectForKey:@"five"] != [NSNull null])
        {
            NSMutableArray *currentArray;
            if ([tableDictionary objectForKey:@"five"] != [NSNull null])
                currentArray = [NSMutableArray arrayWithArray:[tableDictionary objectForKey:@"five"]];
            else
                currentArray = [NSMutableArray array];
            
            NSMutableArray *fullArray = [NSMutableArray arrayWithArray:[searchTableDictionary objectForKey:@"five"]];
            
            for (PFObject *object in fullArray)
            {
                NSString *address = [object valueForKey:@"small_adress"];
                NSRange addressResultsRange = [address rangeOfString:searchField.text options:NSCaseInsensitiveSearch];
                
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
                [tableDictionary setObject:[NSNull null] forKey:@"five"];
            }
            else
            {
                if ([tableDictionary objectForKey:@"five"] != [NSNull null])
                    [insertIndexSet addIndex:sectionNumber];
                [tableDictionary setObject:currentArray forKey:@"five"];
            }
            sectionNumber ++;
        }
        
        if ([searchTableDictionary objectForKey:@"ten"] != [NSNull null])
        {
            NSMutableArray *currentArray;
            if ([tableDictionary objectForKey:@"ten"] != [NSNull null])
                currentArray = [NSMutableArray arrayWithArray:[tableDictionary objectForKey:@"ten"]];
            else
                currentArray = [NSMutableArray array];
            
            NSMutableArray *fullArray = [NSMutableArray arrayWithArray:[searchTableDictionary objectForKey:@"ten"]];
            
            for (PFObject *object in fullArray)
            {
                NSString *address = [object valueForKey:@"small_adress"];
                NSRange addressResultsRange = [address rangeOfString:searchField.text options:NSCaseInsensitiveSearch];
                
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
                [tableDictionary setObject:[NSNull null] forKey:@"ten"];
            }
            else
            {
                if ([tableDictionary objectForKey:@"ten"] != [NSNull null])
                    [insertIndexSet addIndex:sectionNumber];
                [tableDictionary setObject:currentArray forKey:@"ten"];
            }
            sectionNumber ++;
        }
        
        if ([searchTableDictionary objectForKey:@"fifteen"] != [NSNull null])
        {
            NSMutableArray *currentArray;
            if ([tableDictionary objectForKey:@"fifteen"] != [NSNull null])
                currentArray = [NSMutableArray arrayWithArray:[tableDictionary objectForKey:@"fifteen"]];
            else
                currentArray = [NSMutableArray array];
            
            NSMutableArray *fullArray = [NSMutableArray arrayWithArray:[searchTableDictionary objectForKey:@"fifteen"]];
            
            for (PFObject *object in fullArray)
            {
                NSString *address = [object valueForKey:@"small_adress"];
                NSRange addressResultsRange = [address rangeOfString:searchField.text options:NSCaseInsensitiveSearch];
                
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
                [tableDictionary setObject:[NSNull null] forKey:@"fifteen"];
            }
            else
            {
                if ([tableDictionary objectForKey:@"fifteen"] != [NSNull null])
                    [insertIndexSet addIndex:sectionNumber];
                [tableDictionary setObject:currentArray forKey:@"fifteen"];
            }
            sectionNumber ++;
        }
        
        if ([searchTableDictionary objectForKey:@"other"] != [NSNull null])
        {
            NSMutableArray *currentArray;
            if ([tableDictionary objectForKey:@"other"] != [NSNull null])
                currentArray = [NSMutableArray arrayWithArray:[tableDictionary objectForKey:@"other"]];
            else
                currentArray = [NSMutableArray array];
            
            NSMutableArray *fullArray = [NSMutableArray arrayWithArray:[searchTableDictionary objectForKey:@"other"]];
            
            for (PFObject *object in fullArray)
            {
                NSString *address = [object valueForKey:@"small_adress"];
                NSRange addressResultsRange = [address rangeOfString:searchField.text options:NSCaseInsensitiveSearch];
                
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
                [tableDictionary setObject:[NSNull null] forKey:@"other"];
            }
            else
            {
                if ([tableDictionary objectForKey:@"other"] != [NSNull null])
                    [insertIndexSet addIndex:sectionNumber];
                [tableDictionary setObject:currentArray forKey:@"other"];
            }
        }
       // [stationsTable beginUpdates];
        //[stationsTable deleteRowsAtIndexPaths:deleteIndexPathsArray withRowAnimation:UITableViewRowAnimationNone];
        //[stationsTable deleteSections:deleteIndexSet withRowAnimation:UITableViewRowAnimationNone];
        //[stationsTable insertSections:insertIndexSet withRowAnimation:UITableViewRowAnimationNone];
        //[stationsTable insertRowsAtIndexPaths:insertIndexPathsArray withRowAnimation:UITableViewRowAnimationNone];
        //[stationsTable endUpdates];
        if ([tableDictionary objectForKey:@"last"] != [NSNull null] || [tableDictionary objectForKey:@"one"] != [NSNull null] || [tableDictionary objectForKey:@"three"] != [NSNull null] || [tableDictionary objectForKey:@"five"] != [NSNull null] || [tableDictionary objectForKey:@"ten"] != [NSNull null] || [tableDictionary objectForKey:@"fifteen"] != [NSNull null] || [tableDictionary objectForKey:@"other"] != [NSNull null])
            emptySearchLabel.hidden = YES;
        else
            emptySearchLabel.hidden = NO;
        
        [self reloadData];
    }
    else
    {
        if (![self.view.subviews containsObject:fadeView])
            [self.view addSubview:fadeView];
        clearButton.hidden = YES;
       
        if (![searchTableDictionary isEqualToDictionary:tableDictionary])
        {
            [tableDictionary removeAllObjects];
            [tableDictionary setDictionary:searchTableDictionary];
            [self reloadData];
        }
    }
}

#pragma mark TableView

- (void)reloadData
{
    emptySearchLabel.hidden = YES;
    [stationsTable reloadData];
    NSMutableDictionary *tempDictionary = [[[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNull null], @"last",
                                            [NSNull null], @"one",
                                            [NSNull null], @"three",
                                            [NSNull null], @"five",
                                            [NSNull null], @"ten",
                                            [NSNull null], @"fifteen",
                                            [NSNull null], @"other",
                                            nil] autorelease];
    
    if ([tableDictionary isEqual:tempDictionary])
        emptySearchLabel.hidden = NO;
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
            if ([tableDictionary objectForKey:@"last"] != [NSNull null])
                return ((NSArray *)[tableDictionary objectForKey:@"last"]).count;
            else
                return 0;
            
        case 1:
            if ([tableDictionary objectForKey:@"one"] != [NSNull null])
                return ((NSArray *)[tableDictionary objectForKey:@"one"]).count;
            else 
                return 0;
            
        case 2:
            if ([tableDictionary objectForKey:@"three"] != [NSNull null])
                return ((NSArray *)[tableDictionary objectForKey:@"three"]).count;
            else 
                return 0;
            
        case 3:
            if ([tableDictionary objectForKey:@"five"] != [NSNull null])
                return ((NSArray *)[tableDictionary objectForKey:@"five"]).count;
            else  
                return 0;
            
        case 4:
            if ([tableDictionary objectForKey:@"ten"] != [NSNull null])
                return ((NSArray *)[tableDictionary objectForKey:@"ten"]).count;
            else 
                return 0;
            
        case 5:
            if ([tableDictionary objectForKey:@"fifteen"] != [NSNull null])
                return ((NSArray *)[tableDictionary objectForKey:@"fifteen"]).count;
            else
                return 0;
            
        case 6:
            if ([tableDictionary objectForKey:@"other"] != [NSNull null])
                return ((NSArray *)[tableDictionary objectForKey:@"other"]).count;
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
        object = (PFObject *)[(NSArray *)[tableDictionary objectForKey:@"last"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 1)
        object = (PFObject *)[(NSArray *)[tableDictionary objectForKey:@"one"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 2)
        object = (PFObject *)[(NSArray *)[tableDictionary objectForKey:@"three"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 3)
        object = (PFObject *)[(NSArray *)[tableDictionary objectForKey:@"five"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 4)
        object = (PFObject *)[(NSArray *)[tableDictionary objectForKey:@"ten"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 5)
        object = (PFObject *)[(NSArray *)[tableDictionary objectForKey:@"fifteen"] objectAtIndex:indexPath.row];
    else
        object = (PFObject *)[(NSArray *)[tableDictionary objectForKey:@"other"] objectAtIndex:indexPath.row];
    
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
    
    
    if (![searchField.text isEqualToString:@""])
    {
        cell.addressLabel.hidden = YES;
        NSString *address = [object valueForKey:@"small_adress"];
        NSRange addressRange = [address rangeOfString:searchField.text options:NSCaseInsensitiveSearch];
        
        NSString *outString = [address stringByReplacingOccurrencesOfString:[address substringWithRange:addressRange] withString:[NSString stringWithFormat:@"<search>%@</search>", [address substringWithRange:addressRange]]];
        FTCoreTextView *coreTextView = [[FTCoreTextView alloc] initWithFrame:cell.addressLabel.frame];
        coreTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [cell addSubview:coreTextView];
        [coreTextView addStyles:coreTextStyle];
        [coreTextView setText:outString];
        [coreTextView fitToSuggestedHeight];
    }
    else
    {
        cell.addressLabel.hidden = NO;
        cell.addressLabel.text = [object valueForKey:@"small_adress"];
    }
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 2 && [[viewControllers objectAtIndex:viewControllers.count - 2] isKindOfClass:[EventPlanningViewController class]])
    {
        cell.indicatorView.hidden = YES;
        cell.isEvent = YES;
    }
    else
        cell.isEvent = NO;
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StationsCell *cell = (StationsCell *)[tableView cellForRowAtIndexPath:indexPath];
    //cell.shadowSelectionView.alpha = 0.05f;
    //cell.addressLabel.textColor = [UIColor colorWithRed:215.0f/255.0f green:54.0f/255.0f blue:30.0f/255.0f alpha:1];
    
    PFObject *object;
    
    if (indexPath.section == 0)
        object = (PFObject *)[(NSArray *)[tableDictionary objectForKey:@"last"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 1)
        object = (PFObject *)[(NSArray *)[tableDictionary objectForKey:@"one"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 2)
        object = (PFObject *)[(NSArray *)[tableDictionary objectForKey:@"three"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 3)
        object = (PFObject *)[(NSArray *)[tableDictionary objectForKey:@"five"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 4)
        object = (PFObject *)[(NSArray *)[tableDictionary objectForKey:@"ten"] objectAtIndex:indexPath.row];
    else if (indexPath.section == 5)
        object = (PFObject *)[(NSArray *)[tableDictionary objectForKey:@"fifteen"] objectAtIndex:indexPath.row];
    else
        object = (PFObject *)[(NSArray *)[tableDictionary objectForKey:@"other"] objectAtIndex:indexPath.row];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 2 && [[viewControllers objectAtIndex:viewControllers.count - 2] isKindOfClass:[EventPlanningViewController class]])
    {
        objectForEvent = object;
        cell.indicatorView.hidden = NO;
        cell.indicatorView.image = [UIImage imageNamed:@"check"];
        /*[Common getInstance].eventStationAddress = [object valueForKey:@"small_adress"];
        
        BOOL isInLastStations = NO;
        for (int i = 0; [Common getInstance].lastStations.count > i; i++)
        {
            if ([[object valueForKey:@"objectId"] isEqual:[[Common getInstance].lastStations objectAtIndex:i]])
                isInLastStations = YES;
        }
        if (!isInLastStations)
            [Common getInstance].lastStations = [NSArray arrayWithObject:[object valueForKey:@"objectId"]]; */

        
        //[self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        StationDescriptionViewController *controller = [[[StationDescriptionViewController alloc] initWithNibName:@"StationDescriptionViewController" bundle:nil station:object] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
        [self searchCancelPressed:nil];
    }
    
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StationsCell *cell = (StationsCell *)[tableView cellForRowAtIndexPath:indexPath];
    //cell.shadowSelectionView.alpha = 0.0f;
    //cell.addressLabel.textColor = [UIColor colorWithRed:100.0f/255.0f green:91.0f/255.0f blue:84.0f/255.0f alpha:1];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 2 && [[viewControllers objectAtIndex:viewControllers.count - 2] isKindOfClass:[EventPlanningViewController class]])
        cell.indicatorView.hidden = YES;
    return indexPath;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 307, 32)] autorelease];
    
    UIImageView *background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contraindicationsSectionBackground"]] autorelease];
    UILabel *sectionText = [[[UILabel alloc] initWithFrame:CGRectMake(0, 7, 320, 14)] autorelease];
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
            if ([tableDictionary objectForKey:@"last"] != [NSNull null])
                return 32;
            else
                return 0;
            
        case 1:
            if ([tableDictionary objectForKey:@"one"] != [NSNull null])
                return 32;
            else
                return 0;
            
        case 2:
            if ([tableDictionary objectForKey:@"three"] != [NSNull null])
                return 32;
            else
                return 0;
            
        case 3:
            if ([tableDictionary objectForKey:@"five"] != [NSNull null])
                return 32;
            else
                return 0;
            
        case 4:
            if ([tableDictionary objectForKey:@"ten"] != [NSNull null])
                return 32;
            else
                return 0;
            
        case 5:
            if ([tableDictionary objectForKey:@"fifteen"] != [NSNull null])
                return 32;
            else
                return 0;
            
        case 6:
            if ([tableDictionary objectForKey:@"other"] != [NSNull null])
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
    if (!isShowOneStation)
    {
        NSMutableArray *mapArray = [NSMutableArray array];
        if ([tableDictionary objectForKey:@"last"] != [NSNull null])
            [mapArray addObjectsFromArray:[tableDictionary objectForKey:@"last"]];
        if ([tableDictionary objectForKey:@"one"] != [NSNull null])
            [mapArray addObjectsFromArray:[tableDictionary objectForKey:@"one"]];
        if ([tableDictionary objectForKey:@"three"] != [NSNull null])
            [mapArray addObjectsFromArray:[tableDictionary objectForKey:@"three"]];
        if ([tableDictionary objectForKey:@"five"] != [NSNull null])
            [mapArray addObjectsFromArray:[tableDictionary objectForKey:@"five"]];
        if ([tableDictionary objectForKey:@"ten"] != [NSNull null])
            [mapArray addObjectsFromArray:[tableDictionary objectForKey:@"ten"]];
        if ([tableDictionary objectForKey:@"fifteen"] != [NSNull null])
            [mapArray addObjectsFromArray:[tableDictionary objectForKey:@"fifteen"]];
        if ([tableDictionary objectForKey:@"other"] != [NSNull null])
            [mapArray addObjectsFromArray:[tableDictionary objectForKey:@"other"]];
        
        PFObject *object = (PFObject *)[mapArray objectAtIndex:((StationsAnnotation *)view.annotation).tag];
        
        StationDescriptionViewController *controller = [[[StationDescriptionViewController alloc] initWithNibName:@"StationDescriptionViewController" bundle:nil station:object] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation
{
    MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"stationLoation"] autorelease];
    
    if (annotation == stationsMap.userLocation)
    {
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userLocation"]] autorelease];
        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(-5, 5);
        [annotationView addSubview:imageView];
    }
    else
    {
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapAnnotationIcon"]] autorelease];
        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
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
    if (isShowOneStation)
    {
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        PFGeoPoint *stationPoint = [selectedStationToShowOnMap objectForKey:@"latlon"];
        CLLocation *location = [[[CLLocation alloc] initWithLatitude:stationPoint.latitude longitude:stationPoint.longitude] autorelease];
        
        StationsAnnotation *annotation = [StationsAnnotation new];
        annotation.coordinate = location.coordinate;
        annotation.title = [selectedStationToShowOnMap objectForKey:@"small_adress"];
        [stationsMap addAnnotation:annotation];
        [annotation release];
        
        region.center = annotation.coordinate;
        
        span.latitudeDelta = 0.5;
        span.longitudeDelta = 0.5;
        region.span = span;
        [stationsMap setRegion:region animated:TRUE];
        [stationsMap regionThatFits:region];
    }
    else
    {
        [stationsMap removeAnnotations:[stationsMap.annotations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"!(self isKindOfClass: %@)", [MKUserLocation class]]]];
        NSMutableArray *mapArray = [NSMutableArray array];
        if ([tableDictionary objectForKey:@"last"] != [NSNull null])
            [mapArray addObjectsFromArray:[tableDictionary objectForKey:@"last"]];
        if ([tableDictionary objectForKey:@"one"] != [NSNull null])
            [mapArray addObjectsFromArray:[tableDictionary objectForKey:@"one"]];
        if ([tableDictionary objectForKey:@"three"] != [NSNull null])
            [mapArray addObjectsFromArray:[tableDictionary objectForKey:@"three"]];
        if ([tableDictionary objectForKey:@"five"] != [NSNull null])
            [mapArray addObjectsFromArray:[tableDictionary objectForKey:@"five"]];
        if ([tableDictionary objectForKey:@"ten"] != [NSNull null])
            [mapArray addObjectsFromArray:[tableDictionary objectForKey:@"ten"]];
        if ([tableDictionary objectForKey:@"fifteen"] != [NSNull null])
            [mapArray addObjectsFromArray:[tableDictionary objectForKey:@"fifteen"]];
        if ([tableDictionary objectForKey:@"other"] != [NSNull null])
            [mapArray addObjectsFromArray:[tableDictionary objectForKey:@"other"]];
        
        for (int i = 0; mapArray.count > i; i++)
        {
            //MKCoordinateRegion region;
            //MKCoordinateSpan span;
            PFGeoPoint *stationPoint = [[mapArray objectAtIndex:i] objectForKey:@"latlon"];
            CLLocation *location = [[[CLLocation alloc] initWithLatitude:stationPoint.latitude longitude:stationPoint.longitude] autorelease];
            
            StationsAnnotation *annotation = [StationsAnnotation new];
            annotation.coordinate = location.coordinate;
            
            annotation.tag = i;
            annotation.title = [[mapArray objectAtIndex:i] objectForKey:@"small_adress"];
            
            [stationsMap addAnnotation:annotation];
            [annotation release];
            
            /*if (i == 0)
                region.center = annotation.coordinate;
            
            span.latitudeDelta = 0.5;
            span.longitudeDelta = 0.5;
            region.span=span;
            [stationsMap setRegion:region animated:TRUE];
            [stationsMap regionThatFits:region];*/
        }
       
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        region.center = stationsMap.userLocation.coordinate;
        region.span = MKCoordinateSpanMake(0.1, 0.1);
        span.latitudeDelta = 0.5;
        span.longitudeDelta = 0.5;
        region.span=span;
        [stationsMap setRegion:region animated:TRUE];
        [stationsMap regionThatFits:region];
    }
}

- (void)locationUpdate:(CLLocation *)location
{
    [coreLocationController.locationManager stopUpdatingHeading];
    [coreLocationController.locationManager stopUpdatingLocation];
	[currentLocation  initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
   
    if (!isShowOneStation)
    {
        PFQuery *stations = [PFQuery queryWithClassName:@"Stations"];
        [stations findObjectsInBackgroundWithTarget:self selector:@selector(callbackWithResult: error:)];
        [contentView addSubview:indicatorView];
    }
    else
    {
        if (self.navigationController.isBeingPresented)
            [self reloadMapAnnotations];
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
        tableDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNull null], @"last",
                           [NSNull null], @"one",
                           [NSNull null], @"three",
                           [NSNull null], @"five",
                           [NSNull null], @"ten",
                           [NSNull null], @"fifteen",
                           [NSNull null], @"other",
                           nil];
        
        searchTableDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNull null], @"last",
                                 [NSNull null], @"one",
                                 [NSNull null], @"three",
                                 [NSNull null], @"five",
                                 [NSNull null], @"ten",
                                 [NSNull null], @"fifteen",
                                 [NSNull null], @"other",
                                 nil];
        
        stationsArrayList = [NSMutableArray new];
        
        currentLocation = [[CLLocation alloc] init];
        coreLocationController = [[CoreLocationController alloc] init];
        [coreLocationController setDelegate:self];

    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)station
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        selectedStationToShowOnMap = station;
        
        tableDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNull null], @"last",
                           [NSNull null], @"one",
                           [NSNull null], @"three",
                           [NSNull null], @"five",
                           [NSNull null], @"ten",
                           [NSNull null], @"fifteen",
                           [NSNull null], @"other",
                           nil];
        
        searchTableDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNull null], @"last",
                                 [NSNull null], @"one",
                                 [NSNull null], @"three",
                                 [NSNull null], @"five",
                                 [NSNull null], @"ten",
                                 [NSNull null], @"fifteen",
                                 [NSNull null], @"other",
                                 nil];
        
        stationsArrayList = [NSMutableArray new];
        
        currentLocation = [[CLLocation alloc] init];
        coreLocationController = [[CoreLocationController alloc] init];
        [coreLocationController setDelegate:self];
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
    
    coreTextStyle = [[NSArray alloc] initWithObjects:defaultStyle, searchStyle, nil];
    
    fadeView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, searchView.frame.origin.y + searchView.frame.size.height, 320.0f, 480)];
    fadeView.backgroundColor = [UIColor blackColor];
    fadeView.alpha = 0.7f;
    
    self.title = @"Станции";
    
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                         action:nil] autorelease];
    
    [searchContainerView addSubview:barView];
    
    [searchField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    stationsMap.showsUserLocation = YES;
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    if (viewControllers.count > 1)
    {
        backButton.hidden = NO;
        if (viewControllers.count > 2 && [[viewControllers objectAtIndex:viewControllers.count - 2] isKindOfClass:[EventPlanningViewController class]])
        {
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
            [doneButton setTitle:@"Готово" forState:UIControlStateNormal];
            [doneButton setTitle:@"Готово" forState:UIControlStateHighlighted];
            doneButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
            doneButton.frame = doneButtonFrame;
            [doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *doneBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:doneButton] autorelease];
            [doneBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
            self.navigationItem.rightBarButtonItem = doneBarButtonItem;
           
            isShowOneStation = NO;
            [coreLocationController.locationManager startUpdatingLocation];
            [contentView addSubview:stationsTableView];
            mapButton.enabled = NO;
            [contentView addSubview:stationsTableView];
                        
            indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
            indicatorView.backgroundColor = [UIColor blackColor];
            indicatorView.alpha = 0.5f;
            UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
            indicator.frame = CGRectMake(160 - indicator.frame.size.width / 2.0f,
                                         160 - indicator.frame.size.height / 2.0f,
                                         indicator.frame.size.width,
                                         indicator.frame.size.height);
            
            [indicatorView addSubview:indicator];
            [indicator startAnimating];
        }
        else
        {
            isShowOneStation = YES;
            tableButton.enabled = NO;
            mapButton.selected = YES;
            [contentView addSubview:stationsMapView];
            filterButton.enabled = NO;
            searchField.enabled = NO;
        }
    }
    else
    {
        isShowOneStation = NO;
        [contentView addSubview:stationsTableView];
        [coreLocationController.locationManager startUpdatingLocation];
        indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        indicatorView.backgroundColor = [UIColor blackColor];
        indicatorView.alpha = 0.5f;
        UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        indicator.frame = CGRectMake(160 - indicator.frame.size.width / 2.0f,
                                     160 - indicator.frame.size.height / 2.0f,
                                     indicator.frame.size.width,
                                     indicator.frame.size.height);
        
        [indicatorView addSubview:indicator];
        [indicator startAnimating];
    }
    [self reloadMapAnnotations];
}

- (void)callbackWithResult:(NSArray *)result error:(NSError *)error
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
        
        [stationsArrayList removeAllObjects];
        [stationsArrayList addObjectsFromArray:result];
                
        for (int i = 0; stationsArrayList.count > i; i++)
        {
            if ([Common getInstance].isMoscow && ![[(PFObject *)[stationsArrayList objectAtIndex:i] valueForKey:@"city"] isEqualToString:@"Москва"])
            {
                
                [stationsArrayList removeObjectAtIndex:i];
                i--;
            }
            else if ([Common getInstance].isPeterburg && ![[(PFObject *)[stationsArrayList objectAtIndex:i] valueForKey:@"city"] isEqualToString:@"Санкт-Петербург"])
            {
                [stationsArrayList removeObjectAtIndex:i];
                i--;
            }
            
            else if ([Common getInstance].isRegionalRegistration && ![[(PFObject *)[stationsArrayList objectAtIndex:i] valueForKey:@"regionalRegistration"] boolValue])
            {
                [stationsArrayList removeObjectAtIndex:i];
                i--;
            }
            
            else if ([Common getInstance].isWorkAtSaturday && ![[(PFObject *)[stationsArrayList objectAtIndex:i] valueForKey:@"saturdayWork"] boolValue])
            {
                [stationsArrayList removeObjectAtIndex:i];
                i--;
            }
            
            else if ([Common getInstance].isDonorsForChildren && ![[(PFObject *)[stationsArrayList objectAtIndex:i] valueForKey:@"donorsForChildrens"] boolValue])
            {
                [stationsArrayList removeObjectAtIndex:i];
                i--;
            }
        }
        
        if ([Common getInstance].lastStations.count != 0)
        {
            NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:stationsArrayList] autorelease];
            int deleteIndex = 0;
            for (int i = 0; i < stationsArrayList.count; i++)
            {
                for (int j = 0; [Common getInstance].lastStations.count > j; j++)
                {
                    if ([[[stationsArrayList objectAtIndex:i] valueForKey:@"objectId"] isEqualToString:[[Common getInstance].lastStations objectAtIndex:j]])
                    {
                        [lastStations addObject:[stationsArrayList objectAtIndex:i]];
                        [tempArray removeObjectAtIndex:(i - deleteIndex)];
                        deleteIndex ++;
                    }
                }
            }
            [stationsArrayList removeAllObjects];
            [stationsArrayList addObjectsFromArray:tempArray];
        }
        
        for (int i = 0; stationsArrayList.count > i; i++)
        {
            PFGeoPoint *stationPoint = [[stationsArrayList objectAtIndex:i] objectForKey:@"latlon"];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:stationPoint.latitude longitude:stationPoint.longitude];
                
            double distance = [currentLocation distanceFromLocation:location]/1000.0f; 
               
            if (distance <= 1.0f)
                [oneKmStationsArray addObject:[stationsArrayList objectAtIndex:i]];
            else if (distance > 1.0f && distance <= 3.0f)
                [threeKmStationsArray addObject:[stationsArrayList objectAtIndex:i]];
            else if (distance > 3.0f && distance <= 5.0f)
                [fiveKmStationsArray addObject:[stationsArrayList objectAtIndex:i]];
            else if (distance > 5.0f && distance <= 10.0f)
                [tenKmStationsArray addObject:[stationsArrayList objectAtIndex:i]];
            else if (distance > 10.0f && distance <= 15.0f)
                [fifteenKmStationsArray addObject:[stationsArrayList objectAtIndex:i]];
            else
                [otherStationsArray addObject:[stationsArrayList objectAtIndex:i]];
        }
        
        if (lastStations.count > 0)
            [tableDictionary setObject:lastStations forKey:@"last"];
        else
            [tableDictionary setObject:[NSNull null] forKey:@"last"];
        if (oneKmStationsArray.count > 0)
            [tableDictionary setObject:oneKmStationsArray forKey:@"one"];
        else
            [tableDictionary setObject:[NSNull null] forKey:@"one"];
        if (threeKmStationsArray.count > 0)
            [tableDictionary setObject:threeKmStationsArray forKey:@"three"];
        else
            [tableDictionary setObject:[NSNull null] forKey:@"three"];
        if (fiveKmStationsArray.count > 0)
            [tableDictionary setObject:fiveKmStationsArray forKey:@"five"];
        else
            [tableDictionary setObject:[NSNull null] forKey:@"five"];
        if (tenKmStationsArray.count > 0)
            [tableDictionary setObject:tenKmStationsArray forKey:@"ten"];
        else
            [tableDictionary setObject:[NSNull null] forKey:@"ten"];
        if (fifteenKmStationsArray.count > 0)
            [tableDictionary setObject:fifteenKmStationsArray forKey:@"fifteen"];
        else
            [tableDictionary setObject:[NSNull null] forKey:@"fifteen"];
        if (otherStationsArray.count > 0)
            [tableDictionary setObject:otherStationsArray forKey:@"other"];
        else
            [tableDictionary setObject:[NSNull null] forKey:@"other"];
        
        [searchTableDictionary removeAllObjects];
        [searchTableDictionary setDictionary:tableDictionary];
    }
    
    [indicatorView removeFromSuperview];
    [self reloadData];
    [self reloadMapAnnotations];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [coreLocationController.locationManager startUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [coreTextStyle release];
    [stationsArrayList release];
    [tableDictionary release];
    [searchTableDictionary release];
    [indicatorView release];
    [fadeView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
