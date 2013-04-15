//
//  HSStationsSelectCityViewController.m
//  Donor
//
//  Created by Eugine Korobovsky on 09.04.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSStationsSelectCityViewController.h"
#import "StationsDefs.h"

@interface HSStationsSelectCityViewController ()

@property (nonatomic, strong) NSMutableArray *regionsArray;
@property (nonatomic, strong) NSMutableArray *filteredArray;

@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;

@end

@implementation HSStationsSelectCityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _regionsArray = nil;
        _filteredArray = nil;
        
        _lastSelectedIndexPath = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Выбор региона";
    
    UIImage *searchBarImage = [UIImage imageNamed:@"DonorStations_searchBarBackground"];
    [self.searchDisplayController.searchBar setBackgroundImage:searchBarImage];
    [self.searchDisplayController.searchBar setImage:[UIImage imageNamed:@"DonorStations_searchBarSearchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchDisplayController.searchBar setImage:[UIImage imageNamed:@"DonorStations_searchBarClearIcon"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    self.searchDisplayController.searchBar.tintColor = DONOR_RED_COLOR;
    
    UIImage *searchFieldImage = [[UIImage imageNamed:@"DonorStations_searchBarFieldBackground"] stretchableImageWithLeftCapWidth:20 topCapHeight:4];
    [self.searchDisplayController.searchBar setSearchFieldBackgroundImage:searchFieldImage forState:UIControlStateNormal];
    for(UIView *oneView in self.searchDisplayController.searchBar.subviews){
        if([oneView isKindOfClass:[UITextField class]]){
            ((UITextField *)oneView).textColor = DONOR_SEARCH_FIELD_TEXT_COLOR;
        };
    };
    
    _navBar.tintColor = DONOR_RED_COLOR;
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarBtn.frame = CGRectMake(0.0, 0.0, 75.0, 30.0);
    [rightBarBtn setBackgroundImage:[UIImage imageNamed:@"barButtonNormal"] forState:UIControlStateNormal];
    [rightBarBtn setBackgroundImage:[UIImage imageNamed:@"barButtonPressed"] forState:UIControlStateHighlighted];
    [rightBarBtn setTitle:@"Готово" forState:UIControlStateNormal];
    [rightBarBtn setTitle:@"Готово" forState:UIControlStateHighlighted];
    rightBarBtn.titleLabel.font = BOLD_FONT_WITH_SIZE(12);
    [rightBarBtn addTarget:self action:@selector(onPressOk:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    _navBar.topItem.rightBarButtonItem = rightBarButtonItem;
    
    UIButton *leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(0.0, 0.0, 75.0, 30.0);
    [leftBarBtn setBackgroundImage:[UIImage imageNamed:@"barButtonNormal"] forState:UIControlStateNormal];
    [leftBarBtn setBackgroundImage:[UIImage imageNamed:@"barButtonPressed"] forState:UIControlStateHighlighted];
    [leftBarBtn setTitle:@"Отмена" forState:UIControlStateNormal];
    [leftBarBtn setTitle:@"Отмена" forState:UIControlStateHighlighted];
    leftBarBtn.titleLabel.font = BOLD_FONT_WITH_SIZE(12);
    [leftBarBtn addTarget:self action:@selector(onPressCancel:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    _navBar.topItem.leftBarButtonItem = leftBarBtnItem;
};

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
};

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(_regionsArray==nil || [_regionsArray count]==0){
        _regionsArray = [[NSMutableArray alloc] initWithCapacity:4];
        if(_delegate.regionsDictionary){
            NSArray *reg = [[[_delegate.regionsDictionary keyEnumerator] allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
                int id1, id2;
                id1 = [(NSNumber *)obj1 integerValue];
                id2 = [(NSNumber *)obj2 integerValue];
                
                if(id1==35) return NSOrderedAscending;
                if(id2==35) return NSOrderedDescending;
                
                if(id1==79&&id1!=35) return NSOrderedAscending;
                if(id2==79&&id2!=35) return NSOrderedDescending;
                
                NSString *obj1_name = [[_delegate.regionsDictionary objectForKey:obj1] objectForKey:@"region_name"];
                NSString *obj2_name = [[_delegate.regionsDictionary objectForKey:obj2] objectForKey:@"region_name"];
                
                if(obj1_name && obj2_name){
                    return [obj1_name localizedCompare:obj2_name];
                }else{
                    return NSOrderedSame;
                };
            }];
            int cnt1 = 0;
            for(id oneRegionId in reg){
                NSDictionary *curRegion = [_delegate.regionsDictionary objectForKey:oneRegionId];
                
                NSMutableDictionary *oneRegion = [[NSMutableDictionary alloc] init];
                [oneRegion setObject:[curRegion objectForKey:@"region_name"] forKey:@"name"];
                [oneRegion setObject:oneRegionId forKey:@"region_id"];
                
                [_regionsArray addObject:oneRegion];
                
                int regId = [oneRegionId integerValue];
                if(_regionId>=0 && regId==_regionId) _lastSelectedIndexPath = [NSIndexPath indexPathForRow:cnt1 inSection:0];
                cnt1++;
                if(regId==35 || regId==79){
                    continue;
                };
                
                for(id oneDistrictId in [[curRegion keyEnumerator] allObjects]){
                    if([oneDistrictId isKindOfClass:[NSString class]] && [oneDistrictId isEqualToString:@"region_name"]) continue;
                    
                    if(_districtId>=0 && [oneDistrictId isKindOfClass:[NSNumber class]] && [oneDistrictId integerValue]==_districtId){
                        _lastSelectedIndexPath = [NSIndexPath indexPathForRow:cnt1 inSection:0];
                    };
                    cnt1++;
                    
                    NSMutableDictionary *oneDistrict = [[NSMutableDictionary alloc] init];
                    [oneDistrict setObject:[curRegion objectForKey:oneDistrictId] forKey:@"name"];
                    [oneDistrict setObject:oneDistrictId forKey:@"district_id"];
                    [_regionsArray addObject:oneDistrict];
                };
            };
        };
    };
    
    [_cityTable reloadData];
    if(_lastSelectedIndexPath){
        //NSLog(@"select row at index path: %d %d", [_lastSelectedIndexPath section], [_lastSelectedIndexPath row]);
        [_cityTable selectRowAtIndexPath:_lastSelectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
};

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
};

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
};

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
};

#pragma mark - View routines

- (IBAction)onPressOk:(id)sender{
    _delegate.region_id = _regionId;
    _delegate.district_id = _districtId;
    [_delegate saveLastChoice];
    
    [self dismissModalViewControllerAnimated:YES];
};


- (IBAction)onPressCancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
};


#pragma mark - Table view delegate routines

- (BOOL)isSearchModeForTable:(UITableView *)tableView{
    return tableView==self.searchDisplayController.searchResultsTableView ? YES : NO;
};

- (NSIndexPath *)indexPathForCurrentlySelectedRegionInMainTable{
    int cnt = 0;
    for(NSDictionary *oneReg in _regionsArray){
        if(_regionId>=0 && [oneReg objectForKey:@"region_id"] && _regionId==[[oneReg objectForKey:@"region_id"] integerValue]){
            return [NSIndexPath indexPathForRow:cnt inSection:0];
        };
        if(_districtId>=0 && [oneReg objectForKey:@"district_id"] && _regionId==[[oneReg objectForKey:@"district_id"] integerValue]){
            return [NSIndexPath indexPathForRow:cnt inSection:0];
        };
        cnt++;
    };
    
    return nil;
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([self isSearchModeForTable:tableView]){
        return 1;
    }else{
        return 1;
    };
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self isSearchModeForTable:tableView]){
        return [_filteredArray count];
    }else{
        return [_regionsArray count];
    };
};

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0;
};

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 return 40.0;
 };
 
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 return @"";
 }
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID;
    cellID = @"InvitroOnlineRootHistoryCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UILabel *regionLabel;
    if(cell==nil){
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
    };
    
    regionLabel = (UILabel *)[cell viewWithTag:10];
    
    NSArray *curArray = [self isSearchModeForTable:tableView] ? _filteredArray : _regionsArray;
    
    
    NSDictionary *curObj = [curArray objectAtIndex:[indexPath row]];
    BOOL isSelected = NO;
    if([curObj objectForKey:@"region_id"]){
        regionLabel.text = [NSString stringWithFormat:@"%@", [curObj objectForKey:@"name"]];
        regionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        isSelected = ([[curObj objectForKey:@"region_id"] integerValue]==_regionId ? YES : NO);
    }else{
        regionLabel.text = [NSString stringWithFormat:@"    %@", [curObj objectForKey:@"name"]];
        regionLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
        isSelected = ([[curObj objectForKey:@"district_id"] integerValue]==_districtId ? YES : NO);
    };
    
    if(isSelected){
        cell.backgroundColor = RGBA_COLOR(0, 0, 0, 0.1);
    }else{
        cell.backgroundColor = [UIColor clearColor];
    };
    
    
        
    return cell;
    
};


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *curArray = [self isSearchModeForTable:tableView] ? _filteredArray : _regionsArray;
    
    NSDictionary *curObj = [curArray objectAtIndex:[indexPath row]];
    if([curObj objectForKey:@"region_id"]){
        _regionId = [[curObj objectForKey:@"region_id"] integerValue];
        _districtId = -1;
    }else{
        _regionId = -1;
        _districtId = [[curObj objectForKey:@"district_id"] integerValue];
    };
    
    [tableView deselectRowAtIndexPath:_lastSelectedIndexPath animated:YES];
    _lastSelectedIndexPath = indexPath;
    [tableView reloadData];
    [tableView selectRowAtIndexPath:_lastSelectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
};


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.backgroundColor = [UIColor clearColor];
    
};


#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    if(!_filteredArray) _filteredArray = [[NSMutableArray alloc] init];
    [_filteredArray removeAllObjects]; // First clear the filtered array.
	
	for (NSDictionary *oneRegion in _regionsArray){
        NSString *str = [oneRegion objectForKey:@"name"];
        NSRange substringRange = [str rangeOfString:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [str length])];
        if(substringRange.location != NSNotFound){
            [_filteredArray addObject:oneRegion];
            continue;
        };
	};
    
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
};


- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    
};
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView{
    //CGRect rct = tableView.frame;
    //tableView.frame = CGRectMake(rct.origin.x, rct.origin.y, 240.0, rct.size.height);
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _cityTable.hidden = YES;
};
- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView{
    _cityTable.hidden = NO;
    
    [_cityTable deselectRowAtIndexPath:_lastSelectedIndexPath animated:YES];
    _lastSelectedIndexPath = [self indexPathForCurrentlySelectedRegionInMainTable];
    [_cityTable reloadData];
    [_cityTable selectRowAtIndexPath:_lastSelectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
};
- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView{
    
};


@end
