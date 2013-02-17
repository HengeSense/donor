//
//  StationsViewController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 13.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CoreLocationController.h"
#import <Parse/Parse.h>
#import "FTCoreTextView.h"

@interface StationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MKMapViewDelegate, MKAnnotation, FTCoreTextViewDelegate>

/// @name UI properties
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UIButton *backButton;

@property (nonatomic, weak) IBOutlet UIButton *tableButton;
@property (nonatomic, weak) IBOutlet UIButton *mapButton;
@property (nonatomic, weak) IBOutlet UIButton *filterButton;

@property (nonatomic, strong) IBOutlet UIView *searchContainerView;
@property (nonatomic, strong) IBOutlet UIView *barView;
@property (nonatomic, strong) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet UIButton *clearButton;

@property (nonatomic, weak) IBOutlet UITextField *searchField;

@property (nonatomic, strong) IBOutlet UIView *stationsTableView;
@property (nonatomic, weak) IBOutlet UILabel *emptySearchLabel;
@property (nonatomic, strong) IBOutlet UIView *stationsMapView;

@property (nonatomic, weak) IBOutlet MKMapView *stationsMap;
@property (nonatomic, weak) IBOutlet UITableView *stationsTable;

/// @name Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)station;

/// @name UI Action
- (IBAction)switchView:(id)sender;
- (IBAction)searchPressed:(id)sender;
- (IBAction)searchCancelPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;

- (IBAction)backButtonPressed:(id)sender;

/// @name Functionality
- (void)reloadMapAnnotations;

@end
