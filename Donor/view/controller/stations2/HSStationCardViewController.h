//
//  HSStationCardViewController.h
//  Donor
//
//  Created by Eugine Korobovsky on 09.04.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSStationCardViewController : UIViewController {
    
}

@property (nonatomic, strong) NSDictionary *stationDictionary;

@property (nonatomic) BOOL isShowAllInfoForced;
@property (nonatomic) BOOL isMapButtonInitiallyHidden;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *stationContentView;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *dottedLine1;
@property (nonatomic, strong) IBOutlet UIView *raterView;
@property (nonatomic, strong) IBOutlet UIImageView *dottedLine2;
//@property (nonatomic, strong) IBOutlet UIView *regionArea;
@property (nonatomic, strong) IBOutlet UILabel *regionTitle;
@property (nonatomic, strong) IBOutlet UILabel *regionLabel;
@property (nonatomic, strong) IBOutlet UILabel *districtTitle;
@property (nonatomic, strong) IBOutlet UILabel *districtLabel;
@property (nonatomic, strong) IBOutlet UILabel *townTitle;
@property (nonatomic, strong) IBOutlet UILabel *townLabel;
//@property (nonatomic, strong) IBOutlet UIView *contactsArea;
@property (nonatomic, strong) IBOutlet UILabel *addressTitle;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) IBOutlet UILabel *phoneTitle;
@property (nonatomic, strong) IBOutlet UILabel *phoneLabel;
@property (nonatomic, strong) IBOutlet UIImageView *dottedLine3;
@property (nonatomic, strong) IBOutlet UILabel *workhoursTitle;
@property (nonatomic, strong) IBOutlet UILabel *workhoursLabel;
@property (nonatomic, strong) IBOutlet UIImageView *dottedLine4;
@property (nonatomic, strong) IBOutlet UILabel *citeTitle;
@property (nonatomic, strong) IBOutlet UILabel *citeLabel;
@property (nonatomic, strong) IBOutlet UIButton *goToSiteButton;
@property (nonatomic, strong) IBOutlet UIButton *showOnMapButton;

@end
