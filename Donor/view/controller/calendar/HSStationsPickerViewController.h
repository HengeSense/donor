//
//  HSStationsPickerViewController.h
//  Donor
//
//  Created by Sergey Seroshtan on 18.05.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSStationsViewController.h"
#import "HSPicker.h"

@interface HSStationsPickerViewController : HSStationsViewController <HSPicker>

/**
 * Handles navigation controller in which it will be shown by [HSPicker showWithCompletion] method invokation.
 */
@property (nonatomic, strong) UINavigationController *rootNavigationController;

@end
