//
//  HSStationsSelectCityViewController.m
//  Donor
//
//  Created by Eugine Korobovsky on 09.04.13.
//  Updated by Sergey Seroshtan on 25.05.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSStationsSelectCityViewController.h"
#import "StationsDefs.h"

@interface HSStationsSelectCityViewController ()

@property (nonatomic, strong) NSMutableArray *regionsArray;
@property (nonatomic, strong) NSMutableArray *filteredArray;

@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;

@property (nonatomic, strong) NSString *selectedRegion;

@end

@implementation HSStationsSelectCityViewController

#pragma mark - UI Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.regionsArray==nil || [self.regionsArray count]==0) {
        self.regionsArray = [[NSMutableArray alloc] initWithCapacity:4];
        if (self.delegate.regionsDictionary) {
            NSArray *reg = [[[self.delegate.regionsDictionary keyEnumerator] allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                int id1, id2;
                id1 = [(NSNumber *)obj1 integerValue];
                id2 = [(NSNumber *)obj2 integerValue];
                
                if (id1==35) return NSOrderedAscending;
                if (id2==35) return NSOrderedDescending;
                
                if (id1==79&&id1!=35) return NSOrderedAscending;
                if (id2==79&&id2!=35) return NSOrderedDescending;
                
                NSString *obj1_name = [[self.delegate.regionsDictionary objectForKey:obj1] objectForKey:@"region_name"];
                NSString *obj2_name = [[self.delegate.regionsDictionary objectForKey:obj2] objectForKey:@"region_name"];
     
                if (obj1_name && obj2_name) {
                    return [obj1_name localizedCompare:obj2_name];
                }else{
                    return NSOrderedSame;
                }
            }];
            int cnt1 = 0;
            for (id oneRegionId in reg) {
                NSDictionary *curRegion = [self.delegate.regionsDictionary objectForKey:oneRegionId];
                
                NSMutableDictionary *oneRegion = [[NSMutableDictionary alloc] init];
                [oneRegion setObject:[curRegion objectForKey:@"region_name"] forKey:@"name"];
                [oneRegion setObject:oneRegionId forKey:@"region_id"];
                
                [self.regionsArray addObject:oneRegion];
                
                int regId = [oneRegionId integerValue];
                if (self.regionId>=0 && regId==_regionId) self.lastSelectedIndexPath = [NSIndexPath indexPathForRow:cnt1 inSection:0];
                cnt1++;
                if (regId==35 || regId==79) {
                    continue;
                }
                
                for (id oneDistrictId in [[curRegion keyEnumerator] allObjects]) {
                    if ([oneDistrictId isKindOfClass:[NSString class]] && [oneDistrictId isEqualToString:@"region_name"]) continue;
                    
                    if (self.districtId>=0 && [oneDistrictId isKindOfClass:[NSNumber class]] && [oneDistrictId integerValue]==_districtId) {
                        self.lastSelectedIndexPath = [NSIndexPath indexPathForRow:cnt1 inSection:0];
                    }
                    cnt1++;
                    
                    NSMutableDictionary *oneDistrict = [[NSMutableDictionary alloc] init];
                    [oneDistrict setObject:[curRegion objectForKey:oneDistrictId] forKey:@"name"];
                    [oneDistrict setObject:oneDistrictId forKey:@"district_id"];
                    [self.regionsArray addObject:oneDistrict];
                }
            }
        }
    }
    
    [self.cityTable reloadData];
    if (self.lastSelectedIndexPath) {
        [self.cityTable selectRowAtIndexPath:self.lastSelectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

#pragma mark - UI actions
- (IBAction)onPressOk:(id)sender{
    self.delegate.region_id = self.regionId;
    self.delegate.district_id = self.districtId;
    
    [self.delegate requestCurrentRegionAreaWithRegionName:self.selectedRegion];
    [self.delegate saveLastChoice];
    
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)onPressCancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - UITableView routines
- (BOOL)isSearchModeForTable:(UITableView *)tableView{
    return tableView==self.searchDisplayController.searchResultsTableView ? YES : NO;
}

- (NSIndexPath *)indexPathForCurrentlySelectedRegionInMainTable{
    int cnt = 0;
    for (NSDictionary *oneReg in self.regionsArray) {
        if (self.regionId>=0 && [oneReg objectForKey:@"region_id"] && self.regionId==[[oneReg objectForKey:@"region_id"] integerValue]) {
            return [NSIndexPath indexPathForRow:cnt inSection:0];
        }
        if (self.districtId>=0 && [oneReg objectForKey:@"district_id"] && self.regionId==[[oneReg objectForKey:@"district_id"] integerValue]) {
            return [NSIndexPath indexPathForRow:cnt inSection:0];
        }
        cnt++;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self isSearchModeForTable:tableView]) {
        return 1;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self isSearchModeForTable:tableView]) {
        return [self.filteredArray count];
    }else{
        return [self.regionsArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID;
    cellID = @"InvitroOnlineRootHistoryCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UILabel *regionLabel;
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.clipsToBounds = YES;
        cell.selectedBackgroundView.alpha = 1.0;
        cell.selectedBackgroundView.backgroundColor = RGBA_COLOR(0, 0, 0, 0.1);
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 24)];
        regionLabel.tag = 10;
        regionLabel.textColor = [UIColor darkGrayColor];
        regionLabel.highlightedTextColor = DONOR_RED_COLOR;
        regionLabel.backgroundColor = [UIColor clearColor];
        regionLabel.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:regionLabel];
        
        UIImageView *sepatator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DonorStations_tableCellSeparator"]];
        CGRect separatorFrame = sepatator.frame;
        separatorFrame.origin = CGPointMake(12, cell.bounds.size.height-3);
        sepatator.frame = separatorFrame;
        [cell addSubview:sepatator];
    }
    
    regionLabel = (UILabel *)[cell viewWithTag:10];
    
    NSArray *curArray = [self isSearchModeForTable:tableView] ? self.filteredArray : self.regionsArray;
    
    
    NSDictionary *curObj = [curArray objectAtIndex:[indexPath row]];
    BOOL isSelected = NO;
    if ([curObj objectForKey:@"region_id"]) {
        regionLabel.text = [NSString stringWithFormat:@"%@", [curObj objectForKey:@"name"]];
        regionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        isSelected = ([[curObj objectForKey:@"region_id"] integerValue]==_regionId ? YES : NO);
    }else{
        regionLabel.text = [NSString stringWithFormat:@"    %@", [curObj objectForKey:@"name"]];
        regionLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
        isSelected = ([[curObj objectForKey:@"district_id"] integerValue]==_districtId ? YES : NO);
    }
    
    if (isSelected) {
        cell.backgroundColor = RGBA_COLOR(0, 0, 0, 0.1);
    }else{
        cell.backgroundColor = [UIColor clearColor];
    }
        
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *curArray = [self isSearchModeForTable:tableView] ? self.filteredArray : self.regionsArray;
    
    NSDictionary *curObj = [curArray objectAtIndex:[indexPath row]];
    if ([curObj objectForKey:@"region_id"]) {
        self.regionId = [[curObj objectForKey:@"region_id"] integerValue];
        self.districtId = -1;
        self.selectedRegion = [curObj objectForKey:@"name"];
    }else{
        self.regionId = -1;
        self.districtId = [[curObj objectForKey:@"district_id"] integerValue];
        
        int startIndex = [indexPath row];
        while(startIndex>=0 && [[curArray objectAtIndex:startIndex] objectForKey:@"region_id"]==nil) {
            startIndex--;
        }
        if (startIndex>=0 && [[curArray objectAtIndex:startIndex] objectForKey:@"name"]) {
            self.selectedRegion = [NSString stringWithFormat:@"%@, %@ район", [[curArray objectAtIndex:startIndex] objectForKey:@"name"], [curObj objectForKey:@"name"]];
        }else{
            self.selectedRegion = @"";
        }
    }
    
    NSLog(@"Select region: %@", self.selectedRegion);
    
    
    [tableView deselectRowAtIndexPath:self.lastSelectedIndexPath animated:YES];
    self.lastSelectedIndexPath = indexPath;
    [tableView reloadData];
    [tableView selectRowAtIndexPath:self.lastSelectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
        forRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.backgroundColor = [UIColor clearColor];
}


#pragma mark - UISearchDisplayController Delegate Methods

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
    for (UIView *oneView in self.searchDisplayController.searchBar.subviews) {
        if ([oneView isKindOfClass:[UIButton class]]) {
            [(UIButton *)oneView setTitle:@"Отменить" forState:UIControlStateNormal];
        }
    }
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
        shouldReloadTableForSearchString:(NSString *)searchString{
    if (!self.filteredArray) self.filteredArray = [[NSMutableArray alloc] init];
    [self.filteredArray removeAllObjects]; // First clear the filtered array.
	
    BOOL isResults = NO;
	for (NSDictionary *oneRegion in self.regionsArray) {
        NSString *str = [oneRegion objectForKey:@"name"];
        NSRange substringRange = [str rangeOfString:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [str length])];
        if (substringRange.location != NSNotFound) {
            [self.filteredArray addObject:oneRegion];
            isResults = YES;
            continue;
        }
	}
    
    if (!isResults) {
        double delayInSeconds = 0.001;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            for (UIView *oneView in self.searchDisplayController.searchResultsTableView.subviews) {
                if ([oneView isKindOfClass:[UILabel class]]) {
                    [(UILabel *)oneView setText:@"Не найдено"];
                }
            }
        });
    }
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView{
    //CGRect rct = tableView.frame;
    //tableView.frame = CGRectMake(rct.origin.x, rct.origin.y, 240.0, rct.size.height);
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.cityTable.hidden = YES;
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView{
    self.cityTable.hidden = NO;
    
    [self.cityTable deselectRowAtIndexPath:self.lastSelectedIndexPath animated:YES];
    self.lastSelectedIndexPath = [self indexPathForCurrentlySelectedRegionInMainTable];
    [self.cityTable reloadData];
    [self.cityTable selectRowAtIndexPath:self.lastSelectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView{
    
}

#pragma mark - Private
#pragma mark - UI configuration
- (void)configureUI {
    self.title = @"Выбор региона";
    [self configureSearchBar];
    [self configureNavigationBar];
}

- (void)configureSearchBar {
    UIImage *searchBarImage = [UIImage imageNamed:@"DonorStations_searchBarBackground"];
    [self.searchDisplayController.searchBar setBackgroundImage:searchBarImage];
    [self.searchDisplayController.searchBar setImage:[UIImage imageNamed:@"DonorStations_searchBarSearchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchDisplayController.searchBar setImage:[UIImage imageNamed:@"DonorStations_searchBarClearIcon"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    self.searchDisplayController.searchBar.tintColor = DONOR_RED_COLOR;
    
    UIImage *searchFieldImage = [[UIImage imageNamed:@"DonorStations_searchBarFieldBackground"] stretchableImageWithLeftCapWidth:20 topCapHeight:4];
    [self.searchDisplayController.searchBar setSearchFieldBackgroundImage:searchFieldImage forState:UIControlStateNormal];
    for (UIView *oneView in self.searchDisplayController.searchBar.subviews) {
        if ([oneView isKindOfClass:[UITextField class]]) {
            ((UITextField *)oneView).textColor = DONOR_SEARCH_FIELD_TEXT_COLOR;
        }
    }
}

- (void)configureNavigationBar {
    self.navBar.tintColor = DONOR_RED_COLOR;
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarBtn.frame = CGRectMake(0.0, 0.0, 75.0, 30.0);
    [rightBarBtn setBackgroundImage:[UIImage imageNamed:@"barButtonNormal"] forState:UIControlStateNormal];
    [rightBarBtn setBackgroundImage:[UIImage imageNamed:@"barButtonPressed"] forState:UIControlStateHighlighted];
    [rightBarBtn setTitle:@"Готово" forState:UIControlStateNormal];
    [rightBarBtn setTitle:@"Готово" forState:UIControlStateHighlighted];
    rightBarBtn.titleLabel.font = BOLD_FONT_WITH_SIZE(12);
    [rightBarBtn addTarget:self action:@selector(onPressOk:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navBar.topItem.rightBarButtonItem = rightBarButtonItem;
    
    UIButton *leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(0.0, 0.0, 75.0, 30.0);
    [leftBarBtn setBackgroundImage:[UIImage imageNamed:@"barButtonNormal"] forState:UIControlStateNormal];
    [leftBarBtn setBackgroundImage:[UIImage imageNamed:@"barButtonPressed"] forState:UIControlStateHighlighted];
    [leftBarBtn setTitle:@"Отмена" forState:UIControlStateNormal];
    [leftBarBtn setTitle:@"Отмена" forState:UIControlStateHighlighted];
    leftBarBtn.titleLabel.font = BOLD_FONT_WITH_SIZE(12);
    [leftBarBtn addTarget:self action:@selector(onPressCancel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navBar.topItem.leftBarButtonItem = leftBarBtnItem;
}
@end
