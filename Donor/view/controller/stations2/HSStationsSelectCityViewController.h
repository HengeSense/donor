//
//  HSStationsSelectCityViewController.h
//  Donor
//
//  Created by Eugine Korobovsky on 09.04.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSStationsViewController.h"

@interface HSStationsSelectCityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate> {
    
}

@property (nonatomic, assign) HSStationsViewController *delegate;
@property (nonatomic, strong) IBOutlet UINavigationBar *navBar;
@property (nonatomic, strong) IBOutlet UITableView *cityTable;

@property (nonatomic) NSInteger regionId;
@property (nonatomic) NSInteger districtId;

@end
