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
{
    IBOutlet UIView *contentView;
    
    IBOutlet UIButton *backButton;
    
    IBOutlet UIButton *tableButton;
    IBOutlet UIButton *mapButton;
    IBOutlet UIButton *filterButton;
    
    IBOutlet UIView *searchContainerView;
    IBOutlet UIView *barView;
    IBOutlet UIView *searchView;
    IBOutlet UIButton *clearButton;
   
    IBOutlet UITextField *searchField;
    
    IBOutlet UIView *stationsTableView;
    IBOutlet UILabel *emptySearchLabel;
    IBOutlet UIView *stationsMapView;
    
    IBOutlet MKMapView *stationsMap;
    IBOutlet UITableView *stationsTable;
    
    UIView *indicatorView;
    UIView *fadeView;
    
    NSMutableDictionary *tableDictionary;
    NSMutableDictionary *searchTableDictionary;
    NSMutableArray *stationsArrayList;
    
    CLLocation *currentLocation;
    
    BOOL isShowOneStation;
    
    PFObject *selectedStationToShowOnMap;
    PFObject *objectForEvent;
    
    NSArray *coreTextStyle;
}

@property (nonatomic, retain) CoreLocationController *coreLocationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)station;

- (IBAction)switchView:(id)sender;
- (IBAction)searchPressed:(id)sender;
- (IBAction)searchCancelPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;

- (IBAction)backButtonPressed:(id)sender;

//- (void)showOnMap:(PFObject *)station;

- (void)callbackWithResult:(NSArray *)result error:(NSError *)error;
- (void)reloadMapAnnotations;

@end
