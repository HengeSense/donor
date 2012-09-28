//
//  MessageBoxViewController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 09.08.12.
//
//

#import <UIKit/UIKit.h>

@protocol MessageBoxDelegate;

@interface MessageBoxViewController : UIViewController
{
    NSString *titleString;
    NSString *textString;
    NSString *cancelString;
    NSString *okString;
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *textWithTitle;
    IBOutlet UILabel *textWithoutTitle;
    
    IBOutlet UIButton *singleButton;
    IBOutlet UIButton *doubleButtonOk;
    IBOutlet UIButton *doubleButtonCancel;
}

@property (nonatomic, assign) id <MessageBoxDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                title:(NSString *)title
              message:(NSString *)message
         cancelButton:(NSString *)cancelButton
             okButton:(NSString *)okButton;

- (IBAction)okClick:(id)sender;
- (IBAction)cancelClick:(id)sender;

@end

@protocol MessageBoxDelegate <NSObject>

- (void)messageBoxResult:(BOOL)result controller:(MessageBoxViewController *)controller message:(NSString *)message;

@end