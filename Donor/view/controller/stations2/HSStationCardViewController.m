//
//  HSStationCardViewController.m
//  Donor
//
//  Created by Eugine Korobovsky on 09.04.13.
//  Updated by Sergey Seroshtan on 24.05.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSStationCardViewController.h"
#import "HSStationsMapViewController.h"

#pragma mark - UI constraints
static const CGFloat kVerticalTab_Label = 10.0f;
static const CGFloat kVerticalTab_ShowOnMapButton = 20.0f;

@interface HSStationCardViewController ()

@property (nonatomic, strong) HSStationInfo *stationInfo;

@end

@implementation HSStationCardViewController

- (id)initWithStationInfo:(HSStationInfo *)stationInfo {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if (self) {
        self.stationInfo = stationInfo;
        self.isShowAllInfoForced = NO;
        self.isMapButtonInitiallyHidden = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Станция";
    
    [self.scrollView addSubview:self.stationContentView];
    self.scrollView.contentSize = self.stationContentView.bounds.size;
}

- (void)setFrameForLabel:(UILabel *)oneLabel atYcoord:(float)y{
    CGSize labelSize = [oneLabel.text sizeWithFont:oneLabel.font
            constrainedToSize:CGSizeMake(oneLabel.bounds.size.width, 100500) lineBreakMode:oneLabel.lineBreakMode];
    CGRect labelFrame = oneLabel.frame;
    labelFrame.origin.y = y;
    labelFrame.size.height = labelSize.height;
    oneLabel.frame = labelFrame;
};

- (void)setFrameForLabel:(UILabel *)oneLabel atYcoordChange:(float *)y{
    [self setFrameForLabel:oneLabel atYcoord:(*y)];
    (*y) += (oneLabel.bounds.size.height+3.0);
};

- (void)setFrameForView:(UIView *)oneView atYcoord:(float)y{
    CGRect viewFrame = oneView.frame;
    viewFrame.origin.y = y;
    oneView.frame = viewFrame;
};

- (void)setFrameForView:(UIView *)oneView atYcoordChange:(float *)y{
    [self setFrameForView:oneView atYcoord:(*y)];
    (*y) += (oneView.bounds.size.height+3.0);
};



- (void)viewWillAppear:(BOOL)animated{
    self.nameLabel.text = self.stationInfo.name;
    self.regionLabel.text = self.stationInfo.region_name;
    self.districtLabel.text = self.stationInfo.district_name;
    self.townLabel.text = self.stationInfo.town;
    self.addressLabel.text = self.stationInfo.address;
    self.phoneLabel.text = self.stationInfo.phone;
    self.workhoursLabel.text = self.stationInfo.work_time;
    self.citeLabel.text = self.stationInfo.site;
    
    float curY = kVerticalTab_Label;
    [self setFrameForLabel:self.nameLabel atYcoordChange:&curY];
    [self setFrameForView:self.dottedLine1 atYcoordChange:&curY];
    curY += kVerticalTab_Label;
    
    BOOL isHideRegionArea = NO;
    if(self.isShowAllInfoForced == NO){
        int curRegionId = [self.stationInfo.region_id integerValue];
        if(curRegionId == 35 || curRegionId == 79){
            isHideRegionArea = YES;
        };
    };
    if(isHideRegionArea == NO){
        [self setFrameForLabel:self.regionTitle atYcoord:curY];
        [self setFrameForLabel:self.regionLabel atYcoordChange:&curY];
        [self setFrameForLabel:self.districtTitle atYcoord:curY];
        [self setFrameForLabel:self.districtLabel atYcoordChange:&curY];
        [self setFrameForLabel:self.townTitle atYcoord:curY];
        [self setFrameForLabel:self.townLabel atYcoordChange:&curY];
        curY += kVerticalTab_Label;
    }
    [self.regionTitle setHidden:isHideRegionArea];
    [self.regionLabel setHidden:isHideRegionArea];
    [self.districtTitle setHidden:isHideRegionArea];
    [self.districtLabel setHidden:isHideRegionArea];
    [self.townTitle setHidden:isHideRegionArea];
    [self.townLabel setHidden:isHideRegionArea];
    
    [self setFrameForLabel:self.addressTitle atYcoord:curY];
    [self setFrameForLabel:self.addressLabel atYcoordChange:&curY];
    [self setFrameForLabel:self.phoneTitle atYcoord:curY];
    [self setFrameForLabel:self.phoneLabel atYcoordChange:&curY];
    curY += kVerticalTab_Label;
    
    [self setFrameForView:self.dottedLine3 atYcoordChange:&curY];
    [self setFrameForLabel:self.workhoursTitle atYcoord:curY];
    [self setFrameForLabel:self.workhoursLabel atYcoordChange:&curY];
    [self setFrameForView:self.dottedLine4 atYcoordChange:&curY];
    
    BOOL isSiteHidden = NO;
    if(!self.stationInfo.site || ![self.stationInfo.site isKindOfClass:[NSString class]] ||
       [self.stationInfo.site isEqualToString:@""]){
        isSiteHidden = YES;
    } else {
        isSiteHidden = NO;
        [self setFrameForLabel:self.citeTitle atYcoord:curY];
        [self setFrameForLabel:self.citeLabel atYcoordChange:&curY];
    }
    [self.citeTitle setHidden:isSiteHidden];
    [self.citeLabel setHidden:isSiteHidden];
    [self.goToSiteButton setHidden:isSiteHidden];
    
    curY += kVerticalTab_ShowOnMapButton;
    [self.showOnMapButton setHidden:self.isMapButtonInitiallyHidden];
    [self setFrameForView:self.showOnMapButton atYcoordChange:&curY];
    curY += kVerticalTab_ShowOnMapButton;

    
    CGRect contentFrame = self.stationContentView.frame;
    contentFrame.size.height = curY;
    self.stationContentView.frame = contentFrame;
    self.scrollView.contentSize = contentFrame.size;
};

- (IBAction)onGoToSitePressed:(id)sender{
    NSString *site = self.stationInfo.site;
    if(site){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:site]];
    };
};

- (IBAction)onShowOnMapPressed:(id)sender{
    HSStationsMapViewController *mapViewConroller =
            [[HSStationsMapViewController alloc] initWithStations:[NSArray arrayWithObject:self.stationInfo]];
    [self.navigationController pushViewController:mapViewConroller animated:YES];
};

@end
