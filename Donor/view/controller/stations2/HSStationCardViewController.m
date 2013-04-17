//
//  HSStationCardViewController.m
//  Donor
//
//  Created by Eugine Korobovsky on 09.04.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSStationCardViewController.h"
#import "HSStationsMapViewController.h"
#import "StationsDefs.h"

@interface HSStationCardViewController ()

@end

@implementation HSStationCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isShowAllInfoForced = NO;
        _isMapButtonInitiallyHidden = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Станция";
    
    [self.scrollView addSubview:_stationContentView];
    _scrollView.contentSize = _stationContentView.bounds.size;
    
}

// return result label height
/*- (float)correctFrameForLabel:(UILabel *)label withFontSize:(float)fontSize withMaximumLines:(NSUInteger)maxLines{
    float tmpFontSize = fontSize;
    label.font = BOLD_FONT_WITH_SIZE(tmpFontSize);
    while([label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.bounds.size.width, 100500) lineBreakMode:label.lineBreakMode].height > (tmpFontSize*maxLines)){
        tmpFontSize -= 0.5f;
        if(tmpFontSize<minimumFontSize) break;
        _phoneLabel.font = BOLD_FONT_WITH_SIZE(tmpFontSize);
    };
    
    return label.bounds.size.height;
};*/


- (void)setFrameForLabel:(UILabel *)oneLabel atYcoord:(float)y{
    CGSize labelSize = [oneLabel.text sizeWithFont:oneLabel.font constrainedToSize:CGSizeMake(oneLabel.bounds.size.width, 100500) lineBreakMode:oneLabel.lineBreakMode];
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
    if(_stationDictionary){
        _nameLabel.text = [_stationDictionary objectForKey:@"name"] ? [_stationDictionary objectForKey:@"name"] : @" ";
        _regionLabel.text = [_stationDictionary objectForKey:@"region_name"] ? [_stationDictionary objectForKey:@"region_name"] : @" ";
        _districtLabel.text = [_stationDictionary objectForKey:@"district_name"] ? [_stationDictionary objectForKey:@"district_name"] : @" ";
        _townLabel.text = [_stationDictionary objectForKey:@"town"] ? [_stationDictionary objectForKey:@"town"] : @" ";
        _addressLabel.text = [_stationDictionary objectForKey:@"address"] ? [_stationDictionary objectForKey:@"address"] : @" ";
        _phoneLabel.text = [_stationDictionary objectForKey:@"phone"] ? [_stationDictionary objectForKey:@"phone"] : @" ";
        _workhoursLabel.text = [_stationDictionary objectForKey:@"work_time"] ? [_stationDictionary objectForKey:@"work_time"] : @" ";
        _citeLabel.text = [_stationDictionary objectForKey:@"site"] ? [_stationDictionary objectForKey:@"site"] : @" ";
        
        float curY = 10.0;
        [self setFrameForLabel:_nameLabel atYcoordChange:&curY];
        [self setFrameForView:_dottedLine1 atYcoordChange:&curY];
        curY += 10.0;
        
        BOOL isHideRegionArea = NO;
        if(_isShowAllInfoForced==NO){
            int curRegionId = [[_stationDictionary objectForKey:@"region_id"] integerValue];
            if(curRegionId==35 || curRegionId==79){
                isHideRegionArea = YES;
            };
        };
        if(isHideRegionArea == NO){
            [self setFrameForLabel:_regionTitle atYcoord:curY];
            [self setFrameForLabel:_regionLabel atYcoordChange:&curY];
            [self setFrameForLabel:_districtTitle atYcoord:curY];
            [self setFrameForLabel:_districtLabel atYcoordChange:&curY];
            [self setFrameForLabel:_townTitle atYcoord:curY];
            [self setFrameForLabel:_townLabel atYcoordChange:&curY];
            curY+=10.0;
        }
        [_regionTitle setHidden:isHideRegionArea];
        [_regionLabel setHidden:isHideRegionArea];
        [_districtTitle setHidden:isHideRegionArea];
        [_districtLabel setHidden:isHideRegionArea];
        [_townTitle setHidden:isHideRegionArea];
        [_townLabel setHidden:isHideRegionArea];
        
        [self setFrameForLabel:_addressTitle atYcoord:curY];
        [self setFrameForLabel:_addressLabel atYcoordChange:&curY];
        [self setFrameForLabel:_phoneTitle atYcoord:curY];
        [self setFrameForLabel:_phoneLabel atYcoordChange:&curY];
        curY+=10.0;
        
        [self setFrameForView:_dottedLine3 atYcoordChange:&curY];
        [self setFrameForLabel:_workhoursTitle atYcoord:curY];
        [self setFrameForLabel:_workhoursLabel atYcoordChange:&curY];
        [self setFrameForView:_dottedLine4 atYcoordChange:&curY];
        
        
        
        
        BOOL isSiteHidden = NO;
        if(![_stationDictionary objectForKey:@"site"] || ![[_stationDictionary objectForKey:@"site"] isKindOfClass:[NSString class]] || [[_stationDictionary objectForKey:@"site"] isEqualToString:@""]){
            isSiteHidden = YES;
        }else{
            isSiteHidden = NO;
            [self setFrameForLabel:_citeTitle atYcoord:curY];
            [self setFrameForLabel:_citeLabel atYcoordChange:&curY];
        }
        [_citeTitle setHidden:isSiteHidden];
        [_citeLabel setHidden:isSiteHidden];
        [_goToSiteButton setHidden:isSiteHidden];
        
        curY+=20.0;
        [_showOnMapButton setHidden:_isMapButtonInitiallyHidden];
        [self setFrameForView:_showOnMapButton atYcoordChange:&curY];
        curY+=20.0;
    
        
        CGRect contentFrame = _stationContentView.frame;
        contentFrame.size.height = curY;
        _stationContentView.frame = contentFrame;
        _scrollView.contentSize = contentFrame.size;
        
        /*if(_isShowAllInfoForced==NO){
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
        
        float tmpFontSize = 14.5f;
        _phoneLabel.font = BOLD_FONT_WITH_SIZE(tmpFontSize);
        while([_phoneLabel.text sizeWithFont:_phoneLabel.font constrainedToSize:CGSizeMake(_phoneLabel.bounds.size.width, 100500) lineBreakMode:_phoneLabel.lineBreakMode].height > _phoneLabel.bounds.size.height){
            tmpFontSize -= 0.5f;
            if(tmpFontSize<12.0f) break;
            _phoneLabel.font = BOLD_FONT_WITH_SIZE(tmpFontSize);
        };
        
        tmpFontSize = 14.5f;
        _workhoursLabel.font = BOLD_FONT_WITH_SIZE(tmpFontSize);
        while([_workhoursLabel.text sizeWithFont:_workhoursLabel.font constrainedToSize:CGSizeMake(_workhoursLabel.bounds.size.width, 100500) lineBreakMode:_workhoursLabel.lineBreakMode].height > _workhoursLabel.bounds.size.height){
            tmpFontSize -= 0.5f;
            if(tmpFontSize<12.0f) break;
            _workhoursLabel.font = BOLD_FONT_WITH_SIZE(tmpFontSize);
        };*/
            
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
