/*--------------------------------------------------*/

#import "HSControl.h"

/*--------------------------------------------------*/

@interface HSActivityView : HSControl
{
    UIActivityIndicatorView *mIndicator;
    UILabel *mLabel;
}

@property (nonatomic, readwrite, strong) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, readwrite, strong) IBOutlet UILabel *label;

@end

/*--------------------------------------------------*/
