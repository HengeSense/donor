/*--------------------------------------------------*/

#import "HSPullView.h"

/*--------------------------------------------------*/

#import "HSPanGestureRecognizer.h"
#import "HSTapGestureRecognizer.h"

/*--------------------------------------------------*/

#include "HSUtility.h"

/*--------------------------------------------------*/

@implementation HSPullView

#pragma mark Property synthesize

@synthesize panRecognizer = mPanRecognizer;
@synthesize tapRecognizer = mTapRecognizer;
@synthesize recognizerEnable = mRecognizerEnable;
@synthesize delegate = mDelegate;
@synthesize target = mTarget;
@synthesize direction = mDirection;
@synthesize origin = mOrigin;
@synthesize offset = mOffset;
@synthesize opened = mOpened;
@synthesize animation = mAnimation;
@synthesize duration = mDuration;

#pragma mark -
#pragma mark Property setter/getter

- (void) setRecognizerEnable:(BOOL)recognizerEnable
{
    if(mRecognizerEnable != recognizerEnable)
    {
        [mTapRecognizer setEnabled:recognizerEnable];
        mRecognizerEnable = recognizerEnable;
    }
}

- (void) setOpened:(BOOL)opened
{
    [self setOpened:opened animated:mAnimation];
}

#pragma mark -
#pragma mark UIView

- (id) initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if(self != nil)
    {
        mRecognizerEnable = YES;
        mPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerPan:)];
        [self addGestureRecognizer:mPanRecognizer];
        mTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerTap:)];
        [self addGestureRecognizer:mTapRecognizer];
        
        mTarget = self;
        mDirection = HSPullDirectionTop;
        mOrigin = [self center];
        mOffset = 100.0f;
        mOpened = NO;
        
        mAnimation = YES;
        mDuration = 0.2;
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        mRecognizerEnable = YES;
        mPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerPan:)];
        [self addGestureRecognizer:mPanRecognizer];
        mTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerTap:)];
        [self addGestureRecognizer:mTapRecognizer];
        
        mTarget = self;
        mDirection = HSPullDirectionTop;
        mOrigin = [self center];
        mOffset = 100.0f;
        mOpened = NO;
        
        mAnimation = YES;
        mDuration = 0.2;
    }
    return self;
}

#pragma mark -

- (void) gestureRecognizerPan:(UIPanGestureRecognizer*)sender
{
    CGPoint position;
    
    if([sender state] == UIGestureRecognizerStateBegan)
    {
        mStartPos = [mTarget center];
        mMinPos = [self centerWithOpened:NO];
        mMaxPos = [self centerWithOpened:YES];
        HS_SWAP_IS_MORE(CGFloat, mMinPos.x, mMaxPos.x);
        HS_SWAP_IS_MORE(CGFloat, mMinPos.y, mMaxPos.y);
    }
    else if([sender state] == UIGestureRecognizerStateChanged)
    {
        CGPoint translate = [sender translationInView:[mTarget superview]];
        switch(mDirection)
        {
            case HSPullDirectionTop:
            case HSPullDirectionBottom:
                position = CGPointMake(mStartPos.x, mStartPos.y + translate.y);
                if(position.y < mMinPos.y)
                {
                    translate = CGPointMake(0, mMinPos.y - mStartPos.y);
                    position.y = mMinPos.y;
                }
                if(position.y > mMaxPos.y)
                {
                    translate = CGPointMake(0, mMaxPos.y - mStartPos.y);
                    position.y = mMaxPos.y;
                }
                break;
            case HSPullDirectionLeft:
            case HSPullDirectionRight:
                position = CGPointMake(mStartPos.x + translate.x, mStartPos.y);
                if(position.x < mMinPos.x)
                {
                    translate = CGPointMake(mMinPos.x - mStartPos.x, 0);
                    position.x = mMinPos.x;
                }
                if(position.x > mMaxPos.x)
                {
                    translate = CGPointMake(mMaxPos.x - mStartPos.x, 0);
                    position.x = mMaxPos.x;
                }
                break;
        }
        [sender setTranslation:translate inView:[mTarget superview]];
        [mTarget setCenter:position];
    }
    else if([sender state] == UIGestureRecognizerStateEnded)
    {
        position = [sender velocityInView:[mTarget superview]];
        switch(mDirection)
        {
            case HSPullDirectionTop:
                mOpened = (position.y > 0.0f);
                break;
            case HSPullDirectionRight:
                mOpened = (position.x < 0.0f);
                break;
            case HSPullDirectionBottom:
                mOpened = (position.y < 0.0f);
                break;
            case HSPullDirectionLeft:
                mOpened = (position.x > 0.0f);
                break;
        }
        [self setOpened:mOpened];
    }
}

- (void) gestureRecognizerTap:(UITapGestureRecognizer*)sender
{
    if([sender state] == UIGestureRecognizerStateEnded)
    {
        [self setOpened:!mOpened];
    }
}

#pragma mark -

- (void) setOpened:(BOOL)opened animated:(BOOL)animated
{
    mOpened = opened;
    if(animated == YES)
    {
        [mPanRecognizer setEnabled:NO];
        [mTapRecognizer setEnabled:NO];
        [UIView animateWithDuration:mDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [mTarget setCenter:[self centerWithOpened:mOpened]];
                         }
                         completion:^(BOOL finished) {
                             [mPanRecognizer setEnabled:mRecognizerEnable];
                             [mTapRecognizer setEnabled:mRecognizerEnable];
                             [self delegateDidChangeState:mOpened];
                         }];
    }
    else
    {
        [mTarget setCenter:[self centerWithOpened:mOpened]];
        [self delegateDidChangeState:mOpened];
    }
}

#pragma mark -

- (CGPoint) centerWithOpened:(BOOL)opened
{
    CGPoint point = mOrigin;
    switch(mDirection)
    {
        case HSPullDirectionTop:
            if(opened == YES)
            {
                point.y += mOffset;
            }
            break;
        case HSPullDirectionRight:
            if(opened == YES)
            {
                point.x += mOffset;
            }
            break;
        case HSPullDirectionBottom:
            if(opened == YES)
            {
                point.y -= mOffset;
            }
            break;
        case HSPullDirectionLeft:
            if(opened == YES)
            {
                point.x -= mOffset;
            }
            break;
    }
    return point;
}

- (CGRect) frameWithOpened:(BOOL)opened
{
    CGRect rect = [mTarget frame];
    rect.origin = [self centerWithOpened:opened];
    return rect;
}

- (CGRect) boundsWithOpened:(BOOL)opened
{
    CGRect rect = [mTarget bounds];
    rect.origin = [self centerWithOpened:opened];
    return rect;
}

#pragma mark -

- (void) delegateDidChangeState:(BOOL)opened
{
    if([mDelegate respondsToSelector:@selector(pullView:didChangeState:)])
    {
        [mDelegate pullView:self didChangeState:mOpened];
    }
}

#pragma mark -

@end

/*--------------------------------------------------*/
