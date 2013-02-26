//
//  HSContactView.h
//  Donor
//
//  Created by Sergey Seroshtan on 26.02.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSContactView : UIView

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

/**
 * Specifies contact. Should be in HTML format.
 */
@property (nonatomic, strong) NSString *contact;

/**
 * Specifies contact's title (phone, email, etc).
 */
@property (nonatomic, strong) NSString *contactTile;

/// @name Initialization
/**
 * Creates and configures HSContactView with contact (HTML) and it's title.
 */
- (id)initWithContact:(NSString *)contact contactTitle:(NSString *)contactTitle;

@end
