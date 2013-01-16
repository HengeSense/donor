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
{
    PFObject *content;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIWebView *newBodyWebView;
    IBOutlet UIView *newsView;
    IBOutlet UIView *adsView;
    
    //share
    IBOutlet UIView *sharingView;
    
}

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)showAtMapPressed:(id)sender;

- (IBAction)shareButtonSelected:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedNew:(PFObject *)selectedNew;

- (NSString *)stringByStrippingHTML:(NSString *)inputString;

@end
