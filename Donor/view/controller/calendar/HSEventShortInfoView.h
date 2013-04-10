//
//  HSEventShortInfoView.h
//  Donor
//
//  Created by Sergey Seroshtan on 08.04.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSEvent;

@interface HSEventShortInfoView : UIView

/// @name UI properties
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *footerLinemageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerLineImageView;

/// @name Configuration properties
/**
 * Defines whether show header line or not.
 * Default: is shown.
 */
@property (nonatomic, assign) BOOL showHeaderLine;

/**
 * Defines whether show footer line or not.
 * Default: is hidden.
 */
@property (nonatomic, assign) BOOL showFooterLine;

/// @name Initialization
/**
 * Creates and configures HSEventShortInfoView with event.
 */
- (id)initWithEvent:(HSEvent *)event;

@end
