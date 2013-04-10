//
//  HSEventShortInfoView.m
//  Donor
//
//  Created by Sergey Seroshtan on 08.04.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSEventShortInfoView.h"

#import "HSEvent.h"
#import "HSBloodDonationEvent.h"
#import "HSBloodTestsEvent.h"
#import "HSEventRenderer.h"

@interface HSEventShortInfoView ()

@property (nonatomic, strong) HSEvent *event;
@property (nonatomic, strong) NSString *eventShortDescription;
@property (nonatomic, strong) UIImage *eventIconImage;

@end

@implementation HSEventShortInfoView

#pragma mark - Initialization
- (id)initWithEvent:(HSEvent *)event {
    self = [[[NSBundle mainBundle] loadNibNamed:@"HSEventShortInfoView" owner:self options:nil] lastObject];
    THROW_IF_ARGUMENT_NIL(event);
    if (self) {
        [self configurePropertiesWithEvent:event];
        self.showHeaderLine = NO;
        self.showFooterLine = NO;
    }
    return self;
}

#pragma mark - UI drawing
- (void)layoutSubviews {
    self.descriptionLabel.text = self.eventShortDescription;
    if (self.eventIconImage != nil) {
        self.eventIconImageView.image = self.eventIconImage;
    }
    self.eventIconImageView.hidden = self.eventIconImage == nil;
    self.headerLineImageView.hidden = !self.showHeaderLine;
    self.footerLinemageView.hidden = !self.showFooterLine;
    
    [super layoutSubviews];
}

#pragma mark - Private
#pragma mark - Configuration
- (void)configurePropertiesWithEvent:(HSEvent *)event {
    THROW_IF_ARGUMENT_NIL(event);
    HSEventRenderer *eventRenderer = [HSEventRenderer createEventRendererForEvent:event];
    self.eventIconImage = [eventRenderer eventImage];
    self.eventShortDescription = [eventRenderer eventShortDescription];
}

@end