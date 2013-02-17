//
//  InfoSubViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 30.07.12.
//
//

#import <UIKit/UIKit.h>

@protocol IInfoSubViewListener <NSObject>

- (void) nextViewSelected:(int)viewId;

@end

@interface InfoSubViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *siteLinkWebView;
    IBOutlet UIWebView *phoneLinkWebView;
    IBOutlet UIWebView *emailLinkWebView;
}

@property (nonatomic, retain) id delegate;

- (IBAction)contraindicationListButtonPressed:(id)sender;
- (IBAction)recommendationsButtonPressed:(id)sender;

@end
