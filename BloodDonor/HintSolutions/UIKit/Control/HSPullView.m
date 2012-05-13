/*--------------------------------------------------*/

#import "HSPullView.h"

/*--------------------------------------------------*/

#import "HSView.h"

/*--------------------------------------------------*/

#import "HSPanGestureRecognizer.h"
#import "HSTapGestureRecognizer.h"

/*--------------------------------------------------*/

CG_INLINE CGPoint
CGPointMakeFromRectCenter(CGRect rect)
{
    CGPoint p;
    p.x = rect.origin.x + (rect.size.width * 0.5f);
    p.y = rect.origin.y + (rect.size.height * 0.5f);
    return p;
}

/*--------------------------------------------------*/

@implementation HSPullView

#pragma mark Property synthesize

@synthesize dragRecognizer = mDragRecognizer;
@synthesize tapRecognizer = mTapRecognizer;
@synthesize delegate = mDelegate;
@synthesize superViewFrame = mSuperViewFrame;
@synthesize headerSize = mHeaderSize;
@synthesize direction = mDirection;
@synthesize toggleOnTap = mToggleOnTap;
@synthesize opened = mOpened;
@synthesize animation = mAnimation;
@synthesize duration = mDuration;
@synthesize handleView = mHandleView;
@synthesize clientView = mClientView;

#pragma mark -
#pragma mark Property setter/getter

- (void) setSuperViewFrame:(CGRect)superViewFrame
{
    if(CGRectEqualToRect(mSuperViewFrame, superViewFrame) == NO)
    {
        mSuperViewFrame = superViewFrame;
        [self setFrame:[self frameWithSuperViewFrame:mSuperViewFrame
                                          headerSize:mHeaderSize
                                           direction:mDirection
                                              opened:mOpened]];
        switch(mDirection)
        {
            case HSPullDirectionLeft:
            case HSPullDirectionTop:
                mMinPos = [self centerWithSuperViewFrame:mSuperViewFrame
                                              headerSize:mHeaderSize
                                               direction:mDirection
                                                  opened:NO];
                mMaxPos = [self centerWithSuperViewFrame:mSuperViewFrame
                                              headerSize:mHeaderSize
                                               direction:mDirection
                                                  opened:YES];
                break;
            case HSPullDirectionRight:
            case HSPullDirectionBottom:
                mMinPos = [self centerWithSuperViewFrame:mSuperViewFrame
                                              headerSize:mHeaderSize
                                               direction:mDirection
                                                  opened:YES];
                mMaxPos = [self centerWithSuperViewFrame:mSuperViewFrame
                                              headerSize:mHeaderSize
                                               direction:mDirection
                                                  opened:NO];
                break;
        }
    }
}

#pragma mark -

+ (id) viewWithSuperViewFrame:(CGRect)superViewFrame
                   headerSize:(CGFloat)headerSize
                    direction:(HSPullDirection)direction
                       opened:(BOOL)opened
{
    return [[[self alloc] initWithSuperViewFrame:superViewFrame
                                      headerSize:headerSize
                                       direction:direction
                                          opened:opened] autorelease];
}

- (id) initWithSuperViewFrame:(CGRect)superViewFrame
                   headerSize:(CGFloat)headerSize
                    direction:(HSPullDirection)direction
                       opened:(BOOL)opened
{
    CGRect frame = [self frameWithSuperViewFrame:superViewFrame
                                      headerSize:headerSize
                                       direction:direction
                                          opened:opened];
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        mSuperViewFrame = superViewFrame;
        mHeaderSize = headerSize;
        mDirection = direction;
        mOpened = opened;
        mToggleOnTap = YES;
        mAnimation = YES;
        mDuration = 0.2;
        
        /**********************/
        
        switch(mDirection)
        {
            case HSPullDirectionLeft:
            case HSPullDirectionTop:
                mMinPos = [self centerWithSuperViewFrame:mSuperViewFrame
                                              headerSize:mHeaderSize
                                               direction:mDirection
                                                  opened:NO];
                mMaxPos = [self centerWithSuperViewFrame:mSuperViewFrame
                                              headerSize:mHeaderSize
                                               direction:mDirection
                                                  opened:YES];
                break;
            case HSPullDirectionRight:
            case HSPullDirectionBottom:
                mMinPos = [self centerWithSuperViewFrame:mSuperViewFrame
                                              headerSize:mHeaderSize
                                               direction:mDirection
                                                  opened:YES];
                mMaxPos = [self centerWithSuperViewFrame:mSuperViewFrame
                                              headerSize:mHeaderSize
                                               direction:mDirection
                                                  opened:NO];
                break;
        }
        
        /**********************/
        
        [self setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self setAutoresizesSubviews:YES];
        
        /**********************/
        
        CGRect handleFrame = CGRectZero;
        UIViewAutoresizing handleAutoresizeMask = UIViewAutoresizingNone;
        switch(mDirection)
        {
            case HSPullDirectionLeft:
                handleFrame = CGRectMake(frame.size.width - headerSize, 0.0f, headerSize, frame.size.height);
                handleAutoresizeMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
                break;
            case HSPullDirectionTop:
                handleFrame = CGRectMake(0.0f, frame.size.height - headerSize, frame.size.width, headerSize);
                handleAutoresizeMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
                break;
            case HSPullDirectionRight:
                handleFrame = CGRectMake(0.0f, 0.0f, headerSize, frame.size.height);
                handleAutoresizeMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
                break;
            case HSPullDirectionBottom:
                handleFrame = CGRectMake(0.0f, 0.0f, frame.size.width, headerSize);
                handleAutoresizeMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
                break;
        }
        mHandleView = [UIView viewWithFrame:handleFrame];
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
            
            [mHandleView setAutoresizingMask:handleAutoresizeMask];
            [mHandleView setAutoresizesSubviews:YES];
            [self addSubview:mHandleView];
        }
        
        /**********************/

        CGRect clientFrame = CGRectZero;
        UIViewAutoresizing clientAutoresizeMask = UIViewAutoresizingNone;
        switch(mDirection)
        {
            case HSPullDirectionLeft:
                clientFrame = CGRectMake(0.0f, 0.0f, frame.size.width - headerSize, frame.size.height);
                clientAutoresizeMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
                break;
            case HSPullDirectionTop:
                clientFrame = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height - headerSize);
                clientAutoresizeMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
                break;
            case HSPullDirectionRight:
                clientFrame = CGRectMake(headerSize, 0.0f, frame.size.width - headerSize, frame.size.height);
                clientAutoresizeMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
                break;
            case HSPullDirectionBottom:
                clientFrame = CGRectMake(0.0f, headerSize, frame.size.width, frame.size.height - headerSize);
                clientAutoresizeMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
                break;
        }
        mClientView = [UIView viewWithFrame:clientFrame];
        if(mClientView != nil)
        {
            [mClientView setAutoresizingMask:clientAutoresizeMask];
            [mClientView setAutoresizesSubviews:YES];
            
            [self addSubview:mClientView];
        }
        
        /**********************/
    }
    return self;
}

- (void) gestureRecognizerDrag:(UIPanGestureRecognizer*)sender
{
    if([sender state] == UIGestureRecognizerStateBegan)
    {
        mStartPos = [self center];
    }
    else if([sender state] == UIGestureRecognizerStateChanged)
    {
        CGPoint position;
        CGPoint translate = [sender translationInView:[self superview]];
        switch(mDirection)
        {
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
        }
        [sender setTranslation:translate inView:self.superview];
        [self setCenter:position];
    }
    else if([sender state] == UIGestureRecognizerStateEnded)
    {
        CGPoint vector = [sender velocityInView:[self superview]];
        switch(mDirection)
        {
            case HSPullDirectionLeft:
                mOpened = (vector.x > 0.0f);
                break;
            case HSPullDirectionTop:
                mOpened = (vector.y > 0.0f);
                break;
            case HSPullDirectionRight:
                mOpened = (vector.x < 0.0f);
                break;
            case HSPullDirectionBottom:
                mOpened = (vector.y < 0.0f);
                break;
        }
        [self setOpened:mOpened animated:mAnimation];
    }
}

- (void) gestureRecognizerTap:(UITapGestureRecognizer*)sender
{
    if([sender state] == UIGestureRecognizerStateEnded)
    {
        [self setOpened:!mOpened animated:mAnimation];
    }
}

- (void) setToggleOnTap:(BOOL)tap
{
    mToggleOnTap = tap;
    [mTapRecognizer setEnabled:tap];
}

- (CGRect) frameWithSuperViewFrame:(CGRect)superViewFrame
                        headerSize:(CGFloat)headerSize
                         direction:(HSPullDirection)direction
                            opened:(BOOL)opened
{
    CGRect frame = CGRectMake(0.0f, 0.0f, superViewFrame.size.width, superViewFrame.size.height);
    switch(direction)
    {
        case HSPullDirectionTop:
        case HSPullDirectionBottom:
            frame.origin.x = (superViewFrame.size.width * 0.5f) - (frame.size.width * 0.5f);
            break;
        case HSPullDirectionLeft:
        case HSPullDirectionRight:
            frame.origin.y = (superViewFrame.size.height * 0.5f) - (frame.size.height * 0.5f);
            break;
    }
    switch(direction)
    {
        case HSPullDirectionLeft:
            frame.origin.x = (opened == YES) ? 0.0f : (-frame.size.width) + headerSize;
            break;
        case HSPullDirectionTop:
            frame.origin.y = (opened == YES) ? 0.0f : (-frame.size.height) + headerSize;
            break;
        case HSPullDirectionRight:
            frame.origin.x = (opened == YES) ? 0.0f : frame.size.width - headerSize;
            break;
        case HSPullDirectionBottom:
            frame.origin.y = (opened == YES) ? 0.0f : frame.size.height - headerSize;
            break;
    }
    return frame;
}

- (CGPoint) centerWithSuperViewFrame:(CGRect)superViewFrame
                          headerSize:(CGFloat)headerSize
                           direction:(HSPullDirection)direction
                              opened:(BOOL)opened
{
    CGRect frame = [self frameWithSuperViewFrame:superViewFrame
                                      headerSize:headerSize
                                       direction:direction
                                          opened:opened];
    return CGPointMakeFromRectCenter(frame);
}

- (void) setOpened:(BOOL)opened animated:(BOOL)animated
{
    mOpened = opened;
    if(animated == YES)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:mDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    }
    [self setCenter:[self centerWithSuperViewFrame:mSuperViewFrame
                                        headerSize:mHeaderSize
                                         direction:mDirection
                                            opened:mOpened]];
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

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    if([self superview] != nil)
    {
        [self setSuperViewFrame:[[self superview] frame]];
    }
}

@end

/*--------------------------------------------------*/
