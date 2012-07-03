/*--------------------------------------------------*/

#import "HSView.h"

/*--------------------------------------------------*/

@interface HSControl : UIView
{
    struct
    {
        NSUInteger disabled : 1;
        NSUInteger selected : 1;
    } mState;
    UIColor *mNormalBackgroudColor;
    UIImage *mNormalBackgroudImage;
    UIColor *mSelectedBackgroudColor;
    UIImage *mSelectedBackgroudImage;
    UIColor *mDisabledBackgroudColor;
    UIImage *mDisabledBackgroudImage;
}

@end

/*--------------------------------------------------*/
