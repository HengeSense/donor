/*--------------------------------------------------*/

#import "HSControl.h"

/*--------------------------------------------------*/

@implementation HSControl

#pragma mark Property synthesize



#pragma mark -
#pragma mark UIView

- (id) initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if(self != nil)
    {
        mState.disabled = 0;
        mState.selected = 0;
        mNormalBackgroudColor = [self backgroundColor];
        mNormalBackgroudImage = nil;
        mSelectedBackgroudColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:1.00f];
        mSelectedBackgroudImage = nil;
        mDisabledBackgroudColor = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.00f];
        mDisabledBackgroudImage = nil;
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        mState.disabled = 0;
        mState.selected = 0;
        mNormalBackgroudColor = [self backgroundColor];
        mNormalBackgroudImage = nil;
        mSelectedBackgroudColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:1.00f];
        mSelectedBackgroudImage = nil;
        mDisabledBackgroudColor = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.00f];
        mDisabledBackgroudImage = nil;
    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(context != nil)
    {
        UIColor *currentColor = mNormalBackgroudColor;
        UIImage *currentImage = mNormalBackgroudImage;
        if(mState.disabled == 1)
        {
            currentColor = mDisabledBackgroudColor;
            currentImage = mDisabledBackgroudImage;
        }
        else if(mState.selected == 1)
        {
            currentColor = mDisabledBackgroudColor;
            currentImage = mDisabledBackgroudImage;
        }
        if(currentColor != nil)
        {
            CGContextSetFillColorWithColor(context, [currentColor CGColor]);
            CGContextFillRect(context, rect);
        }
        if(currentImage != nil)
        {
            CGContextDrawImage(context, rect, [currentImage CGImage]);
        }
    }
}

#pragma mark -

@end

/*--------------------------------------------------*/
