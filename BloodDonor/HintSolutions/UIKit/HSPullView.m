/*--------------------------------------------------*/

#import "HSPullView.h"

/*--------------------------------------------------*/

#import "HSView.h"
#import "HSPanGestureRecognizer.h"
#import "HSTapGestureRecognizer.h"

/*--------------------------------------------------*/

@implementation HSPullView

@synthesize dragRecognizer = mDragRecognizer;
@synthesize tapRecognizer = mTapRecognizer;
@synthesize delegate = mDelegate;
@synthesize handleView = mHandleView;
@synthesize openedCenter = mOpenedCenter;
@synthesize closedCenter = mClosedCenter;
@synthesize toggleOnTap = mToggleOnTap;
@synthesize animate = mAnimate;
@synthesize duration = mDuration;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        mOpened = NO;
        mToggleOnTap = YES;
        mAnimate = YES;
        mDuration = 0.2;
        
        mHandleView = [UIView viewWithFrame:CGRectMake(0, frame.size.height - 40, frame.size.width, 40)];
        if(mHandleView != nil)
        {
            mDragRecognizer = [UIPanGestureRecognizer gestureRecognizerWithTarget:self action:@selector(gestureRecognizerDrag:)];
            if(mDragRecognizer != nil)
            {
                [mDragRecognizer setMinimumNumberOfTouches:1];
                [mDragRecognizer setMaximumNumberOfTouches:1];
                
                [mHandleView addGestureRecognizer:mDragRecognizer];
            }
            mTapRecognizer = [UITapGestureRecognizer gestureRecognizerWithTarget:self action:@selector(gestureRecognizerTap:)];
            if(mTapRecognizer != nil)
            {
                [mTapRecognizer setNumberOfTouchesRequired:1];
                [mTapRecognizer setNumberOfTapsRequired:1];
                
                [mHandleView addGestureRecognizer:mTapRecognizer];
            }
            [self addSubview:mHandleView];
        }
    }
    return self;
}

- (void) gestureRecognizerDrag:(UIPanGestureRecognizer*)sender
{
    if([sender state] == UIGestureRecognizerStateBegan)
    {
        mStartPos = [self center];
        mVerticalAxis = (mClosedCenter.x == mOpenedCenter.x);
        if(mVerticalAxis == YES)
        {
            mMinPos = ((mClosedCenter.y < mOpenedCenter.y) ? mClosedCenter : mOpenedCenter);
            mMaxPos = ((mClosedCenter.y > mOpenedCenter.y) ? mClosedCenter : mOpenedCenter);
        }
        else
        {
            mMinPos = ((mClosedCenter.x < mOpenedCenter.x) ? mClosedCenter : mOpenedCenter);
            mMaxPos = ((mClosedCenter.x > mOpenedCenter.x) ? mClosedCenter : mOpenedCenter);
        }
    }
    else if([sender state] == UIGestureRecognizerStateChanged)
    {
        CGPoint newPos;
        CGPoint translate = [sender translationInView:[self superview]];
        if(mVerticalAxis == YES)
        {
            newPos = CGPointMake(mStartPos.x, mStartPos.y + translate.y);
            if(newPos.y < mMinPos.y)
            {
                newPos.y = mMinPos.y;
                translate = CGPointMake(0, newPos.y - mStartPos.y);
            }
            if(newPos.y > mMaxPos.y)
            {
                newPos.y = mMaxPos.y;
                translate = CGPointMake(0, newPos.y - mStartPos.y);
            }
        }
        else
        {
            newPos = CGPointMake(mStartPos.x + translate.x, mStartPos.y);
            if(newPos.x < mMinPos.x)
            {
                newPos.x = mMinPos.x;
                translate = CGPointMake(newPos.x - mStartPos.x, 0);
            }
            if(newPos.x > mMaxPos.x)
            {
                newPos.x = mMaxPos.x;
                translate = CGPointMake(newPos.x - mStartPos.x, 0);
            }
        }
        [sender setTranslation:translate inView:self.superview];
        self.center = newPos;
        
    }
    else if([sender state] == UIGestureRecognizerStateEnded)
    {
        CGPoint vectorVelocity = [sender velocityInView:self.superview];
        CGFloat axisVelocity = (mVerticalAxis == YES) ? vectorVelocity.y : vectorVelocity.x;
        CGPoint target = axisVelocity < 0 ? mMinPos : mMaxPos;
        BOOL op = CGPointEqualToPoint(target, mOpenedCenter);
        [self setOpened:op animated:mAnimate];
    }
}

- (void) gestureRecognizerTap:(UITapGestureRecognizer*)sender
{
    if([sender state] == UIGestureRecognizerStateEnded)
    {
        [self setOpened:!mOpened animated:mAnimate];
    }
}

- (void) setToggleOnTap:(BOOL)tap
{
    mToggleOnTap = tap;
    [mTapRecognizer setEnabled:tap];
}

- (void) setOpened:(BOOL)state animated:(BOOL)animated
{
    mOpened = state;
    if(animated == YES)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:mDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    }
    [self setCenter:(mOpened == YES) ? mOpenedCenter : mClosedCenter];
    if(animated == YES)
    {
        [mDragRecognizer setEnabled:NO];
        [mTapRecognizer setEnabled:NO];
        [UIView commitAnimations];
    }
    else
    {
        if([mDelegate respondsToSelector:@selector(pullView:didChangeState:)])
        {
            [mDelegate pullView:self didChangeState:mOpened];
        }
    }
}
         
- (void) animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context
{
    if(finished != nil)
    {
        [mDragRecognizer setEnabled:YES];
        [mTapRecognizer setEnabled:mToggleOnTap];
        if([mDelegate respondsToSelector:@selector(pullView:didChangeState:)])
        {
            [mDelegate pullView:self didChangeState:mOpened];
        }
    }
}

@end

/*--------------------------------------------------*/
