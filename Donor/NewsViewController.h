//
//  NewsViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 01.08.12.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NewsViewController : UIViewController <UIWebViewDelegate>

/// @name UI properties
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIWebView *newsBodyWebView;
@property (nonatomic, weak) IBOutlet UIView *newsView;
@property (nonatomic, weak) IBOutlet UIView *adsView;

/// @name Conten 
@property (nonatomic, strong) PFObject *content;

/// @name Actions
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)showAtMapPressed:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedNew:(PFObject *)selectedNew;

- (NSString *)stringByStrippingHTML:(NSString *)inputString;

@end
