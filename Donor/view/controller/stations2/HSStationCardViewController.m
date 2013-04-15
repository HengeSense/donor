//
//  HSStationCardViewController.m
//  Donor
//
//  Created by Eugine Korobovsky on 09.04.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSStationCardViewController.h"
#import "HSStationsMapViewController.h"

@interface HSStationCardViewController ()

@end

@implementation HSStationCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isShowAllInfoForced = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Станция";
    
}

- (void)viewWillAppear:(BOOL)animated{
    if(_stationDictionary){
        _nameLabel.text = [_stationDictionary objectForKey:@"name"];
        _regionLabel.text = [_stationDictionary objectForKey:@"region_name"];
        _districtLabel.text = [_stationDictionary objectForKey:@"district_name"];
        _townLabel.text = [_stationDictionary objectForKey:@"town"];
        _addressLabel.text = [_stationDictionary objectForKey:@"shortaddress"] ? [_stationDictionary objectForKey:@"shortaddress"] : [_stationDictionary objectForKey:@"address"];
        _phoneLabel.text = [_stationDictionary objectForKey:@"phone"];
        _workhoursLabel.text = [_stationDictionary objectForKey:@"work_time"];
        _citeLabel.text = [_stationDictionary objectForKey:@"site"];
        
        if(_isShowAllInfoForced==NO){
            int curRegionId = [[_stationDictionary objectForKey:@"region_id"] integerValue];
            BOOL isHideRegionArea = NO;
            if(curRegionId==35 || curRegionId==79){
                isHideRegionArea = YES;
            };
            [_regionArea setHidden:isHideRegionArea];
            CGRect contactsRect = _contactsArea.frame;
            contactsRect.origin.y = _regionArea.frame.origin.y + (isHideRegionArea ? 0 : _regionArea.bounds.size.height + 20);
            _contactsArea.frame = contactsRect;
        };
        
        BOOL isSiteHidden = NO;
        if(![_stationDictionary objectForKey:@"site"] || ![[_stationDictionary objectForKey:@"site"] isKindOfClass:[NSString class]] || [[_stationDictionary objectForKey:@"site"] isEqualToString:@""]){
            isSiteHidden = YES;
        }
        
        [_citeTitle setHidden:isSiteHidden];
        [_citeLabel setHidden:isSiteHidden];
    };
};

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onGoToSitePressed:(id)sender{
    NSString *site = [_stationDictionary objectForKey:@"site"];
    if(site){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:site]];
    };
};

- (IBAction)onShowOnMapPressed:(id)sender{
    HSStationsMapViewController *mapView = [[HSStationsMapViewController alloc] initWithNibName:@"HSStationsMapViewController" bundle:nil];
    mapView.stationsArray = [NSArray arrayWithObject:_stationDictionary];
    [self.navigationController pushViewController:mapView animated:YES];
};

@end
