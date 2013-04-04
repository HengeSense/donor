//
//  HSStationsViewController.h
//  Donor
//
//  Created by Eugine Korobovsky on 03.04.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSStationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UITableView *stationsTable;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;



@end
